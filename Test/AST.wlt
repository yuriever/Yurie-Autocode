

(* AST *)

VerificationTest[
    Begin["Global`"];
	ClearAll["`*"]
    ,
    Null
    ,
    TestID->"[0] AST"
]

VerificationTest[
    Get["Yurie`Autocode`"]
    ,
    Null
    ,
    TestID->"[1] AST"
]

VerificationTest[
    Needs["CodeParser`"]; 
    ,
    Null
    ,
    TestID->"[2] AST"
]

VerificationTest[
    ASTHierarchy[CodeParse["a+b"]]
    ,
    {Association["Depth" -> 0, "NodeType" -> Missing[], "Node" -> "String", "Position" -> Missing[]], Association["Depth" -> 1, "NodeType" -> Symbol, "Node" -> "Plus", "Position" -> Missing["KeyAbsent", Key[Source]]], Association["Depth" -> 2, "NodeType" -> Symbol, "Node" -> "a", "Position" -> {{1, 1}, {1, 2}}], Association["Depth" -> 2, "NodeType" -> Symbol, "Node" -> "b", "Position" -> {{1, 3}, {1, 4}}]}
    ,
    TestID->"[3] AST"
]

VerificationTest[
    ASTHierarchy[CodeParse["a+b*c[d+e[h]]"]]
    ,
    {Association["Depth" -> 0, "NodeType" -> Missing[], "Node" -> "String", "Position" -> Missing[]], Association["Depth" -> 1, "NodeType" -> Symbol, "Node" -> "Plus", "Position" -> Missing["KeyAbsent", Key[Source]]], Association["Depth" -> 2, "NodeType" -> Symbol, "Node" -> "a", "Position" -> {{1, 1}, {1, 2}}], Association["Depth" -> 2, "NodeType" -> Symbol, "Node" -> "Times", "Position" -> Missing["KeyAbsent", Key[Source]]], Association["Depth" -> 3, "NodeType" -> Symbol, "Node" -> "b", "Position" -> {{1, 3}, {1, 4}}], Association["Depth" -> 3, "NodeType" -> Symbol, "Node" -> "c", "Position" -> {{1, 5}, {1, 6}}], Association["Depth" -> 4, "NodeType" -> Symbol, "Node" -> "Plus", "Position" -> Missing["KeyAbsent", Key[Source]]], Association["Depth" -> 5, "NodeType" -> Symbol, "Node" -> "d", "Position" -> {{1, 7}, {1, 8}}], Association["Depth" -> 5, "NodeType" -> Symbol, "Node" -> "e", "Position" -> {{1, 9}, {1, 10}}], Association["Depth" -> 6, "NodeType" -> Symbol, "Node" -> "h", "Position" -> {{1, 11}, {1, 12}}]}
    ,
    TestID->"[4] AST"
]

VerificationTest[
    ASTHierarchyPrint[CodeParse["a+b*c[d+e[h]]"]]
    ,
    TableForm[{{"String", ""}, {"  Plus", ""}, {"    a", 1}, {"    Times", ""}, {"      b", 1}, {"      c", 1}, {"        Plus", ""}, {"          d", 1}, {"          e", 1}, {"            h", 1}}]
    ,
    TestID->"[5] AST"
]

VerificationTest[
    ClearAll["`*"];
	End[]
    ,
    "Global`"
    ,
    TestID->"[∞] AST"
]