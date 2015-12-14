#!/bin/bash

. "$bin"/general_header # defines some functions like alert and progress

# Extracts the camera model from the picture exif data and adds it to the filename.
# Also moves the preceding date info to the end, before the model string in the filename.
# Assumes that the extension of all file names is the same as the directory name.

# Options used with exiftool below

# exiftool without options opens a man page
# exiftool followed by a filename prints TAGs from the file
# -a	print all TAGs even if they are empty or not even in the file
# -d	specifies date output format
# -g	sort output by groups an print a group header line
# -g1	same as -g but print group name for each tag
# -H	print TAG hex codes as well as the other information
# -m	convert minor errors to warnings
# -q	quiet; suppresses normal informational messages
# -q -q	suppresses warnings as well
#   	(use -m to convert minor errors to warnings and suppress them too)
# -s	print TAG names instead of descriptions
# -u	print values in unknown tags

function rename_img {
#	newname=$(echo "${imgdate}_${hash}_${model}_${imgno}_${imgsize}_${filesize}.$extn" | sed 's/_-//g ; s/^-//g ; s/_\.*_/_/g ; s/__/_/ ; s/__/_/')
#	newname="${model}_IMG_${imgno}_${imgsize}_${filesize}_${imgdate}_${hash}_${ser}.$extn"
#	newname="${imgdate}_${hash}_${model}_IMG_${imgno}_${imgsize}_${filesize}_${ser}.$extn"
#	newname="IMG_${imgno}_${hash}${ser}.$extn"
	newname="IMG_${imgno}_${imgdate}_${filedate}${ser}.$extn"

}

declare -a datestr
ser=0
serstr=

execute=$1 # If execute=go then file info will be added to filenames.

if [ x$execute = xgo ] ; then
	mid=$2
	ext=$3
elif [ x$execute = x ] ; then
	echo Need to specify search parameters.
	echo usage: $0 [go] [string2] string1
	echo where string1 is compared to the end of the filenames, and
	echo an optional string2 is compared anywhere within the filenames
	exit
else
	mid=$1
	ext=$2
fi

if [ x$ext = x ] ; then
	ext=$mid
	mid=
fi

#echo mid='>'$mid'<' ext='>'$ext'<'

ls -1 -- *${mid}*${ext} | \
#ls -1 *jpg *JPG | \
while read filename ; do
#	echo $filename
	IFS_save="$IFS"
	IFS="~"
	exiftool -H -s -a -u -g1 -q -q -f -fast -d '%Y%m%d.%H%M%S' -p ';${Model}~x${DateTimeOriginal}~x${Aperture}~x${FileSize}~j${ImageSize}~${FileModifyDate}' "$filename" | \
	while read model imgdate aperture filesize imgsize filedate; do
#		echo $filename" model="$model" imgdate="$imgdate" aperture="$aperture" filesize="$filesize" imgsize="$imgsize" imgno="$imgno" hash="$hash" newname="$newname
#		imgno=$(echo "$filename" | sed 's/^\(.*\)\..*$/\1/') # strip extension for files with no IMG no.
#		imgno=$(echo "$imgno" | sed 's/^\(.*[IM][MV][GI]_\)\([[:digit:]]*.*_\).*$/\2/')
#		imgno=$(echo "$imgno" | sed -n 's/^\(.*[IM][MV][GI]_\)\([-[:alnum:]]*\)_[[:digit:]].*$/\2/p') # IMG_ alnum _digit
		imgno=$(echo "$filename" | sed -n 's/^.*\(IMG_\)\([[:digit:]][[:digit:]]*\).*$/\2/p') # IMG_ digits _
#		echo imgno=$imgno
#		extn=$(echo "$filename" | sed 's/.*\.//' | tr '[:lower:]' '[:upper:]')
		extn=$ext
		imgdate="${imgdate//x/}"

		serstr=
		rename_img
		ser=0
		if [ "x$newname" = "x$filename" ] ; then
			echo "$filename" --- "$newname     Nothing to do."
		else
			while [ -e "$newname" ] ; do
				(( ser++ ))
				serstr=_$ser
				rename_img
			done

			if [ x$execute = xgo ] ; then
				mv -v "$filename" "$newname"
			else
#		echo $filename"  model="$model"  imgdate="$imgdate"   imgno="$imgno"   filenamedate="$filenamedate"   aperture"=$aperture"  newname="$newname
#		echo $filename" model="$model" imgdate="$imgdate" imgno="$imgno" hash="$hash" aperture"=$aperture" newname="$newname
#		echo "$hash $imgdate $model $imgsize -- $filesize -- $filename -- $newname"
				echo "$filename -- $newname"
#	fi
			fi
		fi
		IFS="$IFS_save"
	done # reading exif data. this loop only happens once per file.
done # reading files
