(* ::Package:: *)

(* ::Section:: *)
(*Begin*)


BeginPackage["Yurie`Autocode`convertNotebookToWLT`"];


Needs["Yurie`Autocode`"];


(* ::Section:: *)
(*Public*)


convertNotebookToWLT::usage =
    "convert notebooks in the directory to *.wlt test files.";


(* ::Section:: *)
(*Private*)


(* ::Subsection:: *)
(*Begin*)


Begin["`Private`"];


(* ::Subsection:: *)
(*Constant*)


$privateContext = "Yurie`Autocode`Temp`";


(* ::Subsection:: *)
(*Option*)


convertNotebookToWLT//Options = {
    "ExcludedFile"->{},
    "PathLevelInTestID"->1
};


(* ::Subsection:: *)
(*Main*)


convertNotebookToWLT[dir:_?DirectoryQ|{__?DirectoryQ},targetDir_?DirectoryQ,opts:OptionsPattern[]] :=
    fileListFromDirectory[dir,OptionValue["ExcludedFile"]]//
        Query[All,<|#,"TestFile"->convertSingleNotebookToWLT[OptionValue["PathLevelInTestID"]][#File,targetDir]|>&]//
            Query[All,<|"IsSuccess"->!FailureQ[#TestFile],#|>&]//Dataset;


(* ::Subsection:: *)
(*Helper*)


convertSingleNotebookToWLT[pathLevelInTestID_][notebook_,targetDir_] :=
    WithCleanup[
        Catch@File@Export[
            FileNameJoin@{targetDir,FileBaseName[notebook]<>".wlt"},
            getTestStringFromNotebook[pathLevelInTestID][notebook],
            "Text"
        ],
        (*Delete the private context for each file separately.*)
        $ContextPath =
            DeleteCases[$ContextPath,$privateContext];
    ];


getTestStringFromNotebook[pathLevelInTestID_][notebook_] :=
    Module[ {notebookName},
        notebookName =
            If[ IntegerQ[pathLevelInTestID]&&pathLevelInTestID>=1,
                FileNameTake[notebook,-pathLevelInTestID],
                (*Else*)
                Throw@Failure[
                    "InvalidPathLevel",
                    <|"MessageTemplate"->"OptionValue[\"PathLevelInTestID\"] should be a positive integer."|>
                ]
            ];
        notebook//
            importCellListFromNotebook//
            trimCellList//
            groupCellListByOutput//
            groupedCellListToTestStringList[notebookName]//
            handleCellContext//
            postFormat[notebookName]
    ];


importCellListFromNotebook[notebook_] :=
    Module[ {cellList,cellTypeList,boxList,exprList},
        cellList =
            NotebookImport[notebook,_->"Cell"];
        cellTypeList =
            cellList//Extract[{All,2}];
        boxList =
            cellList//Extract[{All,1}];
        (*We first move the symbols into the private context when being imported as held expressions.*)
        (*The message cells contain context information of symbols, hence we need "BeginPackage" to add the private context to $ContextPath.*)
        BeginPackage[$privateContext];
        exprList =
            ReplaceAll[
                (*The "ToExpression" here is a trick for "BeginPackage" in scoping constructions.*)
                notebook//ToExpression["NotebookImport[#,_->\"HeldExpression\"]&"],
                {
                    HoldComplete[expr_]:>ToString[Unevaluated@expr,InputForm],
                    HoldComplete[exprs__]:>ToString[Unevaluated@CompoundExpression[exprs],InputForm]
                }
            ];
        EndPackage[];
        {cellTypeList,exprList,boxList}//Transpose//
            Query[All,<|"Type"->#[[1]],"Expr"->#[[2]],"Box"->#[[3]]|>&]
    ];


trimCellList[cellList_List] :=
    cellList//Query[Select[MatchQ[#Type,"Input"|"Code"|"Output"|"Message"]&]]//
        Query[All,
            If[ #Type==="Code",
                <|#,"Type"->"Input"|>,
                (*Else*)
                #
            ]&
        ];


(*group the cells by output cells.*)

groupCellListByOutput[cellList_List] :=
    Module[ {cellTypeList,positionList},
        cellTypeList =
            cellList//Query[All,#Type&];
        positionList =
            SequencePosition[cellTypeList,{"Output","Output"}][[All,1]]-1;
        If[ positionList=!={},
            Throw@Failure[
                "AdjacentOutput",
                <|
                    "MessageTemplate"->"There are adjacent outputs below the `Position`-th cells.",
                    "MessageParameters"-><|
                        "Position"->positionList
                    |>
                |>
            ]
        ];
        Split[cellList,(#1[["Type"]]=!="Output"&&#2[["Type"]]!="Input")&]
    ];


(* ::Subsubsection:: *)
(*Test string from cell list*)


groupedCellListToTestStringList[notebookName_][groupedCellList:{___List}] :=
    MapIndexed[cellListToTestString[notebookName][#1,First@#2]&,groupedCellList];


cellListToTestString[notebookName_][cellList_List,id_Integer] :=
    Module[ {msgString},
        msgString = getStringOf["Message",cellList];
        If[ msgString==="{}",
            templateOfTestString[{
                getStringOf["Input",cellList],
                getStringOf["Output",cellList],
                "TestID->"<>"\"["<>ToString[id]<>"] "<>notebookName<>"\""
            }],
            (*Else*)
            templateOfTestString[{
                getStringOf["Input",cellList],
                getStringOf["OutputThatCanSendMessage",cellList],
                msgString,
                "TestID->"<>"\"["<>ToString[id]<>"] "<>notebookName<>"\""
            }]
        ]
    ];


templateOfTestString[strList_List] :=
    StringRiffle[strList,{
        "VerificationTest[\n    ",
        "\n    ,\n    ",
        "\n]"
    }];


getStringOf["Input",cellList_List] :=
    cellList//Query[SelectFirst[#Type==="Input"&],#Expr&,FailureAction->"Replace"]//indentNewline2;

getStringOf["Output",cellList_List] :=
    cellList//Query[SelectFirst[#Type==="Output"&],#Expr&,FailureAction->"Replace"]//indentNewline;

getStringOf["OutputThatCanSendMessage",cellList_List] :=
    cellList//Query[SelectFirst[#Type==="Output"&],"Quiet["<>#Expr<>"]"&,FailureAction->"Replace"]//indentNewline;

getStringOf["Message",cellList_List] :=
    cellList//Query[Select[#Type==="Message"&],#Expr&]//Flatten//StringRiffle[#,{"{",",","}"}]&;


indentNewline[str_String] :=
    str//StringReplace["\n"->"\n    "];

indentNewline[missing_Missing] :=
    "Null";


indentNewline2[str_String] :=
    If[ StringContainsQ[str,"Null; "],
        StringSplit[str,"Null; "]//StringReplace[#,StartOfString~~"("~~any__~~"); ":>any]&//StringRiffle[#,"\n    "]&,
        (*Else*)
        str
    ];

indentNewline2[missing_Missing] :=
    "Null";


(* ::Subsubsection:: *)
(*Test string post-operation*)


handleCellContext[testStringList_List] :=
    testStringList//StringReplace["$CellContext`"->"Global`"];


postFormat[notebookName_][testStringList_List] :=
    "\n\n(* "<>notebookName<>" *)\n\n"<>
        beginGlobalContext[notebookName]<>"\n\n"<>
            StringRiffle[testStringList,"\n\n"]<>"\n\n"<>
                endGlobalContext[notebookName];


beginGlobalContext[notebookName_] :=
    templateOfTestString[{
        "Begin[\"Global`\"];\n    ClearAll[\"`*\"]",
        "Null",
        "TestID->\"[0] "<>notebookName<>"\""
    }];


endGlobalContext[notebookName_] :=
    templateOfTestString[{
        "ClearAll[\"`*\"];\n    End[]",
        "\"Global`\"",
        "TestID->\"[\[Infinity]] "<>notebookName<>"\""
    }];


(* ::Subsubsection:: *)
(*File operation*)


fileListFromDirectory[dir_,excludedFileList_List] :=
    FileNames["*.nb",dir]//
        Query[All,<|"FileName"->FileNameTake[#],"File"->File[#]|>&]//
            Query[Select[!MatchQ[#FileName,Alternatives@@excludedFileList]&]];


(* ::Subsection:: *)
(*End*)


End[];


(* ::Section:: *)
(*End*)


EndPackage[];
