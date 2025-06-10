#!/bin/bash

########################################################################################
# Script Name: manage-github-access.sh
# Description:
#   This script allows you to list and add collaborators to a GitHub repository.
#
# Input Parameters:
#   1. <owner> - The GitHub org/user owning the repository.
#   2. <repo>       - The repository name.
#   3. [add]        - (Optional) If present, adds a collaborator.
#   4. [username]   - (Optional) The GitHub username to add.
#   5. [permission] - (Optional) Permission: pull (read), push (write, default), admin.
#
# Script Owner: dynamically fetch
#########################################################################################

#Script owner (Github login if authenticated, else system user)
SCRIPT_OWNER="$(gh api user --jq .login 2>/dev/null || echo $USER)"


# Usage function
usage(){
        echo
        echo "GitHub Repo Collaborator Manager"
        echo "--------------------------------"
        echo "This script lists or adds collaborators to a GitHub repository."
        echo
        echo "Usage:"
        echo " $0 <owner> <repo>"
        echo "    - List current collaborators for repository"
        echo " $0  <owner> <repo> add <username> [permission]"
        echo "    - Add a collaborator with optional permission (default:push)"
        echo "        Permissions: pull (read), push (write), admin (full access)."
        echo
        echo "Examples:"
        echo " $0 my-org my-repo"
        echo " $0 my-org my-repo add alice write"
        echo "Script Owner: $SCRIPT_OWNER"
        exit 1
}

# Check arguments
if [ "$#" -lt 2 ]; then 
	usage
fi

OWNER="$1"
REPO="$2"

# List collaborators
list_collaborators() {
    echo "Collaborators for $OWNER/$REPO:"
    gh api repos/$OWNER/$REPO/collaborators | jq -r \
    '(["Username","Type","Permissions"], ["--------","----","-----------"]),
      (.[] | [.login, .type, ( .permissions | to_entries | map(select(.value == true) | .key) | join(",") )]) | @tsv' \
    | column -t
}

#Add collaborator 
add_collaborator() {
	USER="$1"
	PERM="${2:-push}" #Default to write/push permissions
	echo "Adding user '$USER' to $OWNER/$REPO with '$PERM' permission..."
	gh api repos/$OWNER/$REPO/collaborators/$USER --method PUT -f permission="$PERM"
}

#Main Logic
if [ "$3" = "add" ] && [ -n "$4" ]; then
	add_collaborator "$4" "$5"
elif [ "$#" -eq 2 ]; then 
	list_collaborators
else 
	usage
fi

