(* ::Package:: *)

(* ::Section:: *)
(*Begin*)


BeginPackage["Yurie`Autocode`Constant`"];


Needs["CodeParser`"];


(* ::Section:: *)
(*Public*)


patternOfUsage::usage =
    "AST pattern: usage.";

patternOfSuspiciousSet::usage =
    "AST pattern: suspicious set.";

patternOfVerbatimPattern::usage =
    "AST pattern: verbatim pattern.";

placeholderOfVerbatimPattern::usage =
    "placeholder of verbatim pattern.";

patternOfScoping::usage =
    "AST pattern: scoping construction.";

patternOfLocalSymbol::usage =
    "AST pattern: local symbol in scoping construction.";

patternOfScoping2::usage =
    "AST pattern rule: scoping construction.";

patternOfSymbolList::usage =
    "AST pattern: list of symbols.";

patternOfSymbolList2::usage =
    "AST pattern rule: list of symbols.";


(* ::Section:: *)
(*Private*)


(* ::Subsection:: *)
(*Begin*)


Begin["`Private`"];


(* ::Subsection:: *)
(*Main*)


(* ::Text:: *)
(*AST patterns generated by ResourceFunction["ASTPattern"].*)


patternOfUsage =
    ResourceFunction["ASTPattern"][HoldPattern[Set[MessageName[sym_,"usage"] , msg:_String|_StringJoin]]]:>
        <|"Symbol"->ToFullFormString[sym],"Usage"->ToFullFormString[msg]|>;


patternOfSuspiciousSet =
    ResourceFunction["ASTPattern"]@HoldPattern[Set[lhs:Except[_Attributes|_MessageName|_Options,_] , rhs_]]:>
        <|"LHS"->lhs,"RHS"->rhs|>;


patternOfVerbatimPattern =
    ResourceFunction["ASTPattern"]@HoldPattern[_HoldPattern|_Verbatim]->
        LeafNode[Symbol,"Yurie`Autocode`Constant`placeholderOfVerbatimPattern",_];


patternOfScoping =
    ResourceFunction["ASTPattern"]@HoldPattern[_Module|_With|_Block|_Interpretation];


patternOfLocalSymbol =
    ResourceFunction["ASTPattern"]@HoldPattern[Set[local_Symbol , _]]|ResourceFunction["ASTPattern"]@HoldPattern[local_Symbol]:>
        ToFullFormString@local;


patternOfScoping2 =
    ResourceFunction["ASTPattern"]@HoldPattern[(Module|With|Block|Interpretation)[{locals___},body_]]:>
        <|
            "LocalSymbolList"->Cases[{locals},patternOfLocalSymbol],
            "Body"->{body}
        |>;


patternOfSymbolList =
    ResourceFunction["ASTPattern"]@HoldPattern[{___Symbol}];


patternOfSymbolList2 =
    ResourceFunction["ASTPattern"]@HoldPattern[{symbols___Symbol}]:>
        Map[ToFullFormString,{symbols}];


(* ::Subsection:: *)
(*End*)


End[];


(* ::Section:: *)
(*End*)


EndPackage[];
