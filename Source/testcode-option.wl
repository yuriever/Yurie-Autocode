(* ::Package:: *)

BeginPackage["Global`"];


Clear["Global`*"];
Clear["Global`*`*"];


f0;
f1;
f2;
g0;
g1;
g2;
h;
k;
j;


Begin["`Private`"];


f0[OrderlessPatternSequence[x_List,y_Symbol],opts:OptionsPattern[]] :=
    0;

f1[x_,opts:OptionsPattern[]] :=
    0;

f2[OptionsPattern[]] :=
    0;


g0[OrderlessPatternSequence[x_List,y_Symbol],opts:OptionsPattern[]][z_] :=
    0;

g1[x_,opts:OptionsPattern[]][] :=
    0;

g2[OptionsPattern[]][] :=
    0;


h = 0;


k//Options = {"Test"->True};

k[x_,opts:OptionsPattern[]] :=
    x;


j//Options = {"Test"->True};

j[x_,y_:1,opts:OptionsPattern[]] :=
    x;


End[];


EndPackage[];
