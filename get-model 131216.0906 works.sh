#!/bin/bash

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

# A default for testing:
# a="20110312_132700_IMG_1505.JPG"

# ext gets the filename extension

execute=$1 # If execute=go then file info will be added to filenames.

if [ x$execute = xgo ] ; then
	mid=$2
	ext=$3
elif [ x$execute = x ] ; then
#	echo usage: $0 [go] [string2] string1
#	echo where string1 is compared to the end of the filenames, and
#	echo an optional string2 is compared anywhere within the filenames
#	exit

#if [ "x$mid$ext" = "" ] ; then
	mid='jpg *JPG *jpeg *JPEG'
#fi

else
	mid=$1
	ext=$2
fi

#	img=$(echo $a | sed 's/\([[:digit:]]*[\._-][[:digit:]]*\)_\(IMG_[[:alnum:]]_[^\.]*\)\.\([[:alnum:]]*\)/\2_\1_'"$model"'\3/')
#	img=$(echo $a | sed 's/\([[:digit:]]*[\._-][[:digit:]]*\)_\(IMG_[[:alnum:]]_[^\.]*\)\.\([[:alnum:]]*\)/\2_\1_'"$model"'\3/')
#	img=$(echo $a | sed 's/^\([^[:alpha:]]*\)\(IMG_[[:digit:]]*\)_*\([^\.]*\)\.\([[:alnum:]]*\)/\2_\1_\3_'$model'.\4/')
#	s/\([[:digit:]]*[\._-][[:digit:]]*\)_\(IMG_[[:alnum:]]_[^\.]*\)\.\([[:alnum:]]*\)/\2_\1_'"$model"'\3/
#		filesize=$(stat -f '%z' "$filename") # maybe quicker way to get file size, but in bytes
#			aperture=$(exiftool -H -s a -u -g1 -q -q -p '$Aperture' "$filename")

echo
echo
echo
echo mid=$mid ext=$ext

ls -1 *${mid}*${ext} | \
while read filename ; do
#	echo $filename
	IFS_save="$IFS"
	IFS="~"
	exiftool -H -s -a -u -g1 -q -q -f -fast -d '%Y%m%d.%H%M%S' -p ';${Model}~x${DateTimeOriginal}~x${Aperture}~x${FileSize}~j${ImageSize}' "$filename" | \
	while read model imgdate aperture filesize imgsize ; do
#		echo $filename" model="$model" imgdate="$imgdate" aperture="$aperture" filesize="$filesize" imgsize="$imgsize" imgno="$imgno" hash="$hash" newname="$newname
		imgno=$(echo "$filename" | sed 's/^\(.*\)\..*$/\1/') # strip extension for files with no IMG no.
		imgno=$(echo "$imgno" | sed 's/^\(.*[IiMm][MmVv][GgIi][-_]\)\([[:digit:]]*\).*$/\2/')
		imgno="${imgno// /_}" # imgno captures text in filename if there is no IMG number.
		extn=$(echo "$filename" | sed 's/.*\.//' | tr '[:lower:]' '[:upper:]')
		hash=$(shasum 256 "$filename" 2>/dev/null | sed 's/\([[:alnum:]]*\).*/\1/')
#		if model is - try -ProfileDescriptionML
#		-FileModifyDate if date is -
		if [ x$model = x- ] ; then
			model="$(exiftool -s3 -a -u -q -q -f -p '${ProfileDescriptionML}')"
		fi
		model="${model// /_}"
		model="${model//;/}"
		imgdate="${imgdate//x/}"
		aperture="${aperture//x/}"
		filesize="${filesize// /}"
		filesize="${filesize//x/}"
		imgsize="${imgsize// /}"
		imgsize="${imgsize//j/}"
		if [ x$model = xiPod_touch ] ; then
			model=iPod_touch_f"$aperture"
		elif [ x$model = x- ] ; then
			model=unknown
		fi
		if [ x$imgdate = x- ] ; then
			imgdate="$(exiftool -s3 -a -u -q -q -f -d '%Y%m%d.%H%M%S' -p '${FileModifyDate}')"
		fi
		newname="${model}_IMG_${imgno}_${imgsize}_${filesize}_${imgdate}_${hash}.$extn"
		ser=0
		if [ "x$newname" = "x$filename" ] ; then
			echo "$filename" --- "$newname     Nothing to do."
		else
			while [ -e "$newname" ] ; do
				(( ser++ ))
				newname="${model}_IMG_${imgno}_${imgsize}_${filesize}_${imgdate}_${hash}_${ser}.$extn"
			done
			if [ x$execute = xgo ] ; then
				mv -v "$filename" "$newname"
			else
#				echo $filename"  model="$model"  imgdate="$imgdate"   imgno="$imgno"   filenamedate="$filenamedate"   aperture"=$aperture"  newname="$newname
#				echo $filename" model="$model" imgdate="$imgdate" imgno="$imgno" hash="$hash" aperture"=$aperture" newname="$newname
#				echo "$hash $imgdate $model $imgsize -- $filesize -- $filename -- $newname"
				echo "$filename -- $newname"
			fi
		fi
		IFS="$IFS_save"
	done
done
