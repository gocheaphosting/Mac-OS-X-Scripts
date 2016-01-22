#!/bin/bash

# Extracts the camera Model from the picture exif data and adds it to the FileName.
# Also moves the preceding date info to the end, before the Model string in the FileName.
# Assumes that the extension of all file names is the same as the directory name.

# Options used with exiftool below

# exiftool without options opens a man page
# exiftool followed by a FileName prints TAGs from the file
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

# ext gets the FileName extension

execute=$1 # If execute=go then file info will be added to FileNames.

if [ x$execute = xgo ] ; then
	ext=$2
	mid=$3
elif [ x$execute = x ] ; then
	echo "usage: $0 [go] string1 [string2]"
	echo "where string1 is compared to the end (extension) of the filenames, and"
	echo "an optional string2 is compared anywhere within the filenames"
	echo "If go is specified then files will be renamed."
	exit

#if [ "x$mid$ext" = "" ] ; then
#	mid='jpg *JPG *jpeg *JPEG'
#fi

else
	ext=$1
	mid=$2
fi
#if [ x"$mid" = x ] ; then
#	mid='jpg *JPG *jpeg *JPEG'
#fi
#	img=$(echo $a | sed 's/\([[:digit:]]*[\._-][[:digit:]]*\)_\(IMG_[[:alnum:]]_[^\.]*\)\.\([[:alnum:]]*\)/\2_\1_'"$Model"'\3/')
#	img=$(echo $a | sed 's/\([[:digit:]]*[\._-][[:digit:]]*\)_\(IMG_[[:alnum:]]_[^\.]*\)\.\([[:alnum:]]*\)/\2_\1_'"$Model"'\3/')
#	img=$(echo $a | sed 's/^\([^[:alpha:]]*\)\(IMG_[[:digit:]]*\)_*\([^\.]*\)\.\([[:alnum:]]*\)/\2_\1_\3_'$Model'.\4/')
#	s/\([[:digit:]]*[\._-][[:digit:]]*\)_\(IMG_[[:alnum:]]_[^\.]*\)\.\([[:alnum:]]*\)/\2_\1_'"$Model"'\3/
#		filesize=$(stat -f '%z' "$FileName") # maybe quicker way to get file size, but in bytes
#			Aperture=$(exiftool -H -s a -u -g1 -q -q -p '$Aperture' "$FileName")

echo mid="$mid"'<  'ext="$ext"'<'

