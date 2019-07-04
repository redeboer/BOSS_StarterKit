#!/bin/bash -
# echo "Loading \"${BASH_SOURCE[0]/$(dirname ${BOSS_StarterKit})\/}\""
BesAreaTemp="/afs/ihep.ac.cn/bes3/offline/Boss"

# * BOSS paths and parameters * #
BOSSversionFile="$(dirname ${BASH_SOURCE[0]})/BOSSVERSION"
if [[ -f "${BOSSversionFile}" ]]; then
  BOSSVERSION=$(head -n 1 "${BOSSversionFile}")
else
  echo "It seems this is the first time you load BOSS."
  read -p "Which version do you want to load? (default: 7.0.4) " BOSSVERSION
  echo
  echo "Will load version ${BOSSVERSION} from now on. Change file"
  echo "  ${BOSSversionFile}"
  echo "if you want to switch version"
  echo "${BOSSVERSION}" > ${BOSSversionFile}
fi
if [[ ! -d "${BesAreaTemp}/${BOSSVERSION}" ]]; then
  PrintError "BOSS version ${BOSSVERSION} does not exist!"
  PrintError "  Check file \"${BOSSversionFile}\""
  echo "You can find all BOSS versions under ${BesArea}"
  echo "  ${BesArea}"
  exit 1
fi
export BOSSVERSION
export CMTHOMENAME="cmthome"
export WORKAREANAME="workarea"

export BESFS="/besfs/users/${USER}"
export BOSSINSTALL="${BOSS_StarterKit}"
export IHEPBATCH="/ihepbatch/bes/${USER}"
export SCRATCHFS="/scratchfs/bes/${USER}"
# CMTHOME="/afs/ihep.ac.cn/bes3/offline/Boss/cmthome/cmthome-${BOSSVERSION}"

# * Load BOSS essentials * #
source "${BOSSINSTALL}/${CMTHOMENAME}/setupCMT.sh"
source "${BOSSINSTALL}/${CMTHOMENAME}/setup.sh"
source "${BesArea}/TestRelease/TestRelease-"*"/cmt/setup.sh"
export PATH=$PATH:/afs/ihep.ac.cn/soft/common/sysgroup/hep_job/bin/