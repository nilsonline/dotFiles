#!/bin/bash

# Author: Nils Gerstner
# Last revision: 25th August 2018
# Version: v1
# Description: Update Mac

RED='\033[0;34m'
NC='\033[0m' # No Color

printf "${RED}# brew update -v${NC}\n"
brew update -v
printf "${RED}# brew upgrade -v${NC}\n"
brew upgrade -v
printf "${RED}# brew cleanup -s -v${NC}\n"
brew cleanup -s -v
printf "${RED}# brew doctor -v${NC}\n"
brew doctor -v
printf "${RED}# brew missing -v${NC}\n"
brew missing -v
printf "${RED}# apm upgrade -c false${NC}\n"
apm upgrade -c false
