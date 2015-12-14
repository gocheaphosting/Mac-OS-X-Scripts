#!/bin/bash

thisfile_old="$thisfile"
thisfile="show-progress"

#[[ $debug ]] && echo Progress Start
#[[ $debug ]] && printvar total

(( count++ ))

#[[ $debug ]] && printvar total
#[[ $debug ]] && printvar count

if [[ $count -gt $total ]] ; then
#	(( count=$total ))
	   count=$total
fi

msg2=

#[[ $debug ]] && printvar msg2
[[ "$1" ]] && msg2="$@"

#[[ $debug ]] && printvar msg2
[[ "$msg2" ]] && msg2="\033[36m$msg2\033[0m"

#[[ $debug ]] && echo "msg2=$msg2"

now=$(date "+%s")

#[[ $debug ]] && printvar now

de=$(echo "scale=10 ; a = ( ( $now - $start ) + 0.99 ) / 3600 / 24 ; scale=0 ; a/1" | bc)
he=$(echo "scale=10 ; a = ( ( $now - $start ) + 0.99 ) / 3600 - $de * 24 ; scale=0 ; a/1" | bc)
me=$(echo "scale=10 ; a = ( ( $now - $start ) + 0.99 ) / 60 - $de * 24 * 60 - $he * 60 ; scale=0 ; a/1" | bc)
se=$(echo "scale=10 ; a = ( ( $now - $start ) + 0.99 ) - $de * 24 * 3600 - $he * 3600 - $me * 60 ; scale=0 ; a/1" | bc)

#[[ $debug ]] && printvar de
#[[ $debug ]] && printvar he
#[[ $debug ]] && printvar me
#[[ $debug ]] && printvar se

if [[ $de -gt 0 ]] ; then
	elapsed="\033[35m${de}d "$(date -j -f "%H:%M:%S" "${he}:${me}:$se" "+%H:%M:%S")"\033[0m"
elif [[ $he -gt 0 ]] ; then
	elapsed="\033[35m"$(date -j -f "%H:%M:%S" "${he}:${me}:$se" "+%H:%M:%S")"\033[0m"
else
	elapsed="\033[35m"$(date -j -f "%M:%S" "${me}:$se" "+%M:%S")"\033[0m"
fi

#[[ $debug ]] && echo -en "elapsed=$elapsed"'\n'

if [[ $count -gt 0 ]] ; then

	dr=$(echo "scale=10 ; a = ( ( $total / $count - 1 ) * ( $now - $start ) + 0.99 ) / 3600 / 24 ; scale=0 ; a/1" | bc)
	hr=$(echo "scale=10 ; a = ( ( $total / $count - 1 ) * ( $now - $start ) + 0.99 ) / 3600 - $dr * 24 ; scale=0 ; a/1" | bc)
	mr=$(echo "scale=10 ; a = ( ( $total / $count - 1 ) * ( $now - $start ) + 0.99 ) / 60 - $dr * 24 * 60 - $hr * 60 ; scale=0 ; a/1" | bc)
	sr=$(echo "scale=10 ; a = ( ( $total / $count - 1 ) * ( $now - $start ) + 0.99 ) - $dr * 24 * 3600 - $hr * 3600 - $mr * 60 ; scale=0 ; a/1" | bc)

else

	dr=$(echo "scale=10 ; a = ( ( $now - $start ) + 0.99 ) / 3600 / 24 ; scale=0 ; a/1" | bc)
	hr=$(echo "scale=10 ; a = ( ( $now - $start ) + 0.99 ) / 3600 - $dr * 24 ; scale=0 ; a/1" | bc)
	mr=$(echo "scale=10 ; a = ( ( $now - $start ) + 0.99 ) / 60 - $dr * 24 * 60 - $hr * 60 ; scale=0 ; a/1" | bc)
	sr=$(echo "scale=10 ; a = ( ( $now - $start ) + 0.99 ) - $dr * 24 * 3600 - $hr * 3600 - $mr * 60 ; scale=0 ; a/1" | bc)

fi

#[[ $debug ]] && printvar dr
#[[ $debug ]] && printvar hr
#[[ $debug ]] && printvar mr
#[[ $debug ]] && printvar sr

remain="\033[32m"$(printf '%2sd %2sh %2sm %2ss' "$dr" "$hr" "$mr" "$sr")"\033[0m"

#[[ $debug ]] && echo -en "remain=$remain"'\n'

#[[ $debug ]] && printvar wid
#[[ $debug ]] && printvar count
#[[ $debug ]] && printvar total

if [[ $total -gt 0 ]] ; then
	pct="\033[33m"$(printf "%3s" $(echo "scale=10 ; a = $count / $total * 100 ; scale=0 ; a/1" | bc))"%\033[0m"
	counter="\033[34m"$(printf "%${wid}s" "$count/$total")"\033[0m"
	#[[ $debug ]] && echo -en "pct=$pct"'\n'
	#[[ $debug ]] && echo -en "counter=$counter"'\n'
	if [[ $dr -gt 0 ]] ; then
		remain="\033[32m${dr}d "$(date -j -f "%H:%M:%S" "${hr}:${mr}:$sr" "+%H:%M:%S")"\033[0m"
	elif [[ $hr -gt 0 ]] ; then
		remain="\033[32m"$(date -j -f "%H:%M:%S" "${hr}:${mr}:$sr" "+%H:%M:%S")"\033[0m"
	else
		remain="\033[32m"$(date -j -f "%M:%S" "${mr}:$sr" "+%M:%S")"\033[0m"
	fi
	#[[ $debug ]] && echo -en "remain=$remain"'\n'
	echo -en "\r$counter $pct $remain $elapsed $msg2\033[K" >&2
else
	echo -en "\r$count $elapsed $msg2\033[K" >&2
fi

#[[ $debug ]] && echo Progress End

thisfile="$thisfile_old"
