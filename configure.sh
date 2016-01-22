#!/bin/bash

. "$bin"/general_header

thisfile_old="$thisfile"
thisfile="configure"

# $AP		absolute path without filename
# $APFN	absolute path with filename
# $FBN	just the filename part

file="$1"
printvar 'file' $LINENO
echo "'configure' is not using 'app' feature"
#app="$2"
#printvar app
#[[ x$app = x ]] || app='-a '"$app" ; alert info "No app specified. Using default. EDITOR=$EDITOR"
#printvar app

if ! [ -e "$file" ] ; then
	alert info  "Im having trouble finding $file"

elif [ -d "$file" ] ; then
	alert info  "Thats a directory."

elif ! [ -f "$file" ] ; then
	alert info  "You cant edit that."

else
		gfp_info "$file"
		printvar 'file' $LINENO
		timestampf=$(stat -f %Sm -t %Y%m%d.%H%M%S "$file")

		printvar timestampf $LINENO

		mkdir -p "$backup_dir$AP"
		if ! [ -w "$file" ] ; then
			echo "Using admin credentials."
			sudo ls -l "$file"
			sudo cp -p "$APFN" "$backup_dir$AP/$FBN".$timestampf
			sudo ls -l "$backup_dir$AP/$FBN".$timestampf
			sudo nano -c "$file"
			sudo ls -l "$APFN"
			sudo cp -pf "$APFN" "$backup_dir$AP/$FBN" # backup the new file.
			sudo ls -l "$backup_dir$AP/$FBN"
		else
			echo "Not using admin credentials."
			ls -l "$file"
			cp -p "$APFN" "$backup_dir$AP/$FBN".$timestampf
			ls -l "$backup_dir$AP/$FBN".$timestampf
			nano -c "$file"
			ls -l "$APFN"
			cp -pf "$APFN" "$backup_dir$AP/$FBN" # backup the new file.
			ls -l "$backup_dir$AP/$FBN"
		fi
fi
thisfile="$thisfile_old"
exit
#			open -F -W -n "$app" "$file"
#			open -e -F -W "$file"
