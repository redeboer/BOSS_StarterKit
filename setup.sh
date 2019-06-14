currentPath="$(pwd)"
cd "$( dirname "${BASH_SOURCE[0]}" )"

repoName=$(basename $(git config --get remote.origin.url) )
repoName=${repoName/.git}
export ${repoName}="$(pwd)"

source "setup/FunctionsPrint.sh"
source "setup/FunctionsRoot.sh"
source "setup/Functions.sh"
source "setup/LoadBoss.sh"
source "setup/LoadStarterKit.sh"
source "setup/Aliases.sh"

cd "${currentPath}"