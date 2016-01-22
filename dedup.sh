#!/bin/sh

CWD=`pwd`
SORTING=/tmp/sorting
OUTPUT=/tmp/filesfound
DELETE=/tmp/delete
DUPLICATE_DIR=~/duplicates
COUNT=0
F_COUNT=0
DIR_COUNT=0
EXT_COUNT=1

##################################################################
	if [ ! -d $DUPLICATE_DIR ]; then
		mkdir -p $DUPLICATE_DIR
	fi

##################################################################
# remove any previous output files
	rm -rf $OUTPUT
	rm -rf $SORTING
	rm -rf $DELETE

##################################################################
echo
echo "Duplicate Image Finder"
echo
echo "Press enter for current directory"
echo "Or enter directory path to scan: "
read ANSWER
if [ "$ANSWER" == "" ]; then
	ANSWER="$CWD"
fi

##################################################################

# find images
find $ANSWER -type f -name '*.[Jj][Pp][Gg]' >> $SORTING

IMAGES_TO_FIND=`cat $SORTING`
	for x in $IMAGES_TO_FIND; do 	# generate a md5sum value and sort each file found and add it to the output file
		COUNT=$(($COUNT + 1 ))
		MD5SUM=`md5sum $x | awk '{print $1}'`
		echo $MD5SUM $x >> $OUTPUT
	done

##################################################################

# find duplicates in output file
cat $OUTPUT | sort | uniq -w 32 -d --all-repeated=separate | sed -n '/^$/{p;h;};/./{x;/./p;}' | awk '{print $2}' >> $DELETE

FILES_TO_DELETE=`cat $DELETE`
	for FILE in $FILES_TO_DELETE; do
		NAME=`basename $FILE`
		F_COUNT=$(($F_COUNT + 1 ))
			if [ ! -e $DUPLICATE_DIR/$NAME ]; then # check to se if file name exist in duplicate directory before trying to move
				mv $FILE $DUPLICATE_DIR
			else
				# if file exists strip the file extension so we can rename the file with a -1 to the end
				ORG_NAME=`basename $FILE | cut -d "." -f 1` # get the name and strip off the file extension
				FILE_EXT=`basename $FILE | cut -d "." -f 2` # get the file extension type
				NEW_NAME="$ORG_NAME-$EXT_COUNT.$FILE_EXT"
					while [ -e $DUPLICATE_DIR/$NEW_NAME ]; do
						EXT_COUNT=$(($EXT_COUNT + 1 ))
						NEW_NAME="$ORG_NAME-$EXT_COUNT.$FILE_EXT"
					done
				mv $FILE $DUPLICATE_DIR/$NEW_NAME
			fi
	done

##################################################################
# remove empty directories if they exist
EMPTY_DIR=`find $ANSWER -depth -type d -empty`
	for EMPTY in $EMPTY_DIR; do
		D_COUNT=$(($DIR_COUNT + 1 ))
		rm -rf $EMPTY
	done

echo "Number of Files Checked: $COUNT"
echo "Number of duplicate files deleted/moved: $F_COUNT"
echo "Number of empty directories deleted: $DIR_COUNT "

##################################################################
