# BOSS Starter Kit

The BOSS Starter Kit is designed to simplify working with the BESIII Offline Softare System ([BOSS](https://besiii.gitbook.io/boss/tutorials/getting-started/intro)) on IHEP's [`lxslc` server](https://besiii.gitbook.io/boss/tutorials/getting-started/server). The design through submodules and the [utilities that come along with it](#main-functions) are to facilitate code collaboration within BESIII.


## How to install?

Get a local copy of this repository by cloning it:

```
git clone http://code.ihep.ac.cn/bes3/BOSS_StarterKit
```

If you prefer to work over SSH, use `git@code.ihep.ac.cn:bes3/BOSS_StarterKit.git`.

You have now downloaded the main ingredients of the Starter Kit. The BOSS environment can now be set up easily by navigatinv into the `BOSS_StarterKit` directory and executing `source setup.sh`. If you add `<path to BOSS_StarterKit>/setup.sh` to your `.bash_profile` or `.bash_rc` as well, you have your BOSS environment and all functionality of the Starter Kit loaded whenever you log into `lxslc`.

## Main functions

- [Automatic loading of the BOSS environment](http://code.ihep.ac.cn/bes3/BOSS_StarterKit/blob/master/setup/LoadBoss.sh), including fetching a local copy of the `TestRelease` package.
- Download [collaboration-wide submodules](#1-real-submodules) or [implement your own subrepositories](#2-subrepositories).
- All your packages in `workarea` are [sourced automatically at startup](http://code.ihep.ac.cn/bes3/BOSS_StarterKit/blob/c0a132c175af944751ca038b5cf7fc621e1c5180/setup/LoadStarterKit.sh#L11).
- Navigate quickly to your own packages through the command `cd<package name in lowercase>`.
- A [collection of `bash` functions](http://code.ihep.ac.cn/bes3/BOSS_StarterKit/blob/master/setup/Functions.sh) that are useful when working with CMT and BOSS.
- A handy `bash` script that allows you to [quickly set up a BOSS environment elsewhere](http://code.ihep.ac.cn/bes3/BOSS_StarterKit/blob/master/utilities/SetupBoss.sh) of whatever BOSS version you choose. If you do not want to use the Starter Kit, you can run it without cloning using `wget https://raw.githubusercontent.com/redeboer/BOSS_StarterKit/master/utilities/SetupBoss.sh; bash SetupBoss.sh`.
- Automatically standardise the layout of your C++ code using [`clang-format -i <path to some file or directory>`](http://code.ihep.ac.cn/bes3/BOSS_StarterKit/blob/master/.clang-format). You analyse all `C++` files recursively over any folder using `RunClang`.
- Generate Doxygen class documentation for all your packages through [`doxygen Doxyfile`](http://code.ihep.ac.cn/bes3/BOSS_StarterKit/blob/master/Doxyfile).


## Submodules

BOSS is built up of several packages and that are managed through the [Configuration Management Tool (CMT)](http://www.cmtsite.net/CMTDoc.html) and you will be developing your own packages within your local `workarea`. Since this `workarea` folder is [located within the Starter Kit](http://code.ihep.ac.cn/bes3/BOSS_StarterKit/tree/master/workarea), and we want the Starter Kit to contain only general tools, these packages somehow need to be prevented from being staged through Git.

For this reason, the Starter Kit repository is therefore built up of several [submodules](https://git-scm.com/book/en/Git-Tools-Submodules). There are two types of submodules: (1) *real submodules*, which are listed in the [`.gitmodules`](http://code.ihep.ac.cn/bes3/BOSS_StarterKit/blob/master/.gitmodules) file, and (2) subrepositories, which are not listed, because they are analysis specific. If you navigate into the `BOSS_StarterKit` you cloned just now, you can see an overview of the different submodules using `git submodule status`. Real submodules have an attacted commit ID (e.g. `-4b42a5880dce1bbe13ba580d0b32ac3281b2267a`), while subrepositories are indicated with `No submodule mapping found in .gitmodules for path ...`. As suggested by the latter, an overview of the real submodules can be found in the [`.gitignore`](.gitmodules) file.

### (1) Real submodules

Real submodules are general in usage within BESIII and should therefore be available as separate, public repositories. An example are the `Tutorials`: have a look in the `workarea` [here](http://code.ihep.ac.cn/bes3/BOSS_StarterKit/tree/master/workarea) and you can see that the `Tutorials` folder has a commit ID attached with `@`. Click that folder, and it will bring you to the corresponding commit of the original [`BOSS_Tutorials`](http://code.ihep.ac.cn/bes3/BOSS_Tutorials/) repository.

After you have cloned the BOSS Starter Kit, you can download a specific submodule using:

```bash
git submodule init -- <relative path to submodule>
git submodule update -- <relative path to submodule>
```

You can also chose to download them all in one go by using:

```bash
git submodule init
git submodule update
```

Submodules are tied to certain commits of the corresponding repository. If that corresponding repository has new commits, you can pull all changes using:

```bash
git submodule foreach "(git checkout master; git pull)"
```

You might have to use `git fetch --all` as well if you want to push to the corresponding repository.

Note that the overarching Starter Kit repository considers this a change: the commits you imported need to be 'reconnected' to the submodule. You can see that the submodules have been moduled with `git status`. To push this as a new commit to the BOSS Starter Kit, use the usual procedure:

```bash
git add .
git commit -m "<commit message>"
git push
```

Another characteristic of a submodule, is it does not contain a `.git` folder. Instead, there is a `.git` file which contains a relative path pointing to the corresponding submodule under the folder `.git/modules` in the BOSS Starter Kit.

### (2) Subrepositories

Packages that are only used by you or by a specific analysis group within BESIII should not be accessible as a submodule and therefore need to be added by the [`.gitignore`](http://code.ihep.ac.cn/bes3/BOSS_StarterKit/blob/master/.gitignore) of the Starter Kit. If such a package happens to be a repository in itself, we call it a *subrepository*. Other users of the Starter Kit will not be able to download your subrepository as a submodule, but can only see its existence in [`.gitignore`](http://code.ihep.ac.cn/bes3/BOSS_StarterKit/blob/master/.gitignore).

If you navigate inside a subrepository, you can just use Git the way you are used to: `git` commands apply to the subrepository and not to the overarching BOSS Starter Kit repository. The same goes for real submodules.

### Some useful information on submodules
- [Git submodules on Git SCM](https://git-scm.com/book/en/v2/Git-Tools-Submodules)
- [Git submodules Git Wiki](https://git.wiki.kernel.org/index.php/GitSubmoduleTutorial)
- [Working with Git templates](https://git-template.readthedocs.io/en/latest/) (this is a different feature, but the template module has been considered for the Starter Kit)


## Tips for CMT and Git

- After you run `cmt config` the `cmt` folder of a package, CMT will update the paths in the `setup` and `cleanup` scripts. We do not want to have these changes appear constantly when using `git status`, but we do want these scripts to be available in the repository. It is therefore best practice to add the `cmt` folder to `.gitignore` and to force add (`git add -f`) these files once. CMT will then modify these files again, but you can completely stop these files from being indexed again by using `git update-index --assume-unchanged <setup.sh or cleanup.sh>`. You can also use the command `gitignorecmt` [provided by the Starter Kit](http://code.ihep.ac.cn/bes3/BOSS_StarterKit/blob/c0a132c175af944751ca038b5cf7fc621e1c5180/setup/Functions.sh#L549).
