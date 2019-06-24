#!/bin/bash -

function rtcompile () {
  g++ "$1" -std=c++0x -I$(root-config --incdir) $(root-config --libs --evelibs --glibs) -lRooFit -lRooFitCore -lRooStats -lMinuit -o "${1/.*/.o}"
}
function rtcompilerun () {
  rtcompile "$1"
  if [ $? -eq 0 ]; then
    ./${1/.*/.o}
  fi
}
function rtdebugcompile () {
  g++ "$1" -std=c++0x -I$(root-config --incdir) $(root-config --libs --evelibs --glibs) -lRooFit -lRooFitCore -lRooStats -lMinuit -fsanitize=address -o "${1/.*/.o}"
}
function rtdebugcompilerun () {
  rtdebugcompile "$1"
  if [ $? -eq 0 ]; then
    ./${1/.*/.o}
  fi
}
export rtcompile
export rtcompilerun
export rtdebugcompile
export rtdebugcompilerun