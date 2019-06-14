#!/bin/bash -
# echo "Loading \"${BASH_SOURCE[0]/$(dirname ${BOSS_StarterKit})\/}\""

# * ========================= * #
# * ------- FUNCTIONS ------- * #
# * ========================= * #

	function cdstarterkit()
	{
		local subfolder="${1:-}"
		cd "${BOSS_StarterKit}/${subfolder}"
	}
	export cdstarterpack
	function cdbesfs()
	{
		local subfolder="${1:-}"
		cd "${BESFS}/${subfolder}"
	}
	export cdbesfs
	function cdihepbatch()
	{
		local subfolder="${1:-}"
		cd "${IHEPBATCH}/${subfolder}"
	}
	export cdihepbatch
	function cdscratchfs()
	{
		local subfolder="${1:-}"
		cd "${SCRATCHFS}/${subfolder}"
	}
	export cdscratchfs
	function cdworkarea()
	{
		local subfolder="${1:-}"
		cd "${BOSSINSTALL}/workarea/${subfolder}"
	}
	export cdworkarea



# * ======================= * #
# * ------- ALIASES ------- * #
# * ======================= * #

	alias cdroot="cd ${IHEPROOT}"

	alias myjobs="hep_q -u ${USER}"
	alias alljobs="hep_q | less"

	alias cdjobs="cdstarterkit jobs"