#!/bin/bash

function ask-continue {
	local response
	local thisfile="ask-continue"
	echo
	echo
	echo '          Continue?'
	select response in yes no ; do
		case "$response" in
			'yes')
				alert "response" "Right on! Let's go!"
				echo
				break
				;;
			'no')
				alert "response" "OK, you're the boss!"
				echo
				echo
				exit 1
				;;
		esac
	done
} <&0 >&2
