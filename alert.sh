#!/bin/bash

function alert {

	case "$alert_type" in
	short)
		if [[ "$alert_fmt" ]] ; then
			printf "${alert_fmt}$ColourOff\n" "$1" "$2" "$3"
		else
			printf "$ColourOff$ColourOn${Grey}m%-21s $ColourOn${Brown}m%-30s $ColourOn${BrightRed}m%s$ColourOff\n" "$1" "$2" "$3"
		fi
	;;
	*)
		if [[ "$alert_fmt" ]] ; then
			printf "${alert_fmt}$ColourOff\n" "${myname}:" "(${thisfile})" "$1" "$2" "$3"
		else
			printf "$ColourOff$ColourOn${Grey}m%-30s $ColourOn${Cyan}m%-30s $ColourOn${Grey}m%-21s $ColourOn${Brown}m%-30s $ColourOn${BrightRed}m%s$ColourOff\n" "${myname}:" "(${thisfile})" "$1" "$2" "$3"
		fi
	;;
	esac
} >&2
