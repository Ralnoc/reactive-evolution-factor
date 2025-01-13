#!/usr/bin/env bash

RED='\033[0;31m'
LIGHTRED='\033[1;31m'
GREEN='\033[0;32m'
LIGHTGREEN='\033[1;32m'
BROWN='\033[0;33m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
LIGHTBLUE='\033[1;34m'
CYAN='\033[0;36m'
LIGHTCYAN='\033[1;36m'
PURPLE='\033[0;35m'
LIGHTPURPLE='\033[1;35m'
DARKGRAY='\033[1;30m'
LIGHTGRAY='\033[0;37m'
WHITE='\033[1;37m'
NC='\033[0m'

if [ -f ./build/testing_version.txt ]; then
  TESTING_VERSION=$(cat ./build/testing_version.txt)
else
  printf "${RED}No testing_version.txt file found${NC}\n"
  exit 1
fi

printf "${LIGHTBLUE}Removing Factorio Reactive Evolution Factor from Client at ${LIGHTCYAN}/c/Users/drahk/AppData/Roaming/Factorio/mods${NC}\n"
rm /c/Users/drahk/AppData/Roaming/Factorio/mods/reactive-evolution-factor_*.zip 2> /dev/null
printf "${LIGHTBLUE}Deploying Factorio Reactive Evolution Factor Version ${YELLOW}${TESTING_VERSION}${LIGHTBLUE} to Client at ${LIGHTCYAN}/c/Users/drahk/AppData/Roaming/Factorio/mods${NC}\n"
cp ./build/reactive-evolution-factor.zip /c/Users/drahk/AppData/Roaming/Factorio/mods/reactive-evolution-factor_${TESTING_VERSION}.zip 2> /dev/null
rm -rf ./build/files
rm -rf ./build/*.zip
printf "${LIGHTGREEN}Deployment Complete${NC}\n"