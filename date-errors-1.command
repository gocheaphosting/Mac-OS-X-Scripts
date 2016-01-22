#!/bin/bash

cat date-errors-0 | \
while read i ; do
	printf "%-45s %-40s %-45s %s\n" "$i" "$(date -d "$i")"
done 2>date-errors-1.tmp

cat date-errors-1.tmp | sed 's/.*'\`'// ; s/[[:punct:]]*[[:space:]]*$//' > date-errors-1
rm date-errors-1.tmp

echo
echo date-errors-1
echo
cat date-errors-1
