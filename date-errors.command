#!/bin/bash

cat errors 				| \
sed 's/^Date Error: // ; s/ \.\/.*//' 	| \
sort 					| \
uniq > date-errors

echo
echo date-errors
echo
cat date-errors
