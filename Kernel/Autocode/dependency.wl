(* ::Package:: *)

(* ::Section:: *)
(*Begin*)


BeginPackage["Yurie`Autocode`dependency`"];


Needs["Yurie`Autocode`"];


(* ::Section:: *)
(*Public*)


dependency::usage =
    "symbol dependency from definitions.";

dependencyGraph::usage =
    "symbol dependency graph from definitions.";

$dependencyLimit::usage =
    "the fixed-point limit in dependency*.";

$dependencyExclusion::usage =
    "the excluded contexts in dependency*.";


(* ::Section:: *)
(*Private*)


(* ::Subsection:: *)
(*Begin*)


Begin["`Private`"];


(* ::Subsection:: *)
(*Constant*)


$dependencyLimit = 8;

$dependencyExclusion = {};


$symbolEdgeCache::usage =
    "cache of symbol edges to speed up the recursion.";

$symbolEdgeCache = {};


(* ::Subsection:: *)
(*Option*)


dependency//Options =
    {
        "HideContext"->Automatic,
        "HideSystemSymbol"->True,
        "HideSymbolWithoutDefinition"->True,
        "HideSymbolWithOwnValue"->False,
        "SymbolOrRelation"->False
    };

dependencyGraph//Options =
    {
        "HideContext"->True,
        "HideSystemSymbol"->True,
        "HideSymbolWithoutDefinition"->True,
        "HideSymbolWithOwnValue"->False,
        Splice@Options@EdgeTaggedGraph
    };


(* ::Subsection:: *)
(*Main*)


(* ::Subsubsection:: *)
(*dependency*)


dependency//Attributes =
    {HoldFirst};

dependency[
    symbol_Symbol,
    OrderlessPatternSequence[
        HoldPattern[exclusionList_List:$dependencyExclusion],
        HoldPattern[limit_Integer:$dependencyLimit]
    ],
    OptionsPattern[]
] :=
    Hold[symbol]//getEdgeFromDefinition[OptionValue["HideSystemSymbol"],exclusionList,limit]//
        ifDeleteSymbolOrEdgeWithoutDefinition[OptionValue["HideSymbolWithoutDefinition"]]//
            ifDeleteSymbolOrEdgeWithOwnValue[OptionValue["HideSymbolWithOwnValue"]]//
                ifGetSymbolFromEdge[OptionValue["SymbolOrRelation"]]//
                    ifReplaceSymbolByName[OptionValue["HideContext"]];


(* ::Subsubsection:: *)
(*dependencyGraph*)


dependencyGraph//Attributes =
    {HoldFirst};

dependencyGraph//SetOptions[#,{
    (*EdgeLabels->Placed["Name",Tooltip],*)
    EdgeLabels->"EdgeTag",
    (*VertexLabels->Placed["Name",Tooltip],*)
    VertexLabels->Placed["Name",Below,Style[#,Small]&],
    (*VertexLabelStyle->Violet,*)
    VertexStyle->Directive[Pink,EdgeForm[None]],
    ImageSize->Full
}]&;

dependencyGraph[
    symbol_Symbol,
    OrderlessPatternSequence[
        HoldPattern[exclusionList_List:$dependencyExclusion],
        HoldPattern[limit_Integer:$dependencyLimit]
    ],
    opts:OptionsPattern[]
] :=
    Module[{maxDepth,relationList,coloredEdgeList},
        relationList =
            Hold[symbol]//getEdgeFromDefinition[OptionValue["HideSystemSymbol"],exclusionList,limit]//
                ifDeleteSymbolOrEdgeWithoutDefinition[OptionValue["HideSymbolWithoutDefinition"]]//
                    ifDeleteSymbolOrEdgeWithOwnValue[OptionValue["HideSymbolWithOwnValue"]]//
                        ifReplaceSymbolByName[OptionValue["HideContext"]];
        maxDepth =
            Quiet@Check[
                relationList//MaximalBy[Last]//Extract[{1,-1}],
                {}
            ];
        coloredEdgeList =
            relationList//Map[Style[#,Hue[Last@#/maxDepth-0.4,0.4,0.9,0.9]]&];
        EdgeTaggedGraph[
            coloredEdgeList,
            Sequence@@FilterRules[{opts,Options[dependencyGraph]},Options[EdgeTaggedGraph]]
        ]
    ];


