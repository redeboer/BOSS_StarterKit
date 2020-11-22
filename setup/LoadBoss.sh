#!/bin/bash -
# echo "Loading \"${BASH_SOURCE[0]/$(dirname ${BOSS_StarterKit})\/}\""
BesAreaTemp="/afs/ihep.ac.cn/bes3/offline/Boss"
defaultVersion="7.0.4"

# * BOSS paths and parameters * #
currentPath9="$(pwd)"
BOSSversionFile="$(dirname ${BASH_SOURCE[0]})"
cd "${BOSSversionFile}"
BOSSversionFile="$(pwd)/BOSSVERSION"
if [[ -f "${BOSSversionFile}" ]]; then
  BOSSVERSION=$(head -n 1 "${BOSSversionFile}")
else
  cd $BesAreaTemp
  echo "It seems this is the first time you load BOSS."
  read -e -p "Which version do you want to load? " -i $defaultVersion BOSSVERSION
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
cd "${currentPath9}"

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
