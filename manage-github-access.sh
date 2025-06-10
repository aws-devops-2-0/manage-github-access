#!/bin/bash

# Usage function
usage(){
	echo "Usage:"
	echo " $0 <owner> <repo> [add <username> [permission]]"
	echo " $0 my-org my-repo"
	echo " $0 my-org my-repo add alice write"
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
	gh api repos/$OWNER/$REPO/collaborators | jq -r '(["Username","Type","Permission"], ["________","----","________"] ),(.[] | [.login, .type, .permissions | to_entries[] | select(.value == true) | .key])
	| @tsv' | \ 
        column -t
}

#Add collaborator 

add_collaborator() {
	USER="$1"
	PERM="${2:-push}" #Default to write/push permissions
	echo "Adding user '$USER' to $OWNER/$REPO with '$PERM' permission..."
	gh api repos/$OWNER/$REPO/collaborators/$USER --method PUT -f permission="$PERM"

#Main Logic

if [ "$3" = "add" ] && [ -n "$4" ]; then
	add_collaborator "$4" "$5"
elif [ "$#" -eq 2 ]; then 
	list_collaborators
else 
	usage
fi

