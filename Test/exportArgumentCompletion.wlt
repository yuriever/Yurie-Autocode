

(*exportArgumentCompletion.nb*)

VerificationTest[
	Begin["Global`"];
	ClearAll["`*"]
	,
	Null
	,
	TestID->"0-exportArgumentCompletion.nb"
]

VerificationTest[
	Get["Yurie`Autocode`"]; 
	Get["Yurie`Autocode`Info`"]; 
	(Get[FileNameJoin[{$thisSourceDir, "testcode-option.wl"}]]; )
	,
	Null
	,
	TestID->"1-exportArgumentCompletion.nb"
]

VerificationTest[
	Yurie`Autocode`exportArgumentCompletion`Private`maxNumberOfNormalArgument /@ {"f0", "f1", "f2"}
	,
	{2, 1, 0}
	,
	TestID->"2-exportArgumentCompletion.nb"
]

VerificationTest[
	Yurie`Autocode`exportArgumentCompletion`Private`maxNumberOfNormalArgument /@ {"g0", "g1", "g2"}
	,
	{2, 1, 0}
	,
	TestID->"3-exportArgumentCompletion.nb"
]

VerificationTest[
	Yurie`Autocode`exportArgumentCompletion`Private`maxNumberOfNormalArgument["h"]
	,
	Quiet[0]
	,
	{Yurie`Autocode`exportArgumentCompletion::hasOwnValues}
	,
	TestID->"4-exportArgumentCompletion.nb"
]

VerificationTest[
	Yurie`Autocode`exportArgumentCompletion`Private`maxNumberOfNormalArgument["j"]
	,
	1
	,
	TestID->"5-exportArgumentCompletion.nb"
]

VerificationTest[
	Quiet[Yurie`Autocode`exportArgumentCompletion`Private`getOptionCompletionData /@ {"f0", "f1", "f2", "g0", "g1", "g2"}]
	,
	{"f0" -> {0, 0}, "f1" -> {0}, "f2" -> {}, "g0" -> {0, 0}, "g1" -> {0}, "g2" -> {}}
	,
	TestID->"6-exportArgumentCompletion.nb"
]

VerificationTest[
	Yurie`Autocode`exportArgumentCompletion`Private`getArgumentCompletionData[{"k", "j"}, {"l" -> {0, {"Test"}}}]
	,
	{"k" -> {0, {"Test"}}, "j" -> {0, {"Test"}}, "l" -> {0, {"Test"}}}
	,
	TestID->"7-exportArgumentCompletion.nb"
]

VerificationTest[
	Yurie`Autocode`exportArgumentCompletion`Private`getOptionCompletionData["h"]
	,
	Quiet["h" -> {}]
	,
	{Yurie`Autocode`exportArgumentCompletion::hasOwnValues,Yurie`Autocode`exportArgumentCompletion::noStringOptions}
	,
	TestID->"8-exportArgumentCompletion.nb"
]

VerificationTest[
	Yurie`Autocode`exportArgumentCompletion`Private`getOptionCompletionData["k" -> {{"arg1", "arg2"}, 0}]
	,
	"k" -> {{"arg1", "arg2"}, 0, {"Test"}}
	,
	TestID->"9-exportArgumentCompletion.nb"
]

VerificationTest[
	ClearAll["Global`*"]; 
	(ClearAll["Global`*`*"]; )
	,
	Null
	,
	TestID->"10-exportArgumentCompletion.nb"
]

VerificationTest[
	ClearAll["`*"];
	End[]
	,
	"Global`"
	,
	TestID->"∞-exportArgumentCompletion.nb"
]