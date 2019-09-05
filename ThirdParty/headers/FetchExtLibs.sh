source "${BOSS_StarterKit}/setup/FunctionsPrint.sh"

currentPath="$(pwd)"
extLibs="/afs/ihep.ac.cn/bes3/offline/ExternalLib/SLC6/ExternalLib"
scratchDir="/scratchfs/bes/$USER"
targetDir="${BOSS_StarterKit}/ThirdParty/headers"

function AbortScript()
{
  local message="${1:-}"
  [[ "${message}" != "" ]] && PrintError "${message}"
  exit 1
}
function CheckDir()
{
  local dirPath="${1}"
  [[ ! -d "${dirPath}" ]] && AbortScript "Target directory \"${dirPath}\" does not exist"
}

mkdir -p "${targetDir}"
CheckDir "${extLibs}"
CheckDir "${targetDir}"

# * --== Gaudi ==--  *#
function FetchGaudi()
{
  local currentPath="$(pwd)"
  # * Choose version
}
FetchGaudi

# * --== CLHEP ==--  *#
function FetchCLHEP()
{
  local currentPath="$(pwd)"
  # * Choose version
  cd "${targetDir}"
  mkdir -p "${targetDir}/CLHEPversions"
  cd "${targetDir}/CLHEPversions"
  rm -rf *
  local defaultVersion="2.0.4.5"
  local versionsCLHEP=(
    "clhep/1.9.4.7/x86_64-slc6-gcc46-opt"
    "clhep/2.0.4.5/x86_64-slc6-gcc46-opt"
    "CLHEP/2.4.0.2/x86_64-slc6-gcc494-opt"
  )
  for v in ${versionsCLHEP[@]}; do
    echo > "$(echo "${v}" | cut -d / -f 2)"
  done
  read -e -p "Which version of CLHEP do you want to load? " -i $defaultVersion versionCLHEP
  cd "${targetDir}"
  rm -rf CLHEPversions
  # * Determine version location
  local versionPath=""
  for v in ${versionsCLHEP[@]}; do
    if [[ "$(echo "${v}" | cut -d / -f 2)" == "${versionCLHEP}" ]]; then
      versionPath="${v}"
      break
    fi
  done
  [[ "${versionPath}" == "" ]] && AbortScript "Version ${versionCLHEP} does not exist!"
  # * Determine version location
  mkdir -p "${targetDir}/CLHEP/"
  cd "${targetDir}/CLHEP/"
  rm -rf "include"
  echo "Copying \"${versionPath}\"..."
  cp -Rf "${extLibs}/external/${versionPath}/include" .
  cd "${currentPath}"
}
FetchCLHEP