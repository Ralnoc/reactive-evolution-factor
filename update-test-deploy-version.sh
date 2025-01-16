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

rm -rf ./build/files
mkdir -p ./build/files
TEST_VERSION_PREFIX="999.0."

if [ -f ./build/build_number.txt ]; then
  PREV_BUILD_NUMBER=$(cat ./build/build_number.txt)
  BUILD_NUMBER=$(( $PREV_BUILD_NUMBER + 1 ))
  TESTING_VERSION=${TEST_VERSION_PREFIX}${BUILD_NUMBER}

  printf "${LIGHTBLUE}Incrementing Test version from ${YELLOW}${TEST_VERSION_PREFIX}${PREV_BUILD_NUMBER}${LIGHTBLUE} to ${YELLOW}${TESTING_VERSION}${NC}\n"
  echo $BUILD_NUMBER > ./build/build_number.txt
  echo $TESTING_VERSION > ./build/testing_version.txt
else
  BUILD_NUMBER=0
  TESTING_VERSION=${TEST_VERSION_PREFIX}${BUILD_NUMBER}

  printf "${LIGHTBLUE}Initializing Test version as ${YELLOW}${TESTING_VERSION}${NC}\n"
  echo 0 > ./build/build_number.txt
  echo $TESTING_VERSION > ./build/testing_version.txt
fi

mkdir -p ./build/files/reactive-evolution-factor_${TESTING_VERSION}

printf "${LIGHTBLUE}Copying Factorio Reactive Evolution Factor build files to build directory${NC}\n"
for filename in control.lua settings.lua evolution_factors.lua locale info.json LICENSE README.md thumbnail.png image/reactive-evolution-factor.png image/reactive-evolution-factor-image.png; do
  cp -r ./${filename} ./build/files/reactive-evolution-factor_${TESTING_VERSION}/.
done
printf "${LIGHTBLUE}Updating Version to Test Version${NC}\n"
sed -i "s/@@VERSION@@/${TESTING_VERSION}/g" ./build/files/reactive-evolution-factor_${TESTING_VERSION}/info.json