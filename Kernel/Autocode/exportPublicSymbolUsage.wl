(* ::Package:: *)

(* ::Section:: *)
(*Begin*)


BeginPackage["Yurie`Autocode`exportPublicSymbolUsage`"];


Needs["CodeParser`"];

Needs["Yurie`Autocode`"];

Needs["Yurie`Autocode`Constant`"];


(* ::Section:: *)
(*Public*)


exportPublicSymbolUsage::usage =
    "export the usages of public symbols in the directory.";

$usageFileName::usage =
    "default name of the usage file.";


(* ::Section:: *)
(*Private*)


(* ::Subsection:: *)
(*Begin*)


Begin["`Private`"];


(* ::Subsection:: *)
(*Constant*)


$usageFileName = <|
    "WL"->"Usage.wl",
    "MD"->"Usage.md"
|>


(* ::Subsection:: *)
(*Option*)


exportPublicSymbolUsage//Options = {
    "ExcludedFile":>{$usageFileName},
    "ExcludedSymbol"->{},
    "UpdatedUsageHandler"->Automatic
};


(* ::Subsection:: *)
(*Main*)


exportPublicSymbolUsage[dir:_?DirectoryQ|{__?DirectoryQ},targetDir_?DirectoryQ,opts:OptionsPattern[]] :=
    With[ {
            usage =
                getUsageFromDirectory[
                    dir,
                    OptionValue["ExcludedFile"],
                    OptionValue["ExcludedSymbol"],
                    OptionValue["UpdatedUsageHandler"]
                ]
        },
        {
            File@Export[
                FileNameJoin@{targetDir,$usageFileName["WL"]},
                usage["WL"],
                "Text"
            ],
            File@Export[
                FileNameJoin@{targetDir,$usageFileName["MD"]},
                usage["MD"],
                "Text"
            ]
        }
    ];


(* ::Subsection:: *)
(*Helper*)


getUsageFromDirectory[dir_,excludedFileList_List,excludedSymbolList_List,updatedUsageHandler_] :=
    fileListFromDirectory[dir,excludedFileList]//
        getUsageFromFileList[excludedSymbolList,updatedUsageHandler]//
            mergeUsageAcrossFile;


getUsageFromFileList[excludedSymbolList_List,updatedUsageHandler_][fileList_List] :=
    fileList//Query[All,<|
        "FileName"->#FileName,
        getUsageFromSingleFile[excludedSymbolList,updatedUsageHandler][#File]
    |>&];


getUsageFromSingleFile[excludedSymbolList_List,updatedUsageHandler_][file_File] :=
    file//CodeParse//
        getUsageListFromAST[excludedSymbolList]//
            handleUpdatedUsage[file,updatedUsageHandler]//
                formatUsage;


getUsageListFromAST[excludedSymbolList_List][ast_] :=
    ast//DeleteCases[#,_ContextNode,Infinity]&//
        Cases[#,patternOfUsage,Infinity]&//
            Discard[MemberQ[excludedSymbolList,#Symbol]&];


fileListFromDirectory[dir_,excludedFileList_List] :=
    FileNames["*.wl",dir]//
        Query[All,<|"FileName"->FileNameTake[#],"File"->File[#]|>&]//
            Discard[MatchQ[#FileName,Alternatives@@excludedFileList]&];


mergeUsageAcrossFile[fileUsageList_List] :=
    fileUsageList//
        (* Drop the files without usage. *)
        Select[KeyExistsQ[#,"WL"]&]//
            (* Merge and mark the usages from different files. *)
            Query[All,<|
                "WL"->"\n(* ::Subsubsection:: *)\n(*"<>#FileName<>"*)\n\n\n"<>#WL,
                "MD"->"## "<>#FileName<>"\n\n"<>#MD
            |>&]//
                Merge[StringRiffle[#,"\n\n"]&]//
                    Query[
                        <|
                            "WL"->"(* ::Package:: *)\n\n(* ::Subsection:: *)\n(*Usage*)\n\n"<>#WL,
                            "MD"->"# Usage\n\n"<>#MD
                        |>&
                    ];


handleUpdatedUsage[file_,False][usageList_List] :=
    usageList;

handleUpdatedUsage[file_,Automatic|"FindStringJoinThenAddNewline"][usageList_List] :=
    usageList//Query[All,
        If[ StringStartsQ[#Usage,"StringJoin[MessageName["~~#Symbol~~", \"usage\"]"~~___],
            <|#,"Usage"->templateUpdatedUsage[file,#Symbol]|>,
            (*Else*)
            #
        ]&
    ];

templateUpdatedUsage[file_,symbol_String]:=
    ToString[
        ToExpression[
            symbol,
            InputForm,
            Function[Null,MessageName[#,"usage"],{HoldFirst}]
        ]<>"\n\[LeftDoubleBracket]"<>FileNameTake[file]<>"\[RightDoubleBracket] ",
        InputForm
    ];


formatUsage[usageList_List] :=
    usageList//Query[All,<|
        "WL"->#Symbol<>"::usage =\n    "<>ToString[#Usage]<>";",
        "MD"->"* `#!wl "<>#Symbol<>"` - "<>convertSpecialCharacter[ToString[ToExpression[#Usage]]]
    |>&]//Merge[StringRiffle[#,"\n\n"]&];


convertSpecialCharacter[str_] :=
    str//StringReplace[{
        "`"->"\`",
        "\n"->"\n\n\t* "
    }];


(* ::Subsection:: *)
(*End*)


End[];


(* ::Section:: *)
(*End*)


EndPackage[];
