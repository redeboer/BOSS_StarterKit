#!/bin/bash -
# echo "Loading \"${BASH_SOURCE[0]/$(dirname ${BOSS_StarterPack})\/}\""

# * ============================================================================= * #
# *   DESCRIPTION: Shell script that contains definitions of functions that are   * #
# *                used in the bash scripts this folder.                          * #
# *        AUTHOR: Remco de Boer (@IHEP), EMAIL: remco.de.boer@ihep.ac.cn         * #
# *  ORGANIZATION: IHEP, CAS (Beijing, CHINA)                                     * #
# *       CREATED: 12 May 2018                                                    * #
# *         USAGE: include in another bash script with this line:                 * #
# *                source FunctionsPrint.sh                                       * #
# * ============================================================================= * #


export gColorCodeBold="\e[1m"
export gColorCodeError="\e[91m"
export gColorCodeSuccess="\e[92m"
export gColorCodeInput="\e[93m"
export gColorCodeEnd="\e[0m"


function PrintError()
{
	echo -e "${gColorCodeError}ERROR: ${1}${gColorCodeEnd}"
}
export PrintError


function PrintSuccess()
{
	echo -e "${gColorCodeSuccess}${1}${gColorCodeEnd}"
}
export PrintSuccess


function AskForInput()
{
	echo -e "${gColorCodeInput}${1}${gColorCodeEnd}"
	echo -e "${gColorCodeInput}Press ENTER to continue or break with Ctrl+C or Ctrl+Z${gColorCodeEnd}"
	read -p ""
}
export AskForInput


function PrintBold()
{
	echo -e "${gColorCodeBold}${1}${gColorCodeEnd}"
}
export PrintBold


function PrintLine()
{
	num=${1:-30}
	char=${2:--}
	line=$(printf "%-${num}s" "")
	line="${line// /${char}}"
	echo "${line}"
}
export PrintLine


function PrintLineBold()
{
	num=${1:-30}
	char=${2:--}
	line=$(printf "%-${num}s" "")
	line="${line// /${char}}"
	PrintBold "${line}"
}
export PrintLineBold


function PrintHeader()
{
	echo
	echo
	PrintLineBold "${#1}"
	PrintBold     "${1}"
	PrintLineBold "${#1}"
	echo
}
export PrintHeader