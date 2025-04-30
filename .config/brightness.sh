#!/usr/bin/env sh

# https://wiki.archlinux.org/title/Redshift

if [ "$1" = period-changed ]; then
	case $3 in
		night)
		  echo "$(date +%T): redshift set night" >> /var/log/redshift.log
      brightnessctl s 0%
			;;
		transition)
		  echo "$(date +%T): redshift set transition" >> /var/log/redshift.log
      brightnessctl s 50%
			;;
		daytime)
		  echo "$(date +%T): redshift set daytime" >> /var/log/redshift.log
      brightnessctl s 100%
			;;
	esac
fi
