#!/bin/bash -

export BOSS_StarterKit_OutputDir="${BOSS_StarterKit}/output"

# Fetch TestRelease if not available
currentPath="$(pwd)"
if [[ ! -d "${BOSS_StarterKit}/workarea/TestRelease" ]]; then
  cd "${BOSS_StarterKit}/workarea"
  cp -R "${BesArea}/TestRelease" .
  cd TestRelease/TestRelease-*/cmt
  cmt broadcast
  make
  cd "${currentPath}"
fi

for i in $(find "${BOSS_StarterKit}/workarea" -type f -wholename */setup.sh); do
  source "$i"
done

for i in $(find "${BOSS_StarterKit}/workarea" -type d -wholename *-[0-9][0-9]-[0-9][0-9]-[0-9][0-9]); do
  alias cd$(echo "$(basename $(dirname $i))" | tr '[:upper:]' '[:lower:]')="cd ${i}"
done