

(* convertNotebookToWLT-MFMakeBox *)

VerificationTest[
    Begin["Global`"];
	ClearAll["`*"]
    ,
    Null
    ,
    TestID->"[0] convertNotebookToWLT-MFMakeBox"
]

VerificationTest[
    Get["Yurie`MathForm`"]
    ,
    Null
    ,
    TestID->"[1] convertNotebookToWLT-MFMakeBox"
]

VerificationTest[
    MFMakeBox[{hb, MakeBoxes[OverBar[h]]}]
    ,
    Null
    ,
    TestID->"[2] convertNotebookToWLT-MFMakeBox"
]

VerificationTest[
    MFMakeBox[{Test`Private`hb1, MakeBoxes[OverBar[h]]}]
    ,
    Null
    ,
    TestID->"[3] convertNotebookToWLT-MFMakeBox"
]

VerificationTest[
    MFMakeBox[{Global`Private`hb2, MakeBoxes[OverBar[h]]}]
    ,
    Null
    ,
    TestID->"[4] convertNotebookToWLT-MFMakeBox"
]

VerificationTest[
    hb + 1
    ,
    1 + Global`hb
    ,
    TestID->"[5] convertNotebookToWLT-MFMakeBox"
]

VerificationTest[
    Test`Private`hb1 + 1
    ,
    1 + Test`Private`hb1
    ,
    TestID->"[6] convertNotebookToWLT-MFMakeBox"
]

VerificationTest[
    Global`Private`hb2 + 1
    ,
    1 + Global`Private`hb2
    ,
    TestID->"[7] convertNotebookToWLT-MFMakeBox"
]

VerificationTest[
    ClearAll["`*"];
	End[]
    ,
    "Global`"
    ,
    TestID->"[∞] convertNotebookToWLT-MFMakeBox"
]