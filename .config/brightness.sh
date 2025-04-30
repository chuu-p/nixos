#!/usr/bin/env sh

# https://wiki.archlinux.org/title/Redshift

if [ "$1" = period-changed ]; then
	case $3 in
		night)
      brightnessctl s 0%
			;;
		transition)
      brightnessctl s 50%
			;;
		daytime)
      brightnessctl s 100%
			;;
	esac
fi
