# Author: Remco de Boer
# Date: November 5th, 2018
# Originates from
# https://github.com/redeboer/NIKHEFProject2018/blob/c06f81038e8d720c36a2e4337caa663a694731a7/docs/Install%20CERN%20ROOT6.sh

# Instructions to install the latest CERN ROOT Production ("Pro") distribution, including Minuit, on Ubuntu. The Pro version is 6.18/04 (2019-06-25) at the time of writing, but the procedure should work as well when later distributions come out.

# You can use these instructions as well as a bash script. Run using:
# sudo bash InstallCernRoot.sh

# To see which options are used by default, see: https://root.cern.ch/building-root

# Check if in sudo
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root. To do so, use:"
  echo "  sudo bash ${BASH_SOURCE[0]}"
  exit 1
fi

# Decide which version to install
echo "This script will install CERN ROOT 6, version 6.18/04. Check out the latest versions at https://root.cern.ch/downloading-root."
echo
echo "If you want this version, press enter, otherwise, enter the version here:"
read -e -p "  v6-" -i "18-04" ROOTVERSION
if [ -n $ROOTVERSION ]; then
  echo "--> Installing default version: v6-$ROOTVERSION"
else
  echo "--> Installing your chosen version: v6-$ROOTVERSION"
fi
echo

echo "Where do you want to download the source code? "
read -e -p "" -i "$(pwd)/root" sourceDir

# Install prerequisites (https://root.cern.ch/build-prerequisites)
apt-get install git dpkg-dev cmake g++ gcc binutils libx11-dev libxpm-dev libxft-dev libxext-dev
# Optional packages
apt-get install gfortran libssl-dev libpcre3-dev xlibmesa-glu-dev libglew1.5-dev libftgl-dev libmysqlclient-dev libfftw3-dev libcfitsio-dev graphviz-dev libavahi-compat-libdnssd-dev libldap2-dev python-dev libxml2-dev libkrb5-dev libgsl0-dev libqt4-dev

# Clone entire ROOT source from the public Git repository
cd /usr/local/
git clone http://github.com/root-project/root.git "${sourceDir}"
if [ $? != 0 ]; then
  echo -e "\e[91mERROR: Failed to git-clone \"http://github.com/root-project/root.git\"\e[0m"
  exit 1
fi
chown -R $(whoami):$(id -g -n $(whoami)) root
if [ $? != 0 ]; then
  echo -e "\e[91mERROR: Failed to change ownership\e[0m"
  exit 1
fi
cd root

# Set the correct release tag
git checkout -b v6-$ROOTVERSION v6-$ROOTVERSION
if [ $? != 0 ]; then
  echo -e "\e[91mERROR: Failed to git-checkout \"v6-$ROOTVERSION\"\e[0m"
  exit 1
fi

# Make a directory in the source folder that will be used for compilation files
mkdir compile
cd compile

# Build source material and make install. Also possible: ccmake, which gives an overview of the options
cmake -Dminuit=ON -Dminuit2=ON -DCMAKE_INSTALL_PREFIX:PATH=/usr/local/root ..
make -j$(nproc)
make install

# Remove build files
cd ..
rm -rf compile

# Install ROOT: tell Ubuntu how to run ROOT
cd /usr/local/root
. bin/thisroot.sh
source bin/thisroot.sh

# Information about adding ROOT to your bash. BE CAREFUL IF YOU COPY FROM THIS FILE: replace \$ by $
read -p "
Installation of ROOT completed! Upon pressing ENTER, the path variables for ROOT will be set in your .bashrc file. Gedit will be opened so you can check the result."
echo "
# CERN ROOT
export ROOTSYS=/usr/local/root
export PATH=\$ROOTSYS/bin:\$PATH
export PYTHONDIR=\$ROOTSYS
export LD_LIBRARY_PATH=\$ROOTSYS/lib:\$PYTHONDIR/lib:\$ROOTSYS/bindings/pyroot:\$LD_LIBRARY_PATH
export PYTHONPATH=\$ROOTSYS/lib:\$PYTHONPATH:\$ROOTSYS/bindings/pyroot" >> ~/.bashrc
gedit ~/.bashrc