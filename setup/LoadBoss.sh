#!/bin/bash -
# echo "Loading \"${BASH_SOURCE[0]/$(dirname ${BOSS_StarterKit})\/}\""

# * BOSS paths and parameters * #
export BOSSVERSION="7.0.4"
export CMTHOMENAME="cmthome"
export WORKAREANAME="workarea"

export BESFS="/besfs/users/${USER}"
export BOSSINSTALL="${BOSS_StarterKit}"
export IHEPBATCH="/ihepbatch/bes/${USER}"
export SCRATCHFS="/scratchfs/bes/${USER}"
CMTHOME="/afs/ihep.ac.cn/bes3/offline/Boss/cmthome/cmthome-${BOSSVERSION}"

# * Load BOSS essentials * #
source "${BOSSINSTALL}/${CMTHOMENAME}/setupCMT.sh"
source "${BOSSINSTALL}/${CMTHOMENAME}/setup.sh"
export PATH=$PATH:/afs/ihep.ac.cn/soft/common/sysgroup/hep_job/bin/

# Fetch TestRelease if not available
if [[ ! -d "${BOSSINSTALL}/workarea/TestRelease" ]]; then
  currentPath="$(pwd)"
  cd "${BOSSINSTALL}/workarea"
  cp -R "${BesArea}/TestRelease" .
  cd TestRelease/TestRelease-*/cmt
  cmt broadcast
  make
  cd "${currentPath}"
fi
source "${BOSSINSTALL}/${WORKAREANAME}/TestRelease/TestRelease-"*"/cmt/setup.sh"