currentPath1="$(pwd)"
scriptPath="$(dirname "${BASH_SOURCE[0]}")"
cd "${scriptPath}"

repoName=$(basename $(git config --get remote.origin.url))
repoName=${repoName/.git/}
export ${repoName}="$(pwd)"
alias reloadstarterkit="source ${scriptPath}/setup.sh"

source "setup/FunctionsPrint.sh"
source "setup/FunctionsRoot.sh"
source "setup/Functions.sh"
[[ -d "/cvmfs/bes3.ihep.ac.cn/bes3sw" ]] && source "setup/LoadBoss.sh"
source "setup/LoadStarterKit.sh"
source "setup/Aliases.sh"

cd "${currentPath1}"
