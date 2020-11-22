# `workarea` folder

The `workarea` folder contains your own BOSS packages. If you
[correctly set up your BOSS environment](https://app.gitbook.com/@besiii/s/boss/tutorials/getting-started/setup#step-4-create-a-workarea-subfolder),
the `workarea` is listed as a path in `$CMTPATH`, which means that CMT searches
in this directory first. It will then search in the actual installation
directory of BOSS (located under `$BesArea`). **As such, the file structure of
`workarea` should reflect that of the `$BesArea`.**
