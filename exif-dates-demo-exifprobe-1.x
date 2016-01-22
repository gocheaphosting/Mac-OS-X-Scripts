#!/bin/bash -e
#filedate_format='+%y%m%d:%H%M%S'
search='(DateTime)'
align='s/\(.*\)\n\(.*\)/\1 \2/'
strip="s/[\'\:]//g ; s/.*\= ..// ; s/ /_/g"
sep1='zzz'
sep='  '
statformat='+%y'"$sep1"'%z'"$sep1"'%x'"$sep1"
strip2='s/[\-\:]// ; s/ /:/g ; s/\.,*//g ; s/'"$sep1"'/'"$sep"'/g'
format0='%-13s'"$sep"
head='-------------  '
format1='%-40s'
header='----------------------------------------'
format2="$format0$format0$format0$format0$format0$format0"
format="$format2$format1"'\n'
line="$head$head$head$head$head$head$header"
if [ "x$1" = "x" ] ; then
	echo Missing a filename.
	exit 1
fi
printf "$format2" '0x9004'  '0x9003'   '0x0132'
printf "$format2" 'Created' 'Original' 'Modified' 'mtime' 'ctime' 'atime' 'File Name'
echo "$line"
for i in $@ ; do
	FileDate="$(date -r "$i" "$filedate_format")"
	printf "$format" $(exifprobe -c -L -pl "$i" | grep "$search" | sed "$strip"';'"$align") "$FileDate" $(stat --printf="$statformat" "$i" | sed "$strip2") "$i"
done
