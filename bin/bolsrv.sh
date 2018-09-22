#!/bin/bash

# Author: Nils Gerstner
# Last revision: 21st September 2018
# Version: v1.2
# Description: ssh into server from array

servers(
		'user@server01.com'
		'user@server02.com'
		'user@server03.com'
		'user@server04.com'
		'user@server05.com'
		'user@server06.com'
		'user@server07.com'
		'user@server08.com'
		'user@server09.com'
		'user@server10.com'
)
	

select SERVER in "${servers[@]}"; do
		case $SERVER in
				$Quit)
						exit 1;
						;;
				*)
						ssh $SERVER
						exit 1;
						;;
		esac
done
