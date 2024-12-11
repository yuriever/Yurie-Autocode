

(*dependency.nb*)

VerificationTest[
	Begin["Global`"];
	ClearAll["`*"]
	,
	Null
	,
	TestID->"0-dependency.nb"
]

VerificationTest[
	Get["Yurie`Autocode`"]; 
	Get["Yurie`Autocode`Info`"]; 
	Get[FileNameJoin[{$thisSourceDir, "testcode-dependency.wl"}]]
	,
	Null
	,
	TestID->"1-dependency.nb"
]

VerificationTest[
	Yurie`Autocode`dependency`Private`getRelationFromHeldSymbol[True, {}][Hold[a]]
	,
	{DirectedEdge[Hold[a], Hold[b]], DirectedEdge[Hold[a], Hold[a]], DirectedEdge[Hold[a], Hold[Global`Private`a1]], DirectedEdge[Hold[a], Hold[Global`Private`a2]]}
	,
	TestID->"2-dependency.nb"
]

VerificationTest[
	Yurie`Autocode`dependency`Private`getRelationFromHeldSymbol[False, {}][Hold[a]]
	,
	{DirectedEdge[Hold[a], Hold[b]], DirectedEdge[Hold[a], Hold[Symbol]], DirectedEdge[Hold[a], Hold[a]], DirectedEdge[Hold[a], Hold[Global`Private`a1]], DirectedEdge[Hold[a], Hold[Global`Private`a2]]}
	,
	TestID->"3-dependency.nb"
]

VerificationTest[
	Yurie`Autocode`dependency`Private`getEdgeFromDefinition[True, {}, 1][Hold[g]]
	,
	{}
	,
	TestID->"4-dependency.nb"
]

VerificationTest[
	Yurie`Autocode`dependency`Private`getEdgeFromDefinition[False, {}, 1][Hold[g]]
	,
	{DirectedEdge[Hold[g], Hold[CompoundExpression], 1], DirectedEdge[Hold[g], Hold[Message], 1], DirectedEdge[Hold[g], Hold[List], 1]}
	,
	TestID->"5-dependency.nb"
]

VerificationTest[
	dependency[a, 8, "HideContext" -> False, "SymbolOrRelation" -> True, "HideSymbolWithoutDefinition" -> False, "HideSymbolWithOwnValue" -> True]
	,
	{"Global`Private`a1", "Global`Private`a2", "Global`Private`c", "Global`Private`d", "Global`e", "Global`f"}
	,
	TestID->"6-dependency.nb"
]

VerificationTest[
	dependency[a, 8, "HideContext" -> True, "SymbolOrRelation" -> Automatic, "HideSymbolWithoutDefinition" -> True, "HideSymbolWithOwnValue" -> True]
	,
	{{"c", 2}, {"d", 2}, {"e", 3}, {"f", 3}}
	,
	TestID->"7-dependency.nb"
]

VerificationTest[
	dependency[a, 8, "HideContext" -> Automatic, "SymbolOrRelation" -> False, "HideSymbolWithoutDefinition" -> False, "HideSymbolWithOwnValue" -> True]
	,
	{DirectedEdge["a", "Global`Private`a1", 1], DirectedEdge["a", "Global`Private`a2", 1], DirectedEdge["b", "Global`Private`c", 2], DirectedEdge["b", "Global`Private`d", 2], DirectedEdge["Global`Private`c", "e", 3], DirectedEdge["Global`Private`c", "f", 3]}
	,
	TestID->"8-dependency.nb"
]

