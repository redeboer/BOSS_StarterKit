#!/bin/bash -
# echo "Loading \"${BASH_SOURCE[0]/$(dirname ${BOSS_StarterKit})\/}\""

# * ============================================================================= * #
# *   DESCRIPTION: Shell script that contains definitions of functions that are   * #
# *                used in the bash scripts this folder.                          * #
# *        AUTHOR: Remco de Boer (@IHEP), EMAIL: remco.de.boer@ihep.ac.cn         * #
# *  ORGANIZATION: IHEP, CAS (Beijing, CHINA)                                     * #
# *       CREATED: 8 November 2018                                                * #
# *         USAGE: include in another bash script with this line:                 * #
# *                source Functions.sh                                            * #
# * ============================================================================= * #

source "${BOSS_StarterKit}/setup/FunctionsPrint.sh"

# * ================================== * #
# * ------- SCRIPT INITIALISER ------- * #
# * ================================== * #


	# * Set identifier parameters for this script * #
		# * Get absolute path to script
		if [[ "${BASH_SOURCE[0]}" == /* ]]; then # if absolute already
			PathToFunctionsScript="${BASH_SOURCE[0]}"
		else # if relative path
			cd "$(dirname "${BASH_SOURCE[0]}")" > /dev/null
			PathToFunctionsScript="$(pwd)/${BASH_SOURCE[0]}"
			cd - > /dev/null
		fi
		export PathToFunctionsScript



# * =================== * #
# * ------- GIT ------- * #
# * =================== * #


	function gitsync()
	{
		# * Go to BOSS Afterburner main dir
		local mainDir="${BOSS_StarterKit}"
		cd ${mainDir}
		if [ $? != 0 ]; then
			PrintError "Folder \"${mainDir}\" does not exist\" [${FUNCNAME[0]}]"
			cd - > /dev/null
			return 1
		fi
		# * Add all (!) files (can only be done from main folder)
		git add --all .
		if [ $? != 0 ]; then
			PrintError "Failed to \"add -all .\""
			cd - > /dev/null
			return 1
		fi
		# * Commit with a default description (randomiser to make unique)
		git commit -m "updated ($RANDOM)"
		if [ $? != 0 ]; then
			PrintError "Failed to \"git commit -m ()\""
			cd - > /dev/null
			return 1
		else
			PrintSuccess "Successfully added and commited changes"
		fi
		# * Pull possible new changes and rebase
		git pull --rebase
		if [ $? != 0 ]; then
			PrintError "Failed to \"git pull --rebase\""
			cd - > /dev/null
			return 1
		else
			PrintSuccess "Successfully pulled from GitHub"
		fi
		# * Push to Git #
		git push
		if [ $? == 0 ]; then
			PrintSuccess "Successfully pushed changes to to GitHub!"
		fi
		cd - > /dev/null
	}
	export gitsync


	function gitsubmodules()
	{
		local listOfSubmodules=$(find */ -type f -iname ".git")
		local listOfSubrepos=$(find */ -type d -iname ".git")
		if [[ ${#listOfSubmodules} -gt 1 ]]; then
			echo -e "This directory contains \e[1m$(echo ${listOfSubmodules} | wc -w) submodules\e[0m:"
			for i in ${listOfSubmodules[*]}; do
				echo " - $(basename $(dirname ${i}))"
			done
		fi
		if [[ ${#listOfSubrepos} -gt 1 ]]; then
			echo -e "This directory contains \e[1m$(echo ${listOfSubrepos} | wc -w) subrepositories\e[0m:"
			for i in ${listOfSubrepos[*]}; do
				echo " - $(basename $(dirname ${i}))"
			done
		fi
	}
	export gitsubmodules


	function gitpullall()
	{
		git pull && git submodule foreach "git pull"
	}
	export gitpullall


	function gitignorecmt()
	{
		git update-index --assume-unchanged cmt/*.*sh
	}
	export gitignorecmt



# * ============================= * #
# * ------- CMT FUNCTIONS ------- * #
# * ============================= * #


	function AttemptToExecute()
	{
		local currentPath="$(pwd)"
		local commandToExecute="${1}"
		PrintBold "\n--== EXECUTING \"${commandToExecute}\" ==--\n"
		${commandToExecute}
		if [ $? != 0 ]; then
			PrintError "Failed to execute \"${commandToExecute}\""
			cd "${currentPath}"
			return 1
		fi
		cd "${currentPath}"
	}
	export AttemptToExecute


	function cdcmt()
	{
		local currentPath="$(pwd)"
		if [ "$(basename "${currentPath}")" != "cmt" ]; then
			local cmtFolder="$(find -name cmt | head -1)"
			if [ "${cmtFolder}" == "" ]; then
				PrintError "No cmt folder available!"
				return 1
			fi
			cd "${cmtFolder}"
		fi
	}
	export cdcmt


	function cmtbroadcast()
	{
		local currentPath="$(pwd)"
		cdcmt && \
		PrintHeader "BROADCASTING PACKAGE \"$(basename $(dirname $(pwd)))\"" && \
		AttemptToExecute "cmt broadcast" && \
		AttemptToExecute "cmt config" && \
		AttemptToExecute "cmt broadcast make" && \
		AttemptToExecute "source setup.sh"
		if [[ $? != 0 ]]; then
			cd "${currentPath}"
			return 1
		fi
		cd "${currentPath}"
	}
	export cmtbroadcast


	function cmtconfig()
	{
		local currentPath="$(pwd)"
		cdcmt && \
		PrintHeader "BUILDING PACKAGE \"$(basename $(dirname $(pwd)))\"" && \
		AttemptToExecute "cmt config" && \
		AttemptToExecute "make" && \
		AttemptToExecute "source setup.sh"
		if [[ $? != 0 ]]; then
			cd "${currentPath}"
			return 1
		fi
		cd ..
		gitignorecmt
		cd "${currentPath}"
	}
	export cmtconfig


	function cmtmake()
	{
		local currentPath="$(pwd)"
		cdcmt && \
		PrintHeader "BUILDING PACKAGE \"$(basename $(dirname $(pwd)))\"" && \
		AttemptToExecute "make"
		if [[ $? != 0 ]]; then
			cd "${currentPath}"
			return 1
		fi
		cd "${currentPath}"
	}
	export cmtmake



# * ================================ * #
# * ------- BOSS STARTER KIT ------- * #
# * ================================ * #


	function ImportBossPackage()
	{
		if [[ -z "${BesArea}" ]]; then
			PrintError "Shell variable \$BesArea has not been defined"
			return 1
		fi
		if [[ -z "${BOSSINSTALL}" ]] || [[ ! -d "${BOSSINSTALL}" ]]; then
			PrintError "Shell variable \$BOSSINSTALL has not been defined"
			return 1
		fi
		local currentPath="$(pwd)"
		cd "${BesArea}"
		local packageName=""
		printf "Which package do you want to load from the \$BesArea? "
		read -e packageName
		if [[ "${packageName}" == "." ]] || [[ -z "${packageName}" ]] || [[ ! -d "${packageName}" ]]; then
			PrintError "Package \"${packageName}\" does not exist in \$BesArea"
			cd "${currentPath}"
			return 1
		fi
		if [[ -d "${BOSSINSTALL}/workarea/${packageName}" ]]; then
			PrintWarning "Package \"${packageName}\" already exists in your workarea"
			AskForInput "REMOVE and OVERWRITE?"
			if [[ $? != 0 ]]; then
				echo "--> Import aborted"
				cd "${currentPath}"
				return 1
			fi
			rm -rf "${BOSSINSTALL}/workarea/${packageName}"
		fi
		mkdir -p "${BOSSINSTALL}/workarea/${packageName}"
		cp -R "${BesArea}/${packageName}/"* "${BOSSINSTALL}/workarea/${packageName}"
		reloadstarterkit
		echo "Package installed under:"
		echo "  ${BOSSINSTALL}/workarea/${packageName}"
		echo "Consider adding path:"
		echo "  workarea/${packageName}"
		echo "to .gitignore"
		cd "${currentPath}"
	}
	export ImportBossPackage


	function SetOutputFolder()
	{
		local outputPath="${1:-./output}"
		local currentPath="$(pwd)"
		cd "${BOSS_StarterKit}"
		local currentTarget="$(readlink "output")"
		if [[ "${currentTarget}" == "" ]]; then
			currentTarget=output
		fi
		if [[ "${outputPath}" == "${currentTarget}" ]]; then
			PrintSuccess "Path \"${outputPath}\" is already the output path"
			return 0
		fi
		AskForInput "Move all output from \"${currentTarget}\" to \"${outputPath}\"?"
		if [[ $? != 0 ]]; then
			cd "${currentPath}"
			return 1
		fi
		mkdir -p "${outputPath}"
		mv "${currentTarget}/"* "${outputPath}/" > /dev/null
		rmdir "${currentTarget}"
		{ rm -f output; } &> /dev/null
		{ rmdir output; } &> /dev/null
		ln -s "${outputPath}" output
		PrintSuccess "Moved all output from"
		PrintSuccess "  \"${currentTarget}\""
		PrintSuccess "to"
		PrintSuccess "  \"${outputPath}\""
		PrintSuccess "and set symbolic link:"
		PrintSuccess "  \"output\" --> \"${outputPath}\""
	}
	export SetOutputFolder



# * ==================================== * #
# * ------- NAVIGATION FUNCTIONS ------- * #
# * ==================================== * #


	function CheckDirectory()
	{
		local path="${1}"
		if [ ! -d "${path}" ]; then
			PrintError "Folder \"${path}\" does not exist [${FUNCNAME[0]}]"
			return 1
		fi
	}
	export CheckDirectory


	function CreateBaseDir()
	# Creates a base directory for a file to which you want to write.
	{
		mkdir -p "$(dirname "${1}")"
	}
	export CreateBaseDir


	function CdToBaseDir()
	# Creates a base directory for a file to which you want to write.
	{
		gStoredDirectory="$(pwd)"
		cd "$(dirname "${1}")"
	}
	export CdToBaseDir


	function CreateOrEmptyDirectory()
	# Create a directory if necessary. If it already exists, remove the already existing files (with a certain pattern).
	{
		# * Import function arguments
		local directory="${1}"
		# * Main function: empty or mkdir
		if [ -d "${directory}" ]; then
			numFiles=$(find ${directory} -type f | wc -l)
			if [ $numFiles != 0 ]; then
				AskForInput "Remove ${numFiles} files in \"${directory}\"?"
				[[ $? != 0 ]] && return 1
			fi
			rm -rf "${directory}"/*
		else
			mkdir -p "${directory}"
		fi
	}
	export CreateOrEmptyDirectory


	function SearchFileContent()
	{
		local search=${1}
		local folder=${2:-.}
		local ext="${3:-*}"
		for file in $(find ${folder} -type f -iname "*.${ext}"); do
			for line in $(cat ${file}); do
				if [[ "${line}" =~ "${search}" ]]; then
					echo "${file}"
					break
				fi
			done
		done
	}
	export SearchFileContent


	function FindAndReplaceFileContent()
	{
		local search=${1}
		local replace=${2}
		local folder=${3:-.}
		local ext="${4:-*}"
		local nhits=$(SearchFileContent ${search} ${folder} ${ext} | wc -l)
		if [[ $nhits == 0 ]]; then
			PrintSuccess "No occurrences of \"${search}\" in files with extention \"${ext}\" folder \"${folder}\""
			return 0
		fi
		AskForInput "Replace all occurrences of \"${search}\" by \"${replace}\" in ${nhits} files?"
		[[ $? != 0 ]] && return 1
		for file in $(find ${folder} -type f -iname "*.${ext}"); do
			sed -i 's/'${search}'/'${replace}'/g' "${file}"
		done
	}
	export FindAndReplaceFileContent


# * ======================================= * #
# * ------- SCRIPT ACCESS FUNCTIONS ------- * #
# * ======================================= * #


	function ResourceCommonFunctions()
	# The parameter `gFunctionsScriptIsSourced` is set to `true` if this script is sourced. Use this function if you really want to bypass this safety measure and source again.
	{
		gFunctionsScriptIsSourced=false
		source "${PathToFunctionsScript}"
	}
	export ResourceCommonFunctions



# * =============================== * #
# * ------- CHECK FUNCTIONS ------- * #
# * =============================== * #


	function AffirmMkdir()
	# Check if the path to a folder exists. Exit the script if it doesn't.
	{
		local folderToMake="${1}"
		if [ ! -d "${folderToMake}" ]; then
			AskForInput "Create folder the following folder?\n\"${folderToMake}\""
			[[ $? != 0 ]] && return 1
			mkdir -p "${folderToMake}"
		fi
	}
	export AffirmMkdir


	function CheckIfFolderExists()
	{
		local folderToCheck="${1}"
		if [ ! -d "${folderToCheck}" ]; then
			PrintError "Folder \"${folderToCheck}\" does not exist [${FUNCNAME[0]}]"
			return 1
		fi
	}
	export CheckIfFolderExists


	function CheckIfBaseDirExists()
	{
		CheckIfFolderExists "$(dirname "${1}")"
		[[ $? != 0 ]] && return 1
	}
	export CheckIfBaseDirExists


	function CheckIfFileExists()
	{
		local fileToCheck="${1}"
		if [ ! -s "${fileToCheck}" ]; then
			PrintError "File \"${fileToCheck}\" does not exist"
			return 1
		fi
	}
	export CheckIfFileExists



# * ====================================== * #
# * ------- TEXT FILE MODIFICATION ------- * #
# * ====================================== * #


	function ChangeLineEndingsFromWindowsToUnix()
	# Windows sometimes stores files with a different type of line endings. To make the file compatible again with Unix/Linux, use this function.
	{
		# * Import function arguments
		local fileName=${1}
		# * Main function: remove Windows style newline characters
		sed -i 's/\r$//' "${fileName}"
	}
	export ChangeLineEndingsFromWindowsToUnix



# * =========================== * #
# * ------- UNIT TESTER ------- * #
# * =========================== * #


	function IniTest()
	{
		TestName="${1}"
		StarterPackObjects="${BOSS_StarterKit}/workarea/Analysis/StarterPack/StarterPack-00-00-00"

		if [[ ${#} != 1 ]]; then
			PrintError "IniTest function needs 1 argument"
			return 1
		fi

		jobFile="UnitTests/jobs/job_${TestName}.txt"
		if [[ ! -f "${StarterPackObjects}/${jobFile}" ]]; then
			PrintError "File \"${jobFile}\" does not exist"
			return 1
		fi

		clear && \
		cd "${StarterPackObjects}" && \
		cd cmt && \
		make && \
		cd "${StarterPackObjects}" && \
		boss.exe "UnitTests/jobs/job_${TestName}.txt"
	}
	export IniTest

	function IniUnitTester()
	{
		clear
		IniTest UnitTester > /dev/null
	}
	export IniUnitTester




# * ======================== * #
# * ------- EXTERNAL ------- * #
# * ======================== * #


	function RunClang()
	{
		local pathToFormat="${1:-.}"
		if [[ ! -d "${pathToFormat}" ]]; then
			PrintError "Path \"${pathToFormat}\" does not exist"
			return 1
		fi
		local clangfile="${BOSS_StarterKit}/.clang-format"
		if [[ ! -f "${clangfile}" ]]; then
			PrintError "Clang file \"${clangfile}\" does not exist"
			return 1
		fi
		local ExtensionsToFormat=( C cpp cxx h hpp )
		echo "Will run clan format over extensions ${ExtensionsToFormat[@]}"
		for ext in ${ExtensionsToFormat[@]}; do
			nfiles=$(find ${pathToFormat} -type f -iname "*.${ext}" | wc -l)
			echo "  Running clang-format over $nfiles $ext files..."
			[[ $nfiles -gt 0 ]] && clang-format -style=file -assume-filename="${clangfile}" -i $(find ${pathToFormat} -type f -iname "*.${ext}")
		done
	}
	export RunClang


	function GenerateDoxygen()
	{
		# * SCRIPT PARAMETERS * #
			doxygenDir="doxygen"
			doxygenFile="doxygen.in"
			doxygenPath="${doxygenDir}/${doxygenFile}"
			htmlDir="docs"
			latexDir="latex"

		# * CHECK PARAMETERS * #
			if [ ! -d "${doxygenDir}" ]; then
				echo "\e[91mThis repository does not contain a Doxygen directory (\"${doxygenDir}\")\e[0m"
				return 1
			fi
			if [ ! -f "${doxygenPath}" ]; then
				echo "\e[91mThis repository does not contain a Doxygen file \"${doxygenPath}\"\e[0m"
				return 1
			fi

		# * PREPARE OUTPUT FOLDERS * #
			cd "${doxygenDir}"
			echo "Removed old Doxygen pages"
			rm -rf "../${htmlDir}"
			rm -rf "../${latexDir}"

		# * WRITE DOXYGEN PAGES * #
			echo "Writing Doxygen pages for repository $(basename $(pwd))"
			doxygen doxygen.in
			if [ $? == 0 ]; then
				echo -e "\e[92mSuccessfully created Doxygen documentation!\e[0m" # light green color code
			else
				echo -e "\e[91mFailed to create Doxygen documentation!\e[0m"     # light red color code
			fi

		cd - > /dev/null
	}
	export GenerateDoxygen