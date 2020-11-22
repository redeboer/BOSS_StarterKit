echo "This script helps you 'install' BOSS."
echo "See https://besiii.gitbook.io/boss/tutorials/getting-started/setup for more information."

read -p "  - Which version of BOSS do you want to install? (default is 7.0.4) " BOSSVERSION
export BOSSVERSION=${BOSSVERSION:-7.0.4}

BOSSINSTALLdefault="/besfs/users/${USER}/boss-${BOSSVERSION}"
read -e -p "  - What do you want to be your workarea? (default \"$BOSSINSTALLdefault\") " BOSSINSTALL
export BOSSINSTALL=${BOSSINSTALL:-$BOSSINSTALLdefault}

CMTHOME="/afs/ihep.ac.cn/bes3/offline/Boss/cmthome/cmthome-${BOSSVERSION}"
CMTHOMENAME="cmthome"
WORKAREANAME="workarea"

# * Check paramteres * #
if [ ! -d "${CMTHOME}" ]; then
  echo "ERROR: Folder \"${CMTHOME}\" (\$CMTHOME) does not exist. Check chosen BOSS version ($BOSSVERSION)..."
  exit 1
fi
mkdir -p "${BOSSINSTALL}"
if [[ $(ls -A "${BOSSINSTALL}" | wc -l) != 0 ]]; then
  printf "  - Folder \"${BOSSINSTALL}\" (\$BOSSINSTALL) already contains files. \e[91;1mREMOVE THEM?\e[0m "
  read -p "(y/n) " -n 1 -r
  echo
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    rm -r "${BOSSINSTALL}"/*
  fi
fi

# * Copy and install BOSS CMT files
cmtPath="${BOSSINSTALL}/${CMTHOMENAME}"
if [[ -d "${cmtPath}" ]]; then
  printf "  - CMT home folder \""${cmtPath}"\" contains $(find ${cmtPath} -type f | wc -l) files. \e[91;1mREMOVE THEM?\e[0m"
  read -p " (y/n) " -n 1 -r
  echo
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    rm -rf "${cmtPath}"
  fi
fi
mkdir -p "${cmtPath}"
cd "${cmtPath}"
cp -Rf "${CMTHOME}/"* .

# * Replace lines in `requirements`
awk '{flag = 1}
		{sub(/#macro WorkArea "\/ihepbatch\/bes\/maqm\/workarea"/,"macro WorkArea \"'${BOSSINSTALL}'/workarea\"")}
		{sub(/#path_remove CMTPATH  "\$\{WorkArea\}"/,"path_remove  CMTPATH \"${WorkArea}\"")}
		{sub(/#path_prepend CMTPATH "\$\{WorkArea\}"/,"path_prepend CMTPATH \"${WorkArea}\"")}
		{if(flag == 1) {print $0} else {next} }' \
  "${cmtPath}/requirements" >"${cmtPath}/requirements_new"
mv "${cmtPath}/requirements_new" "${cmtPath}/requirements"

# * Setup BOSS environment
source setupCMT.sh # starts connection to the CMT
cmt config         # initiates configuration
source setup.sh    # sets path variables

# * Copy and install TestRelase
waPath="${BOSSINSTALL}/${WORKAREANAME}"
if [[ -d "${waPath}" ]]; then
  printf "  - Workarea home folder \""${waPath}"\" contains $(find ${waPath} -type f | wc -l) files. \e[91;1mREMOVE THEM?\e[0m" -n 1 -r
  read -p " (y/n) " -n 1 -r
  echo
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    rm -r "${waPath}"/*
  fi
fi
mkdir -p "${waPath}"
cd "${waPath}"
cp -Rf "${BesArea}/TestRelease" .
cd TestRelease/TestRelease-*/cmt
cmt broadcast      # load all packages to which TestRelease refers
cmt config         # perform setup and cleanup scripts
cmt broadcast make # build executables
source setup.sh    # set bash variables

# * Add the above source commands to .bash_profile
OUTPUTFILE=~/.bash_profile
OUTPUTSTRING="\n"
OUTPUTSTRING+="  export BOSSINSTALL=${BOSSINSTALL}\n"
OUTPUTSTRING+="  source \$BOSSINSTALL/cmthome/setupCMT.sh\n"
OUTPUTSTRING+="  source \$BOSSINSTALL/cmthome/setup.sh\n"
OUTPUTSTRING+="  source \$BOSSINSTALL/workarea/TestRelease/TestRelease-*/cmt/setup.sh\n"
OUTPUTSTRING+="  export PATH=\$PATH:/afs/ihep.ac.cn/soft/common/sysgroup/hep_job/bin\n"
if [[ -f "${OUTPUTFILE}" ]]; then
  echo -e "Bash profile file \"${OUTPUTFILE}\" already exists. Append the following source lines?"
  echo -e "${OUTPUTSTRING}"
  read -p "Type y or n: " -n 1 -r
  echo
  if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    exit 0
  fi
fi
echo >>"${OUTPUTFILE}"
echo -e "${OUTPUTSTRING}" >>"${OUTPUTFILE}"
