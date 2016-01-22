#!/bin/bash
. "$bin/general_header"
mode="$1"
shift
input="files"
tdir="$bin"
quot=\"
(( filecount = 0 ))
datenow=$(date)
##############################################################################
function do_row {
	thisfile=do_row
	local name="$1" # REFERENCE TO THIS TABLE
	shift
	local ptr="$1" # REFERENCE TO OTHER TABLE
	shift
	local size="$1" # size
	shift
	local text="$1" # text: filename without extension and dir
	shift
	local dirnam="$1" # dir where file was found
	shift
	local link="$*" # link to file
	echo "<TR>"
	# WRITE THE ROW NAME, AND FILE SIZE.
	echo "<TD valign=top align=right><A name=$quot${name}-$link$quot>$size</A>&nbsp</TD>"
	# WRITE THE LINK TO THE OTHER TABLE.
	echo "<TD valign=top>"
	echo "<A href=${quot}#${ptr}-$link$quot>$ptr</A>&nbsp"
	echo "</TD>"
	# WRITE THE FILE NAME AND HREF LINK
	echo -en "<TD valign=top>"
	echo -en "<A href=$quot$link$quot>$text</A><small>$dirnam</small>"
	echo -en "</TD>"
	echo "</TR>"
}

##############################################################################
function do_table {
	thisfile=do_table
	echo "<TABLE rules=groups>"
#	(( count = filecount ))
	while read line ; do
		siz=$(echo "$line" | sed 's/^[[:space:]]*\([^[:space:]]*\).*$/\1/')
		f=$(echo "$line" | sed 's/^[[:space:]]*[^[:space:]]*[[:space:]]\(.*\)$/\1/')
		link=$(echo "$f" | sed 's/^.*\(\.\/.*\)$/\1/')
		  text=$(echo "$f" | sed 's/^\(.*\)\.\/.*$/\1/')
		#nam=$(echo "$f" | sed 's/.*\/\(.*\)$//')
		dirnam=$(echo "$link" | sed 's/^\(.*\)\/\(.*\)$/\1/')
		   #nam=$(echo "$f" | sed 's/^\(.*\)\/\(.*\)$/\2/')
		do_row "$1" "$2" "$siz" "$text" "$dirnam" "$link"
		thisfile=do_table
#		. "$bin/show-progress"
	done
	echo "</TABLE>"
}

##############################################################################
function do_page {
	thisfile=do_page
	searchterm="$*"
	# WRITE THE FIRST TABLE
	echo "Sorted by File Name.<BR><BR>"
#	echo >&2
#	echo "Preparing to build first table." >&2
#	. "$bin/start"
	cat "$input" | \
	sort -k2 | \
	do_table '^' 'v'
	thisfile=do_page
	echo "<BR>"
	# WRITE THE SECOND TABLE
#	echo "<i>${searchterm}:</i>&nbsp${filecount} by file size reverse<BR><BR>"
	echo "Sorted by File Size.<BR><BR>"
#	echo >&2
#	echo "Preparing to build second table." >&2
#	. "$bin/start"
	cat "$input" | \
	sort -r | \
	do_table 'v' '^'
	thisfile=do_page
	echo "<BR><BR><small>Generated on:&nbsp${datenow}</small>"
	# NEED THE LINES BELOW SO LINKING TO THE BOTTOM TABLE WILL
	# REVEAL THE CORRECT LINE AT THE TOP OF THE SCREEN
	# FOR ITEMS NEAR THE BOTTOM OF THE TABLE.
	for (( i=1 ; i < 100 ; i++ )) ; do
		echo "<BR>"
	done
	echo "" # END HTML DOCUMENT
	cat "$tdir/html_bottom.html" 2>/dev/null
}

##############################################################################
function do_search {
	thisfile=do_search
	find . -type f -iname "$str" | \
	egrep -v "(\.html$)" | \
	sort | \
	while read line ; do
		(( filecount++ ))
		echo -n '.' >&2
		f="$line"
		dir=$(echo "$f" | sed 's/^\(.*\)\/.*$/\1/')
		nam=$(echo "$f" | sed 's/.*\///')
		siz=$(stat -f %z "$f")
		printf "%9s %s %s\n" "$siz" "$nam" "$f"
	done
}
thisfile=main
#echo >&2
delimit="[^[:alpha:]]"
for term in "$@" ; do
	thisfile=reading_terms
#	echo -n "${term} " >&2
	printf "%-20s" "$term" >&2
	case "$mode" in
		L)
			str="$term"'*'
		;;
		R)
			str='*'"$term"
		;;
		C)
			str='*'"$term"'*'
		;;
	esac
	exec 6>"$input"
	do_search >&6 # CALL FUNCTION SEARCH
	thisfile=main
	exec 6>&-
	output="${term}_${mode}.html"
	exec 7>"$output"
	cat "$tdir/html_top1.html" >&7 # DOCTYPE AND HTML DOCUMENT
	echo "" >&7 # DEFAULT TEXT FONT
	cat "$tdir/html_top2.html" >&7 # BODY
	echo "Search Term: &nbsp <i>${term}</i><BR><BR>" >&7
	do_page "$term" >&7 # CALL FUNCTION DO PAGE
	thisfile=main
	exec 7>&-
done
echo
