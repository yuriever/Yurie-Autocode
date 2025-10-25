(* ::Package:: *)

(* ::Section:: *)
(*Begin*)


BeginPackage["Yurie`Autocode`AST`"];


Needs["CodeParser`"];

Needs["Yurie`Autocode`"];


(* ::Section:: *)
(*Public*)


ASTHierarchy::usage =
    "return the hierarchical structure of the AST.";

ASTHierarchyPrint::usage =
    "print the hierarchical structure of the AST.";


(* ::Section:: *)
(*Private*)


(* ::Subsection:: *)
(*Begin*)


Begin["`Private`"];


(* ::Subsection:: *)
(*Main*)


ASTHierarchy[ast_] :=
    ASTHierarchyKernel[ast,0]//Flatten;


ASTHierarchyPrint[ast_] :=
    ASTHierarchyKernel[ast,0]//Flatten//
        Query[All,{stringIndent[#Depth]<>ToString[#Node],getLineNumberFromPosition[#Position]}&]//
            TableForm;


(* ::Subsection:: *)
(*Helper*)


ASTHierarchyKernel[ast_,depth_] :=
    Module[{name,children},
        name = ast[[1]];
        children = ast[[2]];
        {
            ASTHierarchyKernel[name,depth],
            Map[ASTHierarchyKernel[#,depth+1]&,children]
        }
    ];

ASTHierarchyKernel[leaf_LeafNode,depth_] :=
    <|"Depth"->depth,"NodeType"->leaf[[1]],"Node"->leaf[[2]],"Position"->leaf[[3,Key[Source]]]|>;

ASTHierarchyKernel[symbol_Symbol,depth_] :=
    <|"Depth"->depth,"NodeType"->Missing[],"Node"->ToString[symbol],"Position"->Missing[]|>

ASTHierarchyKernel[list_List,depth_] :=
    Map[ASTHierarchyKernel[#,depth]&,list];


stringIndent[depth_] :=
    StringRepeat[" ",2*depth];


getLineNumberFromPosition[pos_List] :=
    pos[[1,1]];

getLineNumberFromPosition[_Missing] :=
    "";


(* ::Subsection:: *)
(*End*)


End[];


(* ::Section:: *)
(*End*)


EndPackage[];
