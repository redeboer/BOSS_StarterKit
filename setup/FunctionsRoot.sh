#!/bin/bash -

function rtcompile() {
  g++ "$1" -std=c++0x -I$(root-config --incdir) $(root-config --libs --evelibs --glibs) -lRooFit -lRooFitCore -lRooStats -lMinuit -o "${1/.*/.o}"
}
function rtcompilerun() {
  local script="$1"
  rtcompile "$script"
  shift
  if [[ $? -eq 0 ]]; then
    ./${script/.*/.o} $*
  fi
}
function rtdebugcompile() {
  g++ "$1" -std=c++0x -I$(root-config --incdir) $(root-config --libs --evelibs --glibs) -lRooFit -lRooFitCore -lRooStats -lMinuit -fsanitize=address -o "${1/.*/.o}"
}
function rtdebugcompilerun() {
  local script="$1"
  rtdebugcompile "$script"
  shift
  if [[ $? -eq 0 ]]; then
    ./${script/.*/.o} $*
  fi
}
export rtcompile
export rtcompilerun
export rtdebugcompile
export rtdebugcompilerun
