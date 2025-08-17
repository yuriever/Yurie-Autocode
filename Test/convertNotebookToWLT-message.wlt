

(* convertNotebookToWLT-message.nb *)

VerificationTest[
    Begin["Global`"];
    ClearAll["`*"]
    ,
    Null
    ,
    TestID->"[0] convertNotebookToWLT-message.nb"
]

VerificationTest[
    f[x_] := (Message[f::test]; Message[f::test2, x]); 
    f::test = "this is a test message."; 
    (f::test2 = "this is another test message with ``."; )
    ,
    Null
    ,
    TestID->"[1] convertNotebookToWLT-message.nb"
]

VerificationTest[
    f[1]
    ,
    Null
    ,
    {Global`f::test,Global`f::test2}
    ,
    TestID->"[2] convertNotebookToWLT-message.nb"
]

VerificationTest[
    g[x_] := Message[g::test, x]
    ,
    Null
    ,
    TestID->"[3] convertNotebookToWLT-message.nb"
]

VerificationTest[
    g[x]
    ,
    Null
    ,
    {Global`g::test}
    ,
    TestID->"[4] convertNotebookToWLT-message.nb"
]

VerificationTest[
    g1[x_] := Message[g1::test]
    ,
    Null
    ,
    TestID->"[5] convertNotebookToWLT-message.nb"
]

VerificationTest[
    g1[x]
    ,
    Null
    ,
    {Global`g1::test}
    ,
    TestID->"[6] convertNotebookToWLT-message.nb"
]

VerificationTest[
    g2[x_] := (Message[g2::test]; x)
    ,
    Null
    ,
    TestID->"[7] convertNotebookToWLT-message.nb"
]

VerificationTest[
    g2[x]
    ,
    Quiet[x]
    ,
    {Global`g2::test}
    ,
    TestID->"[8] convertNotebookToWLT-message.nb"
]

VerificationTest[
    ClearAll["`*"];
    End[]
    ,
    "Global`"
    ,
    TestID->"[∞] convertNotebookToWLT-message.nb"
]