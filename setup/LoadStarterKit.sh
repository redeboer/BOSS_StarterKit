#!/bin/bash -

export BOSS_StarterKit_OutputDir="${BOSS_StarterKit}/output"

for i in $(find "${BOSS_StarterKit}/workarea" -type f -wholename "*/setup.sh"); do
  [[ ! "${i}" =~ /cmt/ ]] && source "${i}"
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