ls -1 *${mid}*${ext} | \
while read filename ; do
#	exiftool -H -s -a -u -g1 -q -q -f -p '${Model}~${ProfileDescriptionML}~${Aperture}~${ImageSize}~${FileType}~${DateTimeOriginal}~${CreateDate}~${FileModifyDate}~${FileSize}~${MediaDuration}~${BitDepth}~${AvgBitrate}~${VideoFrameRate}~${AudioBitsPerSample}~${AudioSampleRate}~${AudioFormat}' "$filename" | \
#	while read Model modelprofile Aperture imgsize FileType imgdate CreateDate FileModifyDate filesize MediaDuration BitDepth AvgBitrate VideoFrameRate AudioBitsPerSample AudioSampleRate AudioFormat ; do
	exiftool -H -s -a -u -g1:2 -q -q -f -FileName -Model -ProfileDescriptionML -Aperture -ImageSize -FileType -DateTimeOriginal -CreateDate -FileModifyDate -FileSize -MediaDuration -BitDepth -AvgBitrate -VideoFrameRate -AudioBitsPerSample -AudioSampleRate -AudioFormat "$filename"
	IFS_save="$IFS"
	IFS="~"
	exiftool -H -s -a -u -g1 -q -q -f -d '%Y%m%d.%H%M%S' -p '${Model}~${ProfileDescriptionML}~${Aperture}~${ImageSize}~${FileType}~${DateTimeOriginal}~${CreateDate}~${FileModifyDate}~${FileSize}~${MediaDuration}~${BitDepth}~${AvgBitrate}~${VideoFrameRate}~${AudioBitsPerSample}~${AudioSampleRate}~${AudioFormat}' "$filename" | \
	while read -r -a info ; do
		for (( i in {0..${#info[*]}} ; do
			echo 'info['$i']='$info[$i]
		done
		echo $info[*]
		exit
		echo "Vars: $Model $modelprofile $Aperture $imgsize $FileType $imgdate $CreateDate $FileModifyDate $filesize $MediaDuration $BitDepth $AvgBitrate $VideoFrameRate $AudioBitsPerSample $AudioSampleRate $AudioFormat"
		imgno=$(echo "$FileName" | sed 's/^\(.*\)\..*$/\1/') # strip extension for files with no IMG no.
		echo imgno from filename: '>'"$imgno"'<'
		imgno=$(echo "$imgno" | sed 's/^.*\([IiMm][MmVv][GgIi]\)[-_]\([[:digit:]]*\).*$/\2/')
		echo imgno from imgno: '>'"$imgno"'<'
		imgno="${imgno// /_}" # imgno captures text in FileName if there is no IMG number.
		echo imgno spaces replaced: '>'"$imgno"'<'
		imgtyp=$(echo "$imgno" | sed 's/^.*\([IiMm][MmVv][GgIi]\)[-_]\([[:digit:]]*\).*$/\1/')
		echo imgtype: '>'"$imgtype"'<'
		if [ x$imgtype = x$FileType ] ; then
			echo match
		else
			echo imgtype=$imgtype FileType=$FileType
		fi
		extn="$FileType"
#		extn=$(echo "$FileName" | sed 's/.*\.//' | tr '[:lower:]' '[:upper:]')
		hash=$(shasum 256 "$FileName" 2>/dev/null | sed 's/\([[:alnum:]]*\).*/\1/')
#		if Model is - try -ProfileDescriptionML
#		-FileModifyDate if date is -
		if [ x$Model = x- ] ; then
#			Model="$(exiftool -s3 -a -u -q -q -f -p '${ProfileDescriptionML}')"
			Model="$modelprofile"
		fi
		Model="${Model// /_}"
#		imgdate="${imgdate//x/}"
		filesize="${filesize// /}"
		MediaDuration="${MediaDuration// /}"
#		filesize="${filesize//x/}"
		imgsize="${imgsize// /}"
#		imgsize="${imgsize//j/}"
		if [ x$Model = xiPod_touch ] ; then
			Model=iPod_touch_f"$Aperture"
		elif [ x$Model = x- ] ; then
			Model=unknown
		fi
		if [ x$imgdate = x- ] ; then
			imgdate="$CreateDate"
		fi
		if [ x$imgdate = x- ] ; then
			imgdate="$FileModifyDate"
		fi
		newname="${Model}_IMG_${imgno}_${imgsize}_${MediaDuration}_${BitDepth}_${AvgBitrate}_${VideoFrameRate}_${AudioBitsPerSample}_${AudioSampleRate}_${AudioFormat}_${filesize}_${imgdate}_${hash}.$extn"
		newname=$(echo "$newname" | sed 's/_\-_/_/g ; s/ //')
		ser=0
		if [ "x$newname" = "x$FileName" ] ; then
			echo "$FileName" --- "$newname     Nothing to do."
		else
			while [ -e "$newname" ] ; do
				(( ser++ ))
				newname="${Model}_IMG_${imgno}_${imgsize}_${filesize}_${imgdate}_${hash}_${ser}.$extn"
			done
			if [ x$execute = xgo ] ; then
				mv -v "$FileName" "$newname"
			else
#				echo $FileName"  Model="$Model"  imgdate="$imgdate"   imgno="$imgno"   FileNamedate="$FileNamedate"   Aperture"=$Aperture"  newname="$newname
				echo "$FileName $imgdate -- $imgsize -- $filesize -- $newname"
				echo $FileName" Model="$Model" modelprofile="$modelprofile" imgno="$imgno" Aperture"=$Aperture
				echo $FileName" imgdate="$imgdate" CreateDate="$CreateDate" FileModifyDate="$FileModifyDate
				echo $FileName" MediaDuration="$MediaDuration" FileType="$FileType" AvgBitrate="$AvgBitrate" BitDepth="$BitDepth" VideoFrameRate="$VideoFrameRate" AudioBitsPerSample="$AudioBitsPerSample" AudioSampleRate"=$AudioSampleRate" AudioFormat="$AudioFormat
#				echo "$FileName -- $newname" ${VideoFrameRate}~${AudioBitsPerSample}~${AudioSampleRate}~${AudioFormat}
			fi
		fi
		IFS="$IFS_save"
	done
done
