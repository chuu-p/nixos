#!/run/current-system/sw/bin/bash

# https://wiki.archlinux.org/title/Redshift
# this would be correct but does not work !/usr/bin/env bash

if [ "$1" = period-changed ]; then
	case $3 in
		night)
		  echo "$(date +%T): redshift set night" >> /tmp/redshift.log
      /run/current-system/sw/bin/brightnessctl s 0%
			;;
		transition)
		  echo "$(date +%T): redshift set transition" >> /tmp/redshift.log
      /run/current-system/sw/bin/brightnessctl s 50%
			;;
		daytime)
		  echo "$(date +%T): redshift set daytime" >> /tmp/redshift.log
      /run/current-system/sw/bin/brightnessctl s 100%
			;;
	esac
fi
