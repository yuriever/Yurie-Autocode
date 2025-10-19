(* ::Package:: *)

(* ::Subsection:: *)
(*Usage*)


(* ::Subsubsection:: *)
(*AST.wl*)


ASTHierarchy::usage =
    "return the hierarchical structure of the AST.";

ASTHierarchyPrint::usage =
    "print the hierarchical structure of the AST.";


(* ::Subsubsection:: *)
(*buildLibrary.wl*)


buildLibrary::usage =
    "build the library.";


(* ::Subsubsection:: *)
(*convertNotebookToWLT.wl*)


convertNotebookToWLT::usage =
    "convert notebooks in the directory to *.wlt test files.";


(* ::Subsubsection:: *)
(*dependency.wl*)


dependency::usage =
    "symbol dependency from definitions.";

dependencyGraph::usage =
    "symbol dependency graph from definitions.";

$dependencyLimit::usage =
    "the fixed-point limit in dependency*.";

$dependencyExclusion::usage =
    "the excluded contexts in dependency*.";


(* ::Subsubsection:: *)
(*exportArgumentCompletion.wl*)


exportArgumentCompletion::usage =
    "export the argument completion data.";

$argumentFileName::usage =
    "default name of the argument completion file.";


(* ::Subsubsection:: *)
(*exportPublicSymbolUsage.wl*)


exportPublicSymbolUsage::usage =
    "export the usages of public symbols in the directory.";

$usageFileName::usage =
    "default name of the usage file.";


(* ::Subsubsection:: *)
(*reportSuspiciousSet.wl*)


reportSuspiciousSet::usage =
    "report suspicious set in the *.wl files in the directory.";


(* ::Subsubsection:: *)
(*reportWLT.wl*)


reportWLT::usage =
    "report the unit test in the directory.";