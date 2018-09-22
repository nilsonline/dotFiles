#!/bin/bash

# Author: Nils Gerstner
# Last revision: 15th July 2018
# Version: v1
# Description: Write colored messages to the terminal

function cmsg {
		case "$1" in
					 black)		COLOR="\033[0;30m"
									;;
					 white) 		COLOR="\033[1;37m"
									;;
					 grey)		COLOR="\033[1;30m"
									;;
					 lgrey) 		COLOR="\033[0;37m"
									;;
					 red) 		COLOR="\033[0;31m"
									;;
					 lred) 		COLOR="\033[1;31m"
									;;
					 green) 		COLOR="\033[0;32m"
									;;
					 lgreen) 	COLOR="\033[1;32m"
									;;
					 brown) 		COLOR="\033[0;33m"
									;;
					 yelow) 		COLOR="\033[1;33m"
									;;
					 blue) 		COLOR="\033[0;34m"
									;;
					 lblue) 		COLOR="\033[1;34m"
									;;
					 purple) 	COLOR="\033[0;35m"
									;;
					 lpurple)	COLOR="\033[1;35m"
									;;
					 cyan) 		COLOR="\033[0;36m"
									;;
					 lcyan) 		COLOR="\033[1;36m"
									;;
					 nocolor)	COLOR="\033[0m" 
									;;
		esac
		printf "${COLOR}${2}\33[0m\n"
}




