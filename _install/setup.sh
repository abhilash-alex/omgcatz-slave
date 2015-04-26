#!/bin/bash

DIR="$(cd "$(dirname ${BASH_SOURCE[0]})" && pwd)"
INDENT="%-34s"
BAD=0

success() {
  echo " Success!"
}

failure() {
  echo " Failed!"
}

please() {
  echo " Nada, please install."
}

checkCommand() {
  printf "$INDENT" "Checking for $1..."
  if [ $(which $1) ]; then
    return 0
  else
    let BAD+=1
    return 1
  fi
}


# Make sure we are in the right directory.
cd "$DIR"

# Check for commands.
checkCommand "curl" && success || please
checkCommand "eyeD3" && success && ln -fs "$(which eyeD3)" ../eyeD3 || please
checkCommand "AtomicParsley" && success && ln -fs "$(which AtomicParsley)" ../AtomicParsley || please
checkCommand "convert" && success && ln -fs "$(which convert)" ../convert || please
checkCommand "zip" && success && ln -fs "$(which zip)" ../zip || please
checkCommand "find" && success && ln -fs "$(which find)" ../find || please
checkCommand "file" && success || please
checkCommand "php" && success || please

# If they need to install stuff let them know.
if [ $BAD -ne 0 ]; then
  printf "\nPlease install the missing commands ($BAD) and run this script again.\n"
  exit 1
fi

# Create folders.
printf "$INDENT" "Creating folders..."
mkdir -p ../{archives,artwork,songs} && success || failure

# Update folder permissions.
printf "$INDENT" "Changing folder permissions..."
chmod 777 ../{archives,artwork,songs} && success || failure
