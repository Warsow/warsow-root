# Warsow Root

This project provides you with scripts to build the latest version of Warsow.


## `bin/warsow`

Alias for `bin/warsow-builder --run`


## `bin/warsow-builder`

Currently, this script does the following:

- Copies game assets
- Compiles qfusion from sources

```
Usage: bin/warsow-builder [(-r --run)] [(-c --clean)] ...

Example:
  bin/warsow-builder --run +set developer 1
```

It creates two new directories:

- `build/warsow` (game folder)
- `build/warsow-home-data` (home data folder)

You can put your configs, extra maps or other data into `warsow-home-data`.


### `bin/warsow-builder (-r --run)`

Runs Warsow after a successful build.


### `bin/warsow-builder (-c --clean)`

Removes `build/warsow` and cleans `qfusion` folder.
