#!/bin/bash

program_name_clr=Yellow
program_name_width=-20

function_name_clr=BrightCyan
function_name_width=-20

alert_class_clr=Magenta
alert_class_width=10

alert_msg_clr=BrightGreen
alert_msg_width=

alert_sentinel_clr=BrightRed
alert_sentinel='<'
alert_sentinel_width=

alert_type=

#echo "alert_class_width=$alert_class_width"

case "$alert_type" in
short)
	printval_fmt="$ColourOn${!alert_class_clr}m%${!alert_class_width}s $ColourOn${!alert_msg_clr}m%${!alert_msg_width}s$ColourOn${!alert_sentinel_clr}m${!alert_sentinal}$ColourOff"
#	echo "alert_class_width=$alert_class_width"
#	echo "$printval_fmt"
;;
medium)
	printval_fmt="$ColourOn${!function_name_clr}m%${!function_name_width}s $ColourOn${!alert_class_clr}m%${!alert_class_width}s $ColourOn${!alert_msg_clr}m%${!alert_msg_width}s$ColourOn${!alert_sentinel_clr}m${!alert_sentinal}$ColourOff"
#	echo "alert_class_width=$alert_class_width"
#	echo "$printval_fmt"
;;
*)
	printval_fmt="$ColourOn${!program_name_clr}m%${!program_name_width}s $ColourOn${!function_name_clr}m%${!function_name_width}s $ColourOn${!alert_class_clr}m%${!alert_class_width}s $ColourOn${!alert_msg_clr}m%${!alert_msg_width}s$ColourOn${!alert_sentinel_clr}m${!alert_sentinal}$ColourOff"
#	echo "alert_class_width=$alert_class_width"
#	echo "$printval_fmt"
;;
esac

function printval {
	case "$alert_type" in
	short)
		printf "${printval_fmt}" "$1" "$2"
	;;
	medium)
		printf "${printval_fmt}" "${thisfile}:" "$1" "$2"
	;;
	*)
		printf "${printval_fmt}" "${myname}:" "(${thisfile})" "$1" "$2"
	;;
	esac
	echo " $3" # optional comment from calling script
} >&2

function printvar {
#	echo '$1='"$1"
	local a="$1"
#	echo '$a='"$a"	
#	echo '${!a}='"${!a}"	
#	echo "$printval_fmt"
	# $2 is optional line number passed from calling script from $LINENO
	echo -n "($2) "
	case "$alert_type" in
	short)
#		echo "short alert"
		printf "${printval_fmt}" "$a" "${!a}"
	;;
	medium)
#		echo "medium alert"
		printf "${printval_fmt}" "${thisfile}:" "$a" "${!a}"
	;;
	*)
#		echo "default alert"
		printf "${printval_fmt}" "${myname}:" "(${thisfile})" "$a" "${!a}"
	;;
	esac
	echo " $3" # optional comment from calling script
} >&2

function debugvar {
	local a="$1"
	local b=debug_$a
	# $2 is optional line number passed from calling script from $LINENO
	if [ x${!b} = x ] ; then
		printvar $a $2 "$3"
	fi
}