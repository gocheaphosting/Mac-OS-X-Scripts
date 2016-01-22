#!/bin/bash

# writeImageDescription <filename>

file="$1"

description_tag=ImageDescription
      title_tag=DocumentTitle

if [ x"$1" = x ] ; then
	echo Missing a filename.
	exit 1
fi

 dirname=$(dirname $file)
basename=$(basename $file)

description=$dirname
      title=$basename

description0=$(exiftool -$description_tag -p \$$description_tag $file)
      title0=$(exiftool -$title_tag       -p \$$title_tag $file)

if [ x"$description0" = x ] ; then
	exit
fi

if [ x"$title0" = x ] ; then
	exit
fi

echo $dirname $filename

#echo $file $dirname $basename $title_tag=$title0 $description_tag=$description0 NewTitle=$basename NewDescription=$dirname

#echo "exiftool -$description_tag=$description $file"
#echo "exiftool       -$title_tag=$title       $file"


