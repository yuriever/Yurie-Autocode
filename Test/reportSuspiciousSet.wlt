

(* reportSuspiciousSet.nb *)

VerificationTest[
    Begin["Global`"];
    ClearAll["`*"]
    ,
    Null
    ,
    TestID->"[0] reportSuspiciousSet.nb"
]

VerificationTest[
    Get["Yurie`Autocode`"]; 
    Get["Yurie`Autocode`Info`"]; 
    (Needs["CodeParser`"]; )
    ,
    Null
    ,
    TestID->"[1] reportSuspiciousSet.nb"
]

VerificationTest[
    Yurie`Autocode`reportSuspiciousSet`Private`getSuspiciousSetFromSingleFile[File[FileNameJoin[{$thisSourceDir, "testcode-set.wl"}]], {}]
    ,
    {Association["LHS" -> "f0[]", "RHS" -> "1", "Position" -> {25, 1}], Association["LHS" -> "List[x, y]", "RHS" -> "List[1, 2]", "Position" -> {22, 1}], Association["LHS" -> "g1", "RHS" -> "1", "Position" -> {37, 9}], Association["LHS" -> "z", "RHS" -> "y", "Position" -> {49, 9}]}
    ,
    TestID->"[2] reportSuspiciousSet.nb"
]

VerificationTest[
    getSuspiciousSet[str_String] := Yurie`Autocode`reportSuspiciousSet`Private`postFormat[Yurie`Autocode`reportSuspiciousSet`Private`getSuspiciousSetFromAST[{}][CodeParse[str]]]
    ,
    Null
    ,
    TestID->"[3] reportSuspiciousSet.nb"
]

VerificationTest[
    getSuspiciousSet["x=1"]
    ,
    {Association["LHS" -> "x", "RHS" -> "1", "Position" -> {1, 1}]}
    ,
    TestID->"[4] reportSuspiciousSet.nb"
]

VerificationTest[
    getSuspiciousSet["x[]=1"]
    ,
    {Association["LHS" -> "x[]", "RHS" -> "1", "Position" -> {1, 1}]}
    ,
    TestID->"[5] reportSuspiciousSet.nb"
]

VerificationTest[
    getSuspiciousSet["{x,y}={1,1}"]
    ,
    {Association["LHS" -> "List[x, y]", "RHS" -> "List[1, 1]", "Position" -> {1, 1}]}
    ,
    TestID->"[6] reportSuspiciousSet.nb"
]

VerificationTest[
    getSuspiciousSet["x=1;y[]=1"]
    ,
    {Association["LHS" -> "x", "RHS" -> "1", "Position" -> {1, 1}], Association["LHS" -> "y[]", "RHS" -> "1", "Position" -> {1, 5}]}
    ,
    TestID->"[7] reportSuspiciousSet.nb"
]

VerificationTest[
    getSuspiciousSet["x=1;y[]=1\nx=1"]
    ,
    {Association["LHS" -> "x", "RHS" -> "1", "Position" -> {2, 1}], Association["LHS" -> "x", "RHS" -> "1", "Position" -> {1, 1}], Association["LHS" -> "y[]", "RHS" -> "1", "Position" -> {1, 5}]}
    ,
    TestID->"[8] reportSuspiciousSet.nb"
]

VerificationTest[
    getSuspiciousSet["x=y[]=1"]
    ,
    {Association["LHS" -> "x", "RHS" -> "Set[y[], 1]", "Position" -> {1, 1}], Association["LHS" -> "y[]", "RHS" -> "1", "Position" -> {1, 3}]}
    ,
    TestID->"[9] reportSuspiciousSet.nb"
]

VerificationTest[
    getSuspiciousSet["Module[{x},x=1;y=1]"]
    ,
    {Association["LHS" -> "y", "RHS" -> "1", "Position" -> {1, 16}]}
    ,
    TestID->"[10] reportSuspiciousSet.nb"
]

VerificationTest[
    getSuspiciousSet["With[{x=1},x=1;y=1]"]
    ,
    {Association["LHS" -> "y", "RHS" -> "1", "Position" -> {1, 16}]}
    ,
    TestID->"[11] reportSuspiciousSet.nb"
]

VerificationTest[
    getSuspiciousSet["Block[{x},x=1;y=1]"]
    ,
    {Association["LHS" -> "y", "RHS" -> "1", "Position" -> {1, 15}]}
    ,
    TestID->"[12] reportSuspiciousSet.nb"
]

VerificationTest[
    getSuspiciousSet["Module[{x},Module[{y},Module[{z},w=1]]]"]
    ,
    {Association["LHS" -> "w", "RHS" -> "1", "Position" -> {1, 34}]}
    ,
    TestID->"[13] reportSuspiciousSet.nb"
]

VerificationTest[
    getSuspiciousSet["y=1;Module[{x},x=1];x=1"]
    ,
    {Association["LHS" -> "y", "RHS" -> "1", "Position" -> {1, 1}], Association["LHS" -> "x", "RHS" -> "1", "Position" -> {1, 21}]}
    ,
    TestID->"[14] reportSuspiciousSet.nb"
]

VerificationTest[
    getSuspiciousSet["HoldPattern[x_=y_]:>{x,y}"]
    ,
    {Association["LHS" -> "Pattern[x, Blank[]]", "RHS" -> "Pattern[y, Blank[]]", "Position" -> {1, 13}]}
    ,
    TestID->"[15] reportSuspiciousSet.nb"
]

VerificationTest[
    Yurie`Autocode`reportSuspiciousSet`Private`getSuspiciousSetFromAST[{}][Yurie`Autocode`reportSuspiciousSet`Private`screenVerbatimPattern[CodeParse["HoldPattern[x_=y_]:>{x,y}"]]]
    ,
    {{}, {{}, {}}, {}}
    ,
    TestID->"[16] reportSuspiciousSet.nb"
]

VerificationTest[
    getSuspiciousSet["Module[{a,b,c},{a,b}={1,1}];x=1"]
    ,
    {Association["LHS" -> "x", "RHS" -> "1", "Position" -> {1, 29}]}
    ,
    TestID->"[17] reportSuspiciousSet.nb"
]

VerificationTest[
    getSuspiciousSet["Module[{a,b,c},{a,d}={1,1}];x=1"]
    ,
    {Association["LHS" -> "x", "RHS" -> "1", "Position" -> {1, 29}], Association["LHS" -> "List[a, d]", "RHS" -> "List[1, 1]", "Position" -> {1, 16}]}
    ,
    TestID->"[18] reportSuspiciousSet.nb"
]

VerificationTest[
    getSuspiciousSet["Module[{a,b,c},Module[{d,e,f},{a,b,c,d,e,f}=list]]"]
    ,
    {}
    ,
    TestID->"[19] reportSuspiciousSet.nb"
]

VerificationTest[
    ClearAll["`*"];
    End[]
    ,
    "Global`"
    ,
    TestID->"[∞] reportSuspiciousSet.nb"
]