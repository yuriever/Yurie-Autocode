(* ::Package:: *)

BeginPackage["Global`"];


Clear["Global`*"];
Clear["Global`*`*"];


f0;
f1;
f2;

g0;
g1::usage =
    "test.";


Begin["`Private`"];


{x,y}={1,2};


f0[] = 1

f0[x_] :=
    x;


f1//Attributes =
    {HoldAll};

f1[x_] :=
    Module[ {temp,temp2=1},
        temp = x;
        g1 = 1;
        temp2+temp
    ];


f2//Options = {
    "Test"
};

f2[x_] :=
    With[{y=x},
        y;
        z=y;
        x
    ]


g0::test =
    "this is a test."

g0[_] :=
    Message[g0::test];


g1[x_] :=
    Module[ {temp},
        Module[{temp1},
            temp=x;
            temp1=temp;
        ]
    ];


g1[x_] :=
    Module[ {temp},
        Module[{temp1},
            Module[{temp2},
                temp=x;
                temp1=temp;
                temp2=temp1;
                temp2
            ]
        ]
    ];


End[];


EndPackage[];
