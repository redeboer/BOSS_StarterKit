#!/bin/bash -

export BOSS_StarterKit_OutputDir="${BOSS_StarterKit}/output"

for i in $(find "${BOSS_StarterKit}/workarea" -type f -wholename "*/setup.sh"); do
  source "$i"
done

for i in $(find "${BOSS_StarterKit}/workarea" -type d -wholename *-[0-9][0-9]-[0-9][0-9]-[0-9][0-9]); do
  alias cd$(echo "$(basename $(dirname $i))" | tr '[:upper:]' '[:lower:]')="cd ${i}"
done