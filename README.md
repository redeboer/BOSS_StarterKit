# BOSS Starter Kit

For more information on BOSS, see the [BOSS Gitbook](https://besiii.gitbook.io/boss).

## How to install?

Get a local copy of this repository by cloning it:

```
git clone git@github.com:redeboer/BOSS_StarterKit.git
```

You have now downloaded the main ingredients of the Starter Kit.

In addition, this repository contains several [submodules](https://git-scm.com/book/en/Git-Tools-Submodules). There are two types of submodules: (1) *real submodules*, which are listed in the [`.gitmodules`](https://github.com/redeboer/BOSS_StarterKit/blob/master/.gitmodules) file, and (2) subrepositories, which are not listed, because they are analysis specific. If you navigate into the `BOSS_StarterKit` you cloned just now, you can see an overview of the different submodules using `git submodule status`. Real submodules have an attacted commit ID (e.g. `-4b42a5880dce1bbe13ba580d0b32ac3281b2267a`), while subrepositories are indicated with `No submodule mapping found in .gitmodules for path ...`.

### (1) Real submodules

Real submodules can be used by anyone in BESIII and should therefore be available as separate, public repositories. An example are the `Tutorials`: have a look in the `workarea` [here](https://github.com/redeboer/BOSS_StarterKit/tree/master/workarea) and you can see that the `Tutorials` folder has a commit ID attached with `@`. Click that folder, and it will bring you to the original [`BOSS_Tutorials`](https://github.com/redeboer/BOSS_Tutorials/) repository.

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

Note that subrepositories are not downloaded in neither case.

Submodules are tied to certain commits of the corresponding repository. If there that corresponding repository has new commits, you can pull all changes using:

```bash
git submodule foreach "(git checkout master; git pull)"
```

Note that the Starter Kit considers this a change: the commits you imported need to be 'reconnected' to the submodule. You can see that the submodules have been moduled with `git status`. To push this as a new commit to the BOSS Starter Kit, use the usual procedure:

```bash
git add .
git commit -m "<commit message>"
git push
```

Another characteristic of a submodule, is it does not contain a `.git` folder. Instead, there is a `.git` file which contains a relative path pointing to the corresponding submodule under the folder `.git/modules` in the BOSS Starter Kit.

### (2) Subrepositories

Subrepositories (as opposed to submodules) allow the user to implement ones own repository into the BOSS Starter Kit without having it added as a submodule. In essence, a subrepository is just a Git repository that you put inside the BOSS Starter Kit, but that you shield from being commited by adding its relative path to the [`.gitignore`](https://github.com/redeboer/BOSS_StarterKit/blob/master/.gitignore) file of the Starter Kit. As such, other users of the Starter Kit will not be able to download your subrepository as a submodule, but can only see its existence in [`.gitignore`](https://github.com/redeboer/BOSS_StarterKit/blob/master/.gitignore).

If you have a cloned a repository within this repository that you do not want to track as a submodule, first add it to the `.gitignore` file, then use `git update-index --assume-unchanged <relative path to subrepository>`. You should use the latter command for the `cmt` folders as well if you do not want the setup files in there to be commited after you used `cmt config` (which will write your user name to those files).

If you navigate inside a subrepository, you can just use Git the way you are used to: `git` commands apply to the subrepository and not to the overarching BOSS Starter Kit repository.

### Some useful information on submodules
- [Git submodules on Git SCM](https://git-scm.com/book/en/v2/Git-Tools-Submodules)
- [Git submodules Git Wiki](https://git.wiki.kernel.org/index.php/GitSubmoduleTutorial)
- [Working with Git templates](https://git-template.readthedocs.io/en/latest/) (this is a different feature, but the template module has been considered for the Starter Kit)