VerificationTest[
	dependencyGraph[a, "HideSymbolWithoutDefinition" -> False, "HideSymbolWithOwnValue" -> False]
	,
	Graph[{"a", "b", "a1", "a2", "c", "d", "e", "f", "g"}, {{{1, 2}, {1, 1}, {1, 3}, {1, 4}, {2, 2}, {2, 5}, {2, 6}, {5, 7}, {5, 8}, {6, 9}, {7, 2}, {8, 9}}, Null, {1, 1, 1, 1, 2, 2, 2, 3, 3, 3, 4, 4}}, {AlignmentPoint -> Center, Axes -> False, AxesLabel -> None, AxesOrigin -> Automatic, AxesStyle -> {}, Background -> None, BaseStyle -> {}, BaselinePosition -> Automatic, ContentSelectable -> Automatic, Epilog -> {}, FormatType -> TraditionalForm, Frame -> False, FrameLabel -> None, FrameStyle -> {}, FrameTicksStyle -> {}, GridLines -> None, GridLinesStyle -> {}, ImageMargins -> 0., ImagePadding -> All, ImageSize -> Full, LabelStyle -> {}, PlotLabel -> None, PlotRange -> All, PlotRangeClipping -> False, PlotRangePadding -> Automatic, PlotRegion -> Automatic, Prolog -> {}, RotateLabel -> True, Ticks -> Automatic, TicksStyle -> {}, AlignmentPoint -> Center, AspectRatio -> Automatic, Axes -> False, AxesLabel -> None, AxesOrigin -> Automatic, AxesStyle -> {}, Background -> None, BaselinePosition -> Automatic, BaseStyle -> {}, ContentSelectable -> Automatic, EdgeLabels -> {"EdgeTag"}, EdgeStyle -> {DirectedEdge["b", "c", 2] -> {Hue[0.09999999999999998, 0.4, 0.9, 0.9]}, DirectedEdge["e", "b", 4] -> {Hue[0.6, 0.4, 0.9, 0.9]}, DirectedEdge["b", "d", 2] -> {Hue[0.09999999999999998, 0.4, 0.9, 0.9]}, DirectedEdge["a", "a", 1] -> {Hue[-0.15000000000000002, 0.4, 0.9, 0.9]}, DirectedEdge["d", "g", 3] -> {Hue[0.35, 0.4, 0.9, 0.9]}, DirectedEdge["c", "f", 3] -> {Hue[0.35, 0.4, 0.9, 0.9]}, DirectedEdge["a", "a1", 1] -> {Hue[-0.15000000000000002, 0.4, 0.9, 0.9]}, DirectedEdge["b", "b", 2] -> {Hue[0.09999999999999998, 0.4, 0.9, 0.9]}, DirectedEdge["a", "a2", 1] -> {Hue[-0.15000000000000002, 0.4, 0.9, 0.9]}, DirectedEdge["c", "e", 3] -> {Hue[0.35, 0.4, 0.9, 0.9]}, DirectedEdge["a", "b", 1] -> {Hue[-0.15000000000000002, 0.4, 0.9, 0.9]}, DirectedEdge["f", "g", 4] -> {Hue[0.6, 0.4, 0.9, 0.9]}}, Editable -> False, Epilog -> {}, FormatType -> TraditionalForm, Frame -> False, FrameLabel -> None, FrameStyle -> {}, FrameTicks -> None, FrameTicksStyle -> {}, GraphLayout -> Automatic, GraphStyle -> Automatic, GridLines -> None, GridLinesStyle -> {}, ImageMargins -> 0., ImagePadding -> All, ImageSize -> Full, LabelStyle -> {}, PerformanceGoal -> Automatic, PlotLabel -> None, PlotRange -> All, PlotRangeClipping -> False, PlotRangePadding -> Automatic, PlotRegion -> Automatic, PlotTheme -> Automatic, Prolog -> {}, RotateLabel -> True, Ticks -> Automatic, TicksStyle -> {}, VertexLabels -> {Placed["Name", Below, Style[#1, Small] & ]}, VertexStyle -> {Directive[RGBColor[1, 0.5, 0.5], EdgeForm[None]]}}]
	,
	TestID->"9-dependency.nb"
]

VerificationTest[
	ClearAll["Global`*"]; 
	(ClearAll["Global`*`*"]; )
	,
	Null
	,
	TestID->"10-dependency.nb"
]

VerificationTest[
	ClearAll["`*"];
	End[]
	,
	"Global`"
	,
	TestID->"∞-dependency.nb"
]