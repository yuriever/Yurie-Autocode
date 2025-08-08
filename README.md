# [Yurie/Autocode](https://github.com/yuriever/Yurie-Autocode)

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)
[![Wolfram Language](https://img.shields.io/badge/Wolfram%20Language-14.2%2B-red.svg)](https://www.wolfram.com/language/)

Code tools.


## Documentation

[Documentation](https://yuriever.github.io/symbolic/Yurie-Autocode/doc/)


## Usage

1. Clone or download this repository

2. Move the entire folder to the user paclet directory:

   ```wl
   $UserBasePacletsDirectory
   ```

3. Rebuild the paclet data:

   ```wl
   PacletDataRebuild[]
   ```

4. Load the paclet

    ```wl
    Needs["Yurie`Autocode`"]
    ```


### Uninstallation

```wl
PacletUninstall["Yurie/Autocode"]
```


### Installation checking

```wl
PacletFind["Yurie/Autocode"]
```
