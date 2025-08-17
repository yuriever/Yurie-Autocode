

(* convertNotebookToWLT-simple *)

VerificationTest[
    Begin["Global`"];
	ClearAll["`*"]
    ,
    Null
    ,
    TestID->"[0] convertNotebookToWLT-simple"
]

VerificationTest[
    Get["Yurie`Base`"]
    ,
    Null
    ,
    TestID->"[1] convertNotebookToWLT-simple"
]

VerificationTest[
    colorHexify[Red]
    ,
    "#ff0000"
    ,
    TestID->"[2] convertNotebookToWLT-simple"
]

VerificationTest[
    ClearAll["`*"];
	End[]
    ,
    "Global`"
    ,
    TestID->"[∞] convertNotebookToWLT-simple"
]