

(*convertNotebookToWLT-2dexpr.nb*)

VerificationTest[
	Begin["Global`"];
	ClearAll["`*"]
	,
	Null
	,
	TestID->"0-convertNotebookToWLT-2dexpr.nb"
]

VerificationTest[
	D[f[x, y], {x, 1}, {y, 1}]
	,
	Derivative[1, 1][f][x, y]
	,
	TestID->"1-convertNotebookToWLT-2dexpr.nb"
]

VerificationTest[
	ClearAll["`*"];
	End[]
	,
	"Global`"
	,
	TestID->"∞-convertNotebookToWLT-2dexpr.nb"
]