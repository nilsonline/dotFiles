#!/bin/bash

# Author: Nils Gerstner
# Last revision: 21st September 2018
# Version: v1.4
# Description: ssh into server from array

servers=(
		'user@server01.com'
		'user@server02.com'
		'user@server03.com'
)
vpnservers=(
		'user@vpn_server01.com'
		'user@vpn_server02.com'
		'user@vpn_server03.com'
		'user@vpn_server04.com'
)

# Is the machine connected to Cisco VPN?
if [ -n $(ip addr |grep -m 1 cscotun) ] && [ -n $(dig +short ${vpnservers[0]}) ];the
		  nif [ "$(ip addr |grep -m 1 -o cscotun)" = "cscotun" ];then
		servers=("${vpnservers[@]}" "${servers[@]}")
fi

select SERVER in "${servers[@]}"; do
		case $SERVER in
				$Quit)
						exit 1;
						;;
				*)
						ssh -o ConnectTimeout=7 $SERVER
						exit 1;
						;;
		esac
done
