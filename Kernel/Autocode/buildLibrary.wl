(* ::Package:: *)

(* ::Section:: *)
(*Begin*)


BeginPackage["Yurie`Autocode`buildLibrary`"];


Needs["CCompilerDriver`"];

Needs["Yurie`Autocode`"];


(* ::Section:: *)
(*Public*)


buildLibrary::usage =
    "build the library.";


(* ::Section:: *)
(*Private*)


(* ::Subsection:: *)
(*Begin*)


Begin["`Private`"];


(* ::Subsection:: *)
(*Main*)


buildLibrary[dir_?DirectoryQ,targetDir_?DirectoryQ,libName_String] :=
    Module[{libPath,builtFile},
        libPath =
            FileNameJoin@{targetDir,libName<>"."<>Internal`DynamicLibraryExtension[]};
        If[FileExistsQ@libPath,
            DeleteFile@libPath;
        ];
        builtFile = CreateLibrary[
            FileNames["*.c",dir],
            libName,
            "TargetDirectory"->targetDir,
            "CleanIntermediate"->True
        ];
        If[Not@FileExistsQ@builtFile,
            Failure["BuildFailed",<|"MessageTemplate"->"The library is failed to build."|>],
            (*Else*)
            Success["BuildCompleted",<|"MessageTemplate"->"The library has been built successfully."|>]
        ]
    ];


(* ::Subsection:: *)
(*End*)


End[];


(* ::Section:: *)
(*End*)


EndPackage[];
