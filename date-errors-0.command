#!/bin/bash

cat errors 						| \
grep -Eiv "(none)|(archived)" 				| \
sed 's/ <.*// ; s/^Date Error: // ; s/ \.\/.*//' 	| \
sort 							| \
uniq > date-errors-0

echo
echo date-errors-0
echo
cat date-errors-0