(* ::Subsection:: *)
(*Helper*)


getEdgeFromDefinition[ifHideSystemSymbol_,exclusionList_,limit_][heldSymbol_Hold] :=
    Module[{relationListAtLevelOne,relationList,relationWithDepthList},
        relationListAtLevelOne =
            getRelationFromHeldSymbol[ifHideSystemSymbol,exclusionList][heldSymbol];
        WithCleanup[
            $symbolEdgeCache = relationListAtLevelOne,
            relationList =
                FixedPointList[
                    getRelationFromRelation[ifHideSystemSymbol,exclusionList],
                    relationListAtLevelOne,
                    limit-1
                ],
            $symbolEdgeCache = {}
        ];
        relationWithDepthList =
            Flatten@ReplaceAll[
                relationList,
                edge:DirectedEdge[source_,target_]:>DirectedEdge[source,target,First@FirstPosition[relationList,edge]]
            ];
        relationWithDepthList
    ];


getRelationFromRelation[ifHideSystemSymbol_,exclusionList_][relationList_List] :=
    Module[{newRelationList},
        newRelationList =
            relationList//Map[getRelationFromHeldSymbol[ifHideSystemSymbol,exclusionList]@*Last]//Flatten//Complement[#,$symbolEdgeCache]&;
        $symbolEdgeCache =
            Join[$symbolEdgeCache,newRelationList];
        newRelationList
    ];

getRelationFromRelation[ifHideSystemSymbol_,exclusionList_][{}] :=
    {};


getRelationFromHeldSymbol[ifHideSystemSymbol_,exclusionList_][Hold[$symbolEdgeCache]] :=
    {};

getRelationFromHeldSymbol[ifHideSystemSymbol_,exclusionList_][Hold[Symbol[_]]] :=
    {};

getRelationFromHeldSymbol[ifHideSystemSymbol_,exclusionList_][heldSymbol_Hold] :=
    Module[{heldValues,heldSymbolList},
        Which[
            Context@@heldSymbol==="System`",
                heldSymbolList = {},
            True,
                heldValues =
                    Join@@Replace[
                        Join@@Through[{OwnValues,DownValues,SubValues,UpValues}[Unevaluated@@heldSymbol]],
                        HoldPattern[HoldPattern[_]:>value_]:>HoldComplete[value],
                        {1}
                    ];
                (*messages and options are not treated as dependency, hence should be removed.*)
                heldValues =
                    heldValues//ReplaceAll[{mes_MessageName:>"",opt_Options:>""}];
                (*select the symbols by symbolSelector.*)
                heldSymbolList =
                    Cases[
                        heldValues,
                        symbol_Symbol/;symbolSelector[symbol,ifHideSystemSymbol,exclusionList]:>Hold[symbol],
                        {1,Infinity},
                        Heads->True
                    ]//dropHoldCompleteHead[ifHideSystemSymbol]//DeleteDuplicates
        ];
        (*get the values of definitions wrapped by HoldComplete.*)
        Thread@DirectedEdge[heldSymbol,heldSymbolList]
    ];


(*exclude the symbols in specified contexts or created by the function Symbol.*)

symbolSelector//Attributes =
    {HoldFirst};

symbolSelector[Symbol[sname_],_,_] :=
    False;

symbolSelector[symbol_,True,exclusionList_] :=
    With[{context = Context@symbol},
        context=!="System`"&&
            !StringContainsQ[context,exclusionList]
    ];

