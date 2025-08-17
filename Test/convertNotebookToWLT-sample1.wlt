

(* convertNotebookToWLT-sample1 *)

VerificationTest[
    Begin["Global`"];
	ClearAll["`*"]
    ,
    Null
    ,
    TestID->"[0] convertNotebookToWLT-sample1"
]

VerificationTest[
    1 + 1
    ,
    2
    ,
    TestID->"[1] convertNotebookToWLT-sample1"
]

VerificationTest[
    a = 1; 
    ,
    Null
    ,
    TestID->"[2] convertNotebookToWLT-sample1"
]

VerificationTest[
    Print["test"]; 
    a + 1
    ,
    2
    ,
    TestID->"[3] convertNotebookToWLT-sample1"
]

VerificationTest[
    f0[x_] := x; 
    ,
    Null
    ,
    TestID->"[4] convertNotebookToWLT-sample1"
]

VerificationTest[
    ClearAll["`*"];
	End[]
    ,
    "Global`"
    ,
    TestID->"[∞] convertNotebookToWLT-sample1"
]