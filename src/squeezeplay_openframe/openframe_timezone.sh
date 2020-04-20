#!/usr/bin/env bash

# openframe_timezone v1.01 (20th April 2020) by Andrew Davison
#  Executed by OpenFrameTimeZone applet.


## Change this to use an alternative time zone server.
SERVER="openbeak.net"
SERVICE="/tz/lookup.php"
##

THISSCRIPTPATH="$(cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P)"

if [[ "$1" == "check" ]]; then

	timedatectl status | grep "Time zone" | awk -F\  {'print $3'}
	exit 0

elif [[ "$1" == "set" ]]; then

	sudo /usr/bin/timedatectl set-timezone "$2"
	RESULT=$(timedatectl status | grep "Time zone" | awk -F\  {'print $3'})
	echo $RESULT
	[[ "$RESULT" == "$1" ]] && exit 0 || exit 1

elif [[ "$1" == "update" ]]; then

	[ -f /etc/lsb-release ] && source /etc/lsb-release

	if [ -e /tmp/openframe.uid ] && [ -e /tmp/openframe.net ]; then
		SYS_TYP=$(cat /tmp/openframe.uid)/$(cat /tmp/openframe.net)/$(echo ${DISTRIB_DESCRIPTION,,} | awk -F' ' '{print $1 "/" $2}')/${DISTRIB_CODENAME,,}/$(uname -r)/squeezeplay-$(cat $THISSCRIPTPATH/../share/squeezeplay.version)-$(cat $THISSCRIPTPATH/../share/squeezeplay.revision)
	elif [ -f /etc/lsb-release ]; then
		SYS_TYP="///$(hostname)/$(echo ${DISTRIB_DESCRIPTION,,} | awk -F' ' '{print $1 "/" $2}')/${DISTRIB_CODENAME,,}/$(uname -r)/squeezeplay-$(cat $THISSCRIPTPATH/../share/squeezeplay.version)-$(cat $THISSCRIPTPATH/../share/squeezeplay.revision)"
	else
		SYS_TYP="///$(hostname)////$(uname -r)/squeezeplay-$(cat $THISSCRIPTPATH/../share/squeezeplay.version)-$(cat $THISSCRIPTPATH/../share/squeezeplay.revision)"
	fi

	TIMEZONE=$(curl -sA "$SYS_TYP" -m 2 "https://$SERVER/$SERVICE")
	TIMEZONEVALID=$(echo $TIMEZONE | grep -c '/')

	if [[ "$TIMEZONE" != "" ]] && [[ "${#TIMEZONE}" -ge 6 ]] && [[ "${#TIMEZONE}" -le 32 ]] && [[ "$TIMEZONEVALID" -le 2 ]]; then

		sudo /usr/bin/timedatectl set-timezone "$TIMEZONE"
		RESULT=$(timedatectl status | grep "Time zone" | awk -F\  {'print $3'})
		echo $RESULT
		[[ "$RESULT" == "$TIMEZONE" ]] && exit 0 || exit 1

	fi

else

	echo "Usage: $0 <current> | <set> <timezone> | <update>"

fi

exit 0
