# Author: Remco de Boer
# Date: November 5th, 2018
# Originates from
# https://github.com/redeboer/NIKHEFProject2018/blob/c06f81038e8d720c36a2e4337caa663a694731a7/docs/Install%20CERN%20ROOT6.sh

# Instructions to install the latest CERN ROOT Production ("Pro") distribution, including Minuit, on Ubuntu. The Pro version is 6.18/00 (2019-06-25) at the time of writing, but the procedure should work as well when later distributions come out.

# You can use these instructions as well as a bash script. Run using:
# sudo bash InstallCernRoot.sh

# To see which options are used by default, see: https://root.cern.ch/building-root

# * Script parameters * #
buildDir=".build"
function AttemptToRun()
{
  $@
  if [[ $? != 0 ]]; then
    echo -e "\e[31;1mERROR: Failed to run"
    echo -e "  $@"
    echo -e "--> ABORTED\e[0m"
    exit 1
  fi
}

# Check if in sudo
sudo true
# if [ "$EUID" -ne 0 ]; then
#   echo "Please run as root. To do so, use:"
#   echo "  sudo bash ${BASH_SOURCE[0]}"
#   exit 1
# fi

# Decide which version to install and where to download
echo "This script will install CERN ROOT 6. Check out the latest versions at https://root.cern.ch/downloading-root."
echo
echo "Which version do you want to install?"
read -e -p "  v6-" -i "18-00" ROOTVERSION
echo "--> Installing version: v6-$ROOTVERSION"
echo
echo -e "Where do you want to \e[1mdownload\e[0m the source code? "
read -e -p "" -i "$(pwd)/root" sourceDir
sourceDir="${sourceDir/\~/$HOME}"
if [[ "$(basename "${sourceDir}")" != "root" ]]; then
  sourceDir="${sourceDir}/root"
fi
echo
echo -e "Where do you want to \e[1minstall\e[0m ROOT? "
read -e -p "" -i "/usr/local/root" installDir
echo

# Download ROOT
echo -e "\e[1mDownloading or updating source code...\e[0m"
if [[ -d "${sourceDir}" ]]; then
  if [[ $(ls ${sourceDir}/* | wc -l) == 0 ]]; then
    rmdir "${sourceDir}"
  else
    currentPath="$(pwd)"
    cd "${sourceDir}"
    if [[ "$(basename $(git rev-parse --show-toplevel))" != "root" ]]; then
      printf "\e[33m"
      printf "Folder \"${sourceDir}\" already exists, but is not the ROOT repository. Remove $(find ${sourceDir} -type f | wc -l) files and clone again?"
      read -p " (y/n) " -n 1 -r
      printf "\e[0m"
      if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "--> ABORTED"
        exit 1
      fi
      rm -rf "${sourceDir}"
    else
      if [[ -d "${sourceDir}/${buildDir}" ]]; then
        if [[ $(find ${sourceDir}/${buildDir} -type f | wc -l) != 0 ]]; then
          printf "\e[33mWARNING: \"${buildDir}\" directory already exists. Remove? (y/n) \e[0m"
          read -p "" -n 1 -r
          echo
          if [[ $REPLY =~ ^[Yy]$ ]]; then
            rm -rf "${sourceDir}/${buildDir}"
          fi
        fi
      fi
      mkdir -p "${sourceDir}/${buildDir}"
      AttemptToRun \
        git checkout master
      AttemptToRun \
        git reset --hard
      AttemptToRun \
        git pull origin master
    fi
    cd "${currentPath}"
  fi
else
  chown -R $(whoami):$(id -g -n $(whoami)) "${sourceDir}"
  AttemptToRun \
    git clone http://github.com/root-project/root.git "${sourceDir}"
fi
echo

# Install prerequisites (https://root.cern.ch/build-prerequisites)
echo -e "\e[1mInstalling essential prerequisites...\e[0m"
sudo apt install git dpkg-dev cmake g++ gcc binutils libx11-dev libxpm-dev libxft-dev libxext-dev
if [[ $? != 0 ]]; then
  echo "\e[31mERROR: Failed to install essential prerequisites, see:"
  echo "  https://root.cern.ch/build-prerequisites\e[0m"
  exit 1
fi
echo

# Optional packages
echo -e "\e[1mInstalling optional prerequisites...\e[0m"
sudo apt install gfortran libssl-dev libpcre3-dev xlibmesa-glu-dev libglew1.5-dev libftgl-dev libmysqlclient-dev libfftw3-dev libcfitsio-dev graphviz-dev libavahi-compat-libdnssd-dev libldap2-dev python-dev libxml2-dev libkrb5-dev libgsl0-dev libqt4-dev
if [[ $? != 0 ]]; then
  printf "\e[33m"
  printf "WARNING: Failed to download optional prerequisites. Continue?"
  read -p " (y/n) " -n 1 -r
  printf "\e[0m"
  if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "--> ABORTED"
    exit 1
  fi
fi
echo

# Update packages
echo -e "\e[1mUpdating packages...\e[0m"
sudo apt update
echo

# Change ownership
cd "${sourceDir}"

# Set the correct release tag
echo -e "\e[1mChecking out chosen version tag...\e[0m"
git checkout master
git reset --hard
git fetch --all
git branch -D v6-$ROOTVERSION
git checkout -b v6-$ROOTVERSION v6-$ROOTVERSION
if [[ $? != 0 ]]; then
  echo -e "\e[91mERROR: Failed to git-checkout \"v6-$ROOTVERSION\". Use"
  echo -e "  cd ${sourceDir}; git tag"
  echo -e "to see which tags are available\e[0m"
  exit 1
fi
echo

# Build source material and make install. Also possible: ccmake, which gives an overview of the options.
# See also https://root.cern.ch/building-root for more options.
echo -e "\e[1mPerforming CMAKE...\e[0m"
mkdir -p "${sourceDir}/${buildDir}"
cd "${sourceDir}/${buildDir}"
sudo mkdir -p "${installDir}"
sudo chown -R $(whoami):$(id -g -n $(whoami)) "${installDir}"
cmake \
  -Dminuit2=ON \
  -Dminuit=ON \
  -Droofit=ON \
  -Dx11=ON \
  -DCMAKE_INSTALL_PREFIX:PATH=${installDir} \
  ..
echo

echo -e "\e[1mPerforming make...\e[0m"
AttemptToRun \
  make -j$(nproc)
echo

echo -e "\e[1mPerforming make install...\e[0m"
AttemptToRun \
  make install
echo

# Remove build files
cd "${installDir}"
# rm -rf "${installDir}/${buildDir}"

# Install ROOT: tell Ubuntu how to run ROOT
AttemptToRun \
  . bin/thisroot.sh
AttemptToRun \
  source bin/thisroot.sh

# Information about adding ROOT to your bash. BE CAREFUL IF YOU COPY FROM THIS FILE: replace \$ by $
read -p "
Installation of ROOT completed! Upon pressing ENTER, the path variables for ROOT will be set in your .bashrc file. Nano will be opened so you can check the result."
echo "
# CERN ROOT
export ROOTSYS=${installDir}
export PATH=\$ROOTSYS/bin:\$PATH
export PYTHONDIR=\$ROOTSYS
export LD_LIBRARY_PATH=\$ROOTSYS/lib:\$PYTHONDIR/lib:\$ROOTSYS/bindings/pyroot:\$LD_LIBRARY_PATH
export PYTHONPATH=\$ROOTSYS/lib:\$PYTHONPATH:\$ROOTSYS/bindings/pyroot" >> ~/.bashrc
nano ~/.bashrc
