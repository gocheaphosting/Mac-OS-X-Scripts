#!/bin/bash

thisfile_old="$thisfile"
thisfile="general_header.sh"

function ifblank {
	local a=$1
	shift
	if [ x"${!a}" = x ] ; then
		${a}="$@"
	fi
}

#_____________________________________________________________________________
# GET SOME SYSTEM INFO

myname="$(basename $0)"

#_____________________________________________________________________________
# PARSE COMMAND LINE

debug=
reset=
init=

if [ x$1 = xdebug ] ; then
	debug=yes
	shift
fi

if [ x$1 = xreset ] ; then
	reset=yes
	shift
fi

if [ x$1 = xinit ] ; then
	init=yes
	shift
fi

#_____________________________________________________________________________
# SETUP SOME DEFAULTS

# input=input
# output=output
log=log

#_____________________________________________________________________________
# SETUP SOME CONSTANTS AND FUNCTIONS

. "$bin/colours"		# defines some colour const vars
. "$bin/dbcolours"		# colours for e-mail database
. "$bin/gfp_info"		# function to convert rel path to absolute
. "$bin/alert.sh"		# function and standalone command
. "$bin/printval.sh"		# function and standalone command
. "$bin/ask-continue.sh"		# function
. "$bin/footer.sh"		# This is a function which includes an echo to bring shell prompt to a new line after using progress meter.

if [[ "$debug" ]] ; then
	printvar myname $LINENO
	printvar thisfile $LINENO
	printvar HOME $LINENO
	printvar bin $LINENO
fi

thisfile="$thisfile_old"
