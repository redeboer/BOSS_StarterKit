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


function PrintError()
{
	echo -e "\e[31;1mERROR: ${1}\e[0m"
}
export PrintError


function PrintWarning()
{
	echo -e "\e[33;1mWARNING\e[0m\e[33m: ${1}\e[0m"
}
export PrintWarning


function PrintSuccess()
{
	echo -e "\e[32m${1}\e[0m"
}
export PrintSuccess


function AskForInput()
{
	printf "\e[33m"
	read -p "${1} (y/n) " -n 1 -r
	echo -e "\e[0m"
	input=$REPLY
	if [[ ! $REPLY =~ ^[Yy]$ ]]; then
		return 1
	fi
}
export AskForInput


function PrintBold()
{
	echo -e "\e[1m${1}\e[0m"
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