#!/bin/bash -

export BOSS_StarterKit_OutputDir="${BOSS_StarterKit}/output"

# Newest version of Git
if [[ -d "/cvmfs/bes3.ihep.ac.cn/bes3sw/ExternalLib/SLC6/contrib/git" ]]; then
  source "/cvmfs/bes3.ihep.ac.cn/bes3sw/ExternalLib/SLC6/contrib/git/setup.sh"
else
  [[ -f "${BOSS_StarterKit}/ThirdParty/git/git" ]] && export PATH=${BOSS_StarterKit}/ThirdParty/git:$PATH
  [[ -f "${BOSS_StarterKit}/ThirdParty/git-boss/git-boss" ]] && export PATH=${BOSS_StarterKit}/ThirdParty/git-boss:$PATH
fi

for i in $(find "${BOSS_StarterKit}" -type f -wholename "${BOSS_StarterKit}/*/setup.sh"); do
  [[ ! "${i}" =~ /cmt/ ]] && [[ ! "${i}" =~ /cmthome/ ]] && source "${i}"
done

if [[ $(command -v cmt) != "" ]]; then
  for i in $(find "${BOSS_StarterKit}/workarea" -type f -wholename "*/cmt/setup.sh"); do
    [[ ! "${i}" =~ /TestRelease ]] && source "${i}"
    # Note: TestRelease package should be loaded through LoadBoss.sh
  done
fi

for i in $(find "${BOSS_StarterKit}/workarea" -type d -wholename *-[0-9][0-9]-[0-9][0-9]-[0-9][0-9]); do
  alias cd$(echo "$(basename $(dirname ${i}))" | tr '[:upper:]' '[:lower:]')="cd ${i}"
done
