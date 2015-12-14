#!/bin/bash

thisfile_old="$thisfile"
thisfile="fix"

# variable bin is defined in .bash_profile

# usage: fix filename [app]
# description: looks in the users $bin directory for the file and opens it for editing, making a backup

. "$bin"/general_header # defines some functions like alert and progress

template="$bin"/template
file="$bin/$1"
app="$2"

if ! [ -e "$bin" ] ; then
	mkdir "$bin"
fi
if ! [ -d "$bin" ] ; then
	ls -l "$bin"
	echo "fix: $bin needs to _exist_ and be a directory. Check .bash_profile by using:"
	echo 'configure ~/.bash_profile'
	exit 1
fi
if [ "x$file" = "x$bin/" ] ; then
	showbin
	echo "fix: Need a filename."
	echo "usage: fix filename [app]"
	exit 1
fi
if ! [ -e "$file" ] ; then
	cp "$template" "$file"
fi
if [ -f "$file" ] ; then
	# nano -c "$file"   # This was the old way.
	printvar 'file'
	configure "$file" "$app"
else
	echo "$file" needs to exist and be a regular file.
	echo 'If you intended to create a new file '"$file"', there might be a problem with the new-file template or this script.'
	exit 1
fi
chmod 775 "$file"
ls -latr "$file"*
