(* ::Package:: *)

BeginPackage["Global`"];


Clear["Global`*"];
Clear["Global`*`*"];


a;
b;
e;
f;
g;


Begin["`Private`"];


a::test = "test";

a[][] = a;

a[1][] = a1;

a[2][] = a2;

a["symbol"] := Symbol["a0"];

a = b;


b[] = b;

b = {c[],d[][]};


c[] = {e[f]};

c[2] = {f};


d[][] = g;


f /: e[f] = g;


e[] = Hold[b];


g :=
    (
        Message[a::test];
        {}
    );


End[];


EndPackage[];