symbolSelector[symbol_,False,exclusionList_] :=
    !StringContainsQ[Context@symbol,exclusionList];

symbolSelector[___] :=
    False;


(*drop the HoldComplete head of HoldComplete[...].*)

dropHoldCompleteHead[True][heldSymbolList_] :=
    heldSymbolList;

dropHoldCompleteHead[False][heldSymbolList_] :=
    heldSymbolList//Rest;


(*delete symbols without definition, or edges whose target has no definition.*)

ifDeleteSymbolOrEdgeWithoutDefinition[True][list_List] :=
    Select[list,symbolDefinitionPresentQ];

ifDeleteSymbolOrEdgeWithoutDefinition[False][list_List] :=
    list;


symbolDefinitionPresentQ[heldSymbol_Hold] :=
    heldSymbol//Replace[
        Hold[symbol_]:>ValueQ[symbol,Method->"SymbolDefinitionsPresent"]
    ];

symbolDefinitionPresentQ[edge_DirectedEdge] :=
    edge[[2]]//Replace[
        Hold[symbol_]:>ValueQ[symbol,Method->"SymbolDefinitionsPresent"]
    ];

symbolDefinitionPresentQ[_] :=
    False;


(*delete symbols with ownvalue, or edges whose target has ownvalue.*)

ifDeleteSymbolOrEdgeWithOwnValue[True][list_List] :=
    Select[list,symbolOwnValueFreeQ];

ifDeleteSymbolOrEdgeWithOwnValue[False][list_List] :=
    list;


symbolOwnValueFreeQ[heldSymbol_Hold] :=
    heldSymbol//Replace[
        Hold[symbol_]:>!ValueQ[symbol,Method->"OwnValuesPresent"]
    ];

symbolOwnValueFreeQ[edge_DirectedEdge] :=
    edge[[2]]//Replace[
        Hold[symbol_]:>!ValueQ[symbol,Method->"OwnValuesPresent"]
    ];

symbolOwnValueFreeQ[_] :=
    False;


(*delete inbuilt symbols, or edges whose target is inbuilt.*)

ifDeleteSymbolOrEdgeInbuilt[True][list_List] :=
    Select[list,symbolNotInbuiltQ];

ifDeleteSymbolOrEdgeInbuilt[False][list_List] :=
    list;


symbolNotInbuiltQ[heldSymbol_Hold] :=
    heldSymbol//Replace[
        Hold[symbol_]:>Context[symbol]=!="System`"
    ];

symbolNotInbuiltQ[edge_DirectedEdge] :=
    edge[[2]]//Replace[
        Hold[symbol_]:>Context[symbol]=!="System`"
    ];

symbolNotInbuiltQ[_] :=
    False;


(*return target from edges.*)
ifGetSymbolFromEdge[True][list_] :=
    list//Extract[{All,2}]//DeleteDuplicates;

(*return {target,depth} from edges.*)
ifGetSymbolFromEdge[Automatic][list_] :=
    list//Extract[{All,{2,3}}]//ReplaceAll[DirectedEdge->List];

(*return edges unchanged.*)
ifGetSymbolFromEdge[False][list_] :=
    list;


(*show context and symbol name.*)
ifReplaceSymbolByName[True][list_] :=
    list//ReplaceAll[
        Hold[symbol_]:>SymbolName@Unevaluated@symbol
    ];

(*show symbol name only.*)
ifReplaceSymbolByName[False][list_] :=
    list//ReplaceAll[
        Hold[symbol_]:>StringJoin[Context@symbol,SymbolName@Unevaluated@symbol]
    ];

(*show context according to $ContextPath.*)
ifReplaceSymbolByName[Automatic][list_] :=
    list//ReplaceAll[
        Hold[symbol_]:>ToString@Unevaluated@symbol
    ];


(* ::Subsection:: *)
(*End*)


End[];


(* ::Section:: *)
(*End*)


EndPackage[];
