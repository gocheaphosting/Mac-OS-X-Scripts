#!/bin/bash

. "${HOME}/bin/general_header"

declare -a max digits
word=
line=

tmpfile="/tmp/align.tmp"

function parse {

	word=$(echo "$line" | sed 's/[[:space:]]\+/\x01/ ; s/\x01.*//')
	line=$(echo "$line" | sed 's/[[:space:]]\+/\x01/ ; s/.*\x01[[:space:]]*//')

	if [ "x$line" = "x$word" ] ; then
		line=
	fi
}

function check_digits {

	echo "$1" | sed 's/^[[:digit:]]*$//'

}

function getmax {

	local i=

	while read line ; do

		echo "$line"
		echo -en "." >&2

		i=

		while [[ "$line" ]] ; do

			parse

			if [[ ${max[$i]} -lt ${#word} ]] ; then

				max[$i]=${#word}

			fi

			[[ $(check_digits "$word") ]] && digits[$i]='-'

			(( i++ ))

		done

	done

	echo >&2

}

function printout {

	while read line ; do

		i=

		while [[ "$line" ]] ; do

			parse

			printf "%${digits[$i]}${max[$i]}s " "${word}"

			(( i++ ))

		done

		echo

	done

}

exec 7>"$tmpfile"
getmax <&0 >&7
exec 7>&-

exec 6<"$tmpfile"
printout <&6
