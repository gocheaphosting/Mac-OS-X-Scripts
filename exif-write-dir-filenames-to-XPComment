#!/bin/bash
# exif-write-dir-filenames-to-XPComment
# For all files in working directory
# copy the working directory name and filename to EXIF XPComment.

################################################
# Constants
# title_tag=XPTitle
# comment_tag=XPComment
################################################
      program=exif-write-dir-filenames-to-XPComment
    title_tag=DocumentName
  comment_tag=ImageDescription
 keywords_tag=XPKeywords
  subject_tag=XPSubject
       fixdir=/home/bin/sed-stripdir
      fixname=/home/bin/sed-stripname
          pad='                    '
       bigpad="$pad$pad"
          bar='--------------------'
         line="$bar$bar$bar$bar"
      newline='
'
       spacer="$line$newline"
          dir="$(pwd)"
      comment=$( echo $dir | sed -f $fixdir )
################################################
echo "$line"
echo $program
echo "$line"
echo
echo $dir
echo
################################################
show-exif-comments *
echo
for i in * ; do
	title=$( echo $i | sed -f $fixname )
	echo "$line"
	echo "$bigpad"$i
	echo
	echo exiftool -S -P -q -$title_tag="$title" "$i"
	echo exiftool -S -P -q -$comment_tag="$comment" "$i"
done
echo
show-exif-comments *
#############################################################################################







