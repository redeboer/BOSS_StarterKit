source "${BOSS_StarterKit}/setup/FunctionsPrint.sh"


# * ============================ *#
# * --== General parameters ==-- *#
# * ============================ *#
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


# * =============== *#
# * --== Gaudi ==-- *#
# * =============== *#
function FetchGaudi()
{
  local currentPath="$(pwd)"
  # * Choose version
  cd "${extLibs}/gaudi"
  local versionsGaudi=$(find -maxdepth 4 -type d -iwholename "*/InstallArea/x86_64-slc6-gcc46-opt/include")
  cd "${targetDir}"
  mkdir -p "${targetDir}/versionsGaudi"
  cd "${targetDir}/versionsGaudi"
  rm -rf *
  local defaultVersion="GAUDI_v23r9"
  for v in ${versionsGaudi[@]}; do
    echo > "$(echo "${v}" | cut -d / -f 2)"
  done
  read -e -p "Which version of Gaudi do you want to load? " -i $defaultVersion versionGaudi
  cd "${targetDir}"
  rm -rf versionsGaudi
  # * Determine version location
  local versionPath=""
  for v in ${versionsGaudi[@]}; do
    if [[ "$(echo "${v}" | cut -d / -f 2)" == "${versionGaudi}" ]]; then
      versionPath="${v}"
      break
    fi
  done
  [[ "${versionPath}" == "" ]] && AbortScript "Version ${versionGaudi} does not exist!"
  # * Copy headers
  mkdir -p "${targetDir}/Gaudi/"
  cd "${targetDir}/Gaudi/"
  rm -rf *
  echo "Copying \"${versionPath}\"..."
  cp -Rf "${extLibs}/gaudi/${versionPath}/"* .
  cd "${currentPath}"
}
FetchGaudi


# * =============== *#
# * --== CLHEP ==-- *#
# * =============== *#
function FetchCLHEP()
{
  local currentPath="$(pwd)"
  # * Choose version
  cd "${targetDir}"
  mkdir -p "${targetDir}/versionsCLHEP"
  cd "${targetDir}/versionsCLHEP"
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
  rm -rf versionsCLHEP
  # * Determine version location
  local versionPath=""
  for v in ${versionsCLHEP[@]}; do
    if [[ "$(echo "${v}" | cut -d / -f 2)" == "${versionCLHEP}" ]]; then
      versionPath="${v}"
      break
    fi
  done
  [[ "${versionPath}" == "" ]] && AbortScript "Version ${versionCLHEP} does not exist!"
  # * Copy headers
  mkdir -p "${targetDir}/CLHEP/"
  cd "${targetDir}/CLHEP/"
  rm -rf CLHEP
  echo "Copying \"${versionPath}\"..."
  cp -Rf "${extLibs}/external/${versionPath}/include/CLHEP" .
  cd "${currentPath}"
}
FetchCLHEP