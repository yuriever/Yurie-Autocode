(* ::Package:: *)

BeginPackage["Global`"];


Clear["Global`*"];
Clear["Global`*`*"];


a;
f;
f0;
f1;
g;
g0;
h;
h0;
h1;
h2;
t;


Begin["`Private`"];


a = 1;


f[x_Symbol] :=
    (
        ++a;
        f0[x]
    );

f[x_Integer]/;x>1 :=
    (
        ++a;
        f0[x]
    );

f[x_Integer,y_] :=
    (
        ++a;
        {x,y}
    );

f[][x_] :=
    (
        ++a;
        f[x]
    );

f/:f1[f,x_]:=
    (
        ++a;
        f[x]
    );


g[x_] :=
    (
        ++a;
        IntegerQ[x]
    );

g0[x_]/;g[x] :=
    (
        ++a;
        x
    );


h//Attributes =
    {Orderless};

h[h0] :=
    (
        ++a;
        h1[]
    );

h1[] :=
    (
        ++a;
        h2
    );


t[][0] :=
    {0};

t[][1][0] :=
    {1,0};

t[][1][1][0] :=
    {1,1,0};


End[];


EndPackage[];
