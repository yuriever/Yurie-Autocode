(* ::Package:: *)

PacletObject[
  <|
    "Name" -> "Yurie/Autocode",
    "Description" -> "Code tools",
    "Creator" -> "Yurie",
    "License" -> "MIT",
    "PublisherID" -> "Yurie",
    "Version" -> "2.0.0",
    "WolframVersion" -> "14.2+",
    "PrimaryContext" -> "Yurie`Autocode`",
    "Extensions" -> {
      {
        "Kernel",
        "Root" -> "Kernel",
        "Context" -> {
            "Yurie`Autocode`"
        }
      },
      {
        "Kernel",
        "Root" -> "Utility",
        "Context" -> {
          "Yurie`Autocode`Info`"
        }
      },
      {
        "AutoCompletionData",
        "Root" -> "AutoCompletionData"
      },
      {
        "Asset",
        "Root" -> ".",
        "Assets" -> {
          {"License", "LICENSE"},
          {"ReadMe", "README.md"},
          {"Source", "Source"},
          {"Test", "Test"},
          {"TestSource", "TestSource"}
        }
      }
    }
  |>
]
