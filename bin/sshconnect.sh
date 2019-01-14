#!/bin/bash

# Author: Nils Gerstner
# Last revision: 21st September 2018
# Version: v1.4
# Description: ssh into server from array

grey="\033[0;30m"
blue="\033[0;34m"
red="\033[0;31m"
yellow="\033[0;33m"
nc="\033[0m" 
bold="\033[1m"

# If bolsrv0441 is reachable, assume that we can reach all bolidens servers
if [ -n "$(dig +tries=1 +time=5 +short bolsrv0441.boliden.internal)" ]; then
		server+=("e-bolnige@bolsrv0441.boliden.internal")
		comment+=("Test/QA Broker")
		color+=("$yellow")

		server+=("e-bolnige@bolsrv0425.boliden.internal")
		comment+=("Test/QA Gateway")
		color+=("$yellow")
		
		server+=("e-bolnige@bolsrv0442.boliden.internal")
		comment+=("PROD Broker")
		color+=("$red")
		
		server+=("e-bolnige@bolsrv0429.boliden.internal")
		comment+=("PROD Gateway")
		color+=("$red")
		
		server+=("zystems@bolsrv0129.boliden.internal")
		comment+=("Old PROD Broker")
		color+=("$red")
		
		server+=("zystems@bolsrv0134.boliden.internal")
		comment+=("Old PROD Gateway")
		color+=("$red")
		
		server+=("zystems@bolsrv0135.boliden.internal")
		comment+=("Old PROD Broker 2")
		color+=("$red")
		
		server+=("replyto@bolsrv0136.boliden.internal")
		comment+=("Old QA Gateway 2")
		color+=("$yellow")
		
		server+=("zystems@bolsrv0137.boliden.internal")
		comment+=("Old QA Gateway")
		color+=("$yellow")
		
		server+=("replyto@bolsrv0138.boliden.internal")
		comment+=("Old Test/QA Broker")
		color+=("$yellow")

		server+=("replyto@bipdev.boliden.internal")
		comment+=("Development broker")		
		color+=("$blue")

		server+=("replyto@bipunittest.boliden.internal")
		comment+=("Unittest server")		
		color+=("$blue")

		server+=("e-bolnige@bolsrv0211.boliden.internal")
		comment+=("SVN, WIKI")
		color+=("$blue")

fi

# Add the rest of the servers
server+=("nils@gerstner.se")
comment+=("HeartOfGold Hetzner")
color+=("$nc")

server+=("nige@pippi.replyto.se")
comment+=("ReplyTo, RCC server")
color+=("$blue")

server+=("support@pippi.replyto.se")
comment+=("ReplyTo, RCC server")
color+=("$blue")

pad=" -------------------------------------------------"
if [ -z "${1}" ]; then
	printf "\n$grey%s$nc\n" "S E R V E R   L I S T :"
	for key in "${!server[@]}"; do
		printf "${color[$key]}%2d) " "$(( ${key}+1 ))"	
		printf "%s" "${server[$key]}"
		printf "$grey%s\n$nc" "${pad:0:$((75-${#server[$key]}-${#comment[$key]}))} ${comment[$key]}"
	done
fi
	echo
	if [ -z $1 ]; then
			echo "Please choose a server to connect to"
			read pc
			echo
	else
			pc="${1}"
	fi

	re='^[0-9]+$'
	while ! [[ $pc =~ $re ]] ; do
			echo "error: '${pc}' is not a number between 1 and $(($key+1))" >&2; 
		read pc
		echo
	done 	

# Login to server. If login fails, ssh-copy-id to server and try again.
printf "${color[$(( pc-1 ))]}%s$bold%s\n$nc" "Connecting to " "${server[$(( $pc-1 ))]}"
ssh -o PasswordAuthentication=no -o ConnectTimeout=7 ${server[$(( $pc-1 ))]} || \
  (printf "No Password set\n\n"; \
  ssh-copy-id  -o ConnectTimeout=7 ${server[$(( $pc-1 ))]}; \
  ssh -o ConnectTimeout=7 ${server[$(( $pc-1 ))]})
unset server; unset comment & printf "$nc"
printf "$nc"
