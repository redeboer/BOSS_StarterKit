# `cmthome` folder

The `cmthome` folder manages your access to the BOSS install on
[`lxslc`](https://besiii.gitbook.io/boss/tutorials/getting-started/server) and
is essentially a copy of
`/cvmfs/bes3.ihep.ac.cn/bes3sw/Boss/cmthome/cmthome-$BOSSVERSION/` (see
[Set up your BOSS environment](https://app.gitbook.com/@besiii/s/boss/tutorials/getting-started/setup)).
The folder should be located next to your
[`workarea`](https://github.com/redeboer/BOSS_StarterKit/tree/master/workarea).

Note that files such as
[`cmthome/setup.sh`](https://github.com/redeboer/BOSS_StarterKit/blob/master/cmthome/setup.sh)
use `bash` variables such as `$BOSSINSTALL`, which need to be set before
sourcing them. This is done using by sourcing
[`setup/LoadBoss.sh`](https://github.com/redeboer/BOSS_StarterKit/blob/master/setup/LoadBoss.sh),
where `BOSSINSTALL` is determined automatically. CMT will update the paths in
the files under `cmthome` accordingly, but these changes should be shielded
from being commited to this repository using
`git update-index --assume-unchanged cmthome/*`, because we want the Starter
Kit to be general in usage.
