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
    "ExcludedSymbol"->{}
};


(* ::Subsection:: *)
(*Main*)


exportPublicSymbolUsage[dir_?DirectoryQ,targetDir_?DirectoryQ,opts:OptionsPattern[]] :=
    Module[ {usage},
        usage =
            getUsageFromDirectory[dir,OptionValue["ExcludedFile"],OptionValue["ExcludedSymbol"]];
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


getUsageFromDirectory[dir_,excludedFileList_List,excludedSymbolList_List] :=
    fileListFromDirectory[dir,excludedFileList]//
        (*get the list of usages from *.wl files.*)
        Query[All,<|
            "FileName"->#FileName,
            getUsageFromSingleFile[#File,excludedSymbolList]
        |>&]//
            (*drop the files without usage.*)
            Select[KeyExistsQ[#,"WL"]&&KeyExistsQ[#,"MD"]&]//
                (*merge and mark the usages from different files.*)
                Query[All,<|
                    "WL"->"(* "<>#FileName<>" *)\n\n"<>#WL,
                    "MD"->"<!-- "<>#FileName<>" -->\n\n"<>#MD
                |>&]//Merge[StringRiffle[#,"\n\n\n"]&];


getUsageFromSingleFile[file_File,excludedSymbolList_List] :=
    file//CodeParse//getUsageListFromAST[excludedSymbolList]//postFormat;


getUsageListFromAST[excludedSymbolList_List][ast_] :=
    ast//DeleteCases[#,_ContextNode,Infinity]&//
        Cases[#,patternOfUsage,Infinity]&//
            Query[Select[!MemberQ[excludedSymbolList,#Symbol]&]];


postFormat[usageList_List] :=
    usageList//Query[All,<|
        "WL"->
            TemplateObject[
                {TemplateSlot["Symbol"],"::usage =\n    ",TemplateSlot["Usage"],";"},
                InsertionFunction->ToString,
                CombinerFunction->StringJoin
            ],
        "MD"->
            TemplateObject[
                {"* `#!wl ",TemplateSlot["Symbol"],"`"," - ",TemplateSlot["Usage"]},
                InsertionFunction->markdownEscape@*(
                    If[ StringStartsQ[#,"StringJoin"],
                        ToString@ToExpression[#],
                        (*Else*)
                        StringReplace[#,StartOfString~~"\""~~str___~~"\""~~EndOfString:>str]
                    ]&
                ),
                CombinerFunction->StringJoin
            ]
    |>]//Merge[StringRiffle[#,"\n\n"]&];


markdownEscape[str_] :=
    str//StringReplace[{
        "`"->"\`",
        "\n"->" "
    }];


fileListFromDirectory[dir_,excludedFileList_List] :=
    FileNames["*.wl",dir]//
        Query[All,<|"FileName"->FileNameTake[#],"File"->File[#]|>&]//
            Query[Select[!MatchQ[#FileName,Alternatives@@excludedFileList]&]];


(* ::Subsection:: *)
(*End*)


End[];


(* ::Section:: *)
(*End*)


EndPackage[];
