

(*convertNotebookToWLT-simple.nb*)

VerificationTest[
	Begin["Global`"];
	ClearAll["`*"]
	,
	Null
	,
	TestID->"0-convertNotebookToWLT-simple.nb"
]

VerificationTest[
	Get["Yurie`Base`"]
	,
	Null
	,
	TestID->"1-convertNotebookToWLT-simple.nb"
]

VerificationTest[
	colorHexify[Red]
	,
	"#ff0000"
	,
	TestID->"2-convertNotebookToWLT-simple.nb"
]

VerificationTest[
	ClearAll["`*"];
	End[]
	,
	"Global`"
	,
	TestID->"∞-convertNotebookToWLT-simple.nb"
]