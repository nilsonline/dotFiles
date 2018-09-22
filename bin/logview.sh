#!/bin/bash

# Author: Nils Gerstner
# Last revision: 20th September 2018
# Version: v2.1
# Description: Manipulate logfiles. Maybe this should be done by putting symlinks into a ~/logs...

logs=(
	'/var/mqsi/components/IB10NODE/stdout'
	'/var/mqsi/components/IB10NODE/stderr'
	'/var/mqsi/components/IB10NODE/ea461e10-e0c3-4fdb-9c66-0d6a42b55f39/stdout'
	'/var/mqsi/components/IB10NODE/ea461e10-e0c3-4fdb-9c66-0d6a42b55f39/stderr'
	'/var/baseline/logs/broker.log'
	'/var/log/syslog'
)

if [ -n "$1" ]; then
	select i in "${logs[@]}"; do
		case $i in
			$Quit)
				break;
				;;
			*)
				$@ $i
				break;
				;;
		esac
	done
else
	echo "Please provide an argument. For example: less"
fi
