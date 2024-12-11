(* ::Package:: *)

(* ::Section:: *)
(*Begin*)


BeginPackage["Yurie`Autocode`reportWLT`"];


Needs["Yurie`Autocode`"];


(* ::Section:: *)
(*Public*)


reportWLT::usage =
    "report the unit test in the directory.";


(* ::Section:: *)
(*Private*)


(* ::Subsection:: *)
(*Begin*)


Begin["`Private`"];


(* ::Subsection:: *)
(*Main*)


reportWLT[dir_?DirectoryQ] :=
    Module[ {report},
        report =
            Block[{Print},
                TestReport[
                    FileNames["*.wlt",dir],
                    HandlerFunctions-><|
                        "TestEvaluated"->(Which[#Outcome=!="Success",Echo@#TestObject]&)
                    |>
                ]
            ];
        CellPrint@ExpressionCell[
            report//dropTitleInReport,
            "Output",
            FilterRules[CurrentValue[{StyleDefinitions,"Echo"}],CellDingbat]
        ];
    ];


(* ::Subsection:: *)
(*Helper*)


dropTitleInReport[report_TestReportObject] :=
    report//First//Association[#,"Title"->Automatic]&//TestReportObject;


(* ::Subsection:: *)
(*End*)


End[];


(* ::Section:: *)
(*End*)


EndPackage[];
