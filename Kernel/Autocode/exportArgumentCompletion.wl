(* ::Package:: *)

(* ::Section:: *)
(*Begin*)


BeginPackage["Yurie`Autocode`exportArgumentCompletion`"];


Needs["Yurie`Autocode`"];


(* ::Section:: *)
(*Public*)


exportArgumentCompletion::usage =
    "export the argument completion data.";

$argumentFileName::usage =
    "default name of the argument completion file.";


(* ::Section:: *)
(*Private*)


(* ::Subsection:: *)
(*Begin*)


Begin["`Private`"];


(* ::Subsection:: *)
(*Constant*)


$argumentFileName = "specialArgFunctions.tr";


(* ::Subsection:: *)
(*Message*)


exportArgumentCompletion::hasOwnValues =
    "The symbol `` has own values."

exportArgumentCompletion::noStringOptions =
    "The symbol `` has no option with string key."


(* ::Subsection:: *)
(*Main*)


exportArgumentCompletion[
    targetDir_?DirectoryQ,
    funDataList:{(_String|_Rule)...}:{},
    extraFunDataList:{___Rule}:{}
] :=
    Module[ {filePath},
        filePath =
            FileNameJoin@{targetDir,$argumentFileName};
        Put[
            getArgumentCompletionData[funDataList,extraFunDataList],
            filePath
        ];
        File@filePath
    ];


(* ::Subsection:: *)
(*Helper*)


getArgumentCompletionData[funDataList_List,extraFunDataList_List] :=
    Join[
        getOptionCompletionDataList[funDataList],
        extraFunDataList
    ];


getOptionCompletionDataList[funDataList_List] :=
    funDataList//Map[getOptionCompletionData];


getOptionCompletionData[funName_String] :=
    Rule[funName,{Splice@ConstantArray[0,maxNumberOfNormalArgument@funName],optionKeyList@funName}];

getOptionCompletionData[Rule[funName_,completionData_]] :=
    Rule[funName,{Splice@completionData,optionKeyList@funName}];


maxNumberOfNormalArgument[funName_String] :=
    (
        checkOwnValues[funName];
        Join[
            getArgmentPatternFromDownValues@funName,
            getArgmentPatternFromSubValues@funName
        ]//trimPattern//maxArgument
    );


checkOwnValues[funName_String] :=
    If[ Quiet@OwnValues[funName]=!={},
        Message[exportArgumentCompletion::hasOwnValues,funName];
        funName
    ];


getArgmentPatternFromDownValues[funName_String] :=
    With[ {
            rule =
                ToExpression[
                    funName,
                    StandardForm,
                    Function[Null,HoldPattern[#[args___]]:>{args},HoldFirst]
                ]
        },
        funName//DownValues//Keys//Cases[#,rule,{2}]&
    ];


getArgmentPatternFromSubValues[funName_String] :=
    With[ {
            rule =
                ToExpression[
                    funName,
                    StandardForm,
                    Function[Null,HoldPattern[#[args___]]:>{args},HoldFirst]
                ]
        },
        funName//SubValues//Keys//Cases[#,rule,{3},Heads->True]&
    ];


trimPattern[argList_] :=
    argList//Replace[#,{
        Verbatim[OrderlessPatternSequence][args___]:>Sequence[args],
        Verbatim[OptionsPattern][___]|Verbatim[Pattern][_,Verbatim[OptionsPattern][___]]:>Nothing
    },{2}]&//Replace[#,{
        arg_/;!FreeQ[arg,Verbatim[Optional]]:>Nothing
    },{2}]&;


maxArgument[{}] :=
    0;

maxArgument[list_List] :=
    list//Map[Length]//Max;


optionKeyList[funName_String] :=
    Module[ {keys},
        keys =
            ToExpression[funName,StandardForm,Function[Null,Options@Unevaluated[#],HoldFirst]]//Keys//Cases[_String];
        If[ keys==={},
            Message[exportArgumentCompletion::noStringOptions,funName];
            Nothing,
            (*Else*)
            keys
        ]
    ];


(* ::Subsection:: *)
(*End*)


End[];


(* ::Section:: *)
(*End*)


EndPackage[];
