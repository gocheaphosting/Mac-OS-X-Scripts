#!/bin/bash

echo
echo date-errors-1
echo
cat date-errors-1

echo
echo Work:
echo

cat date-errors-1 | sed 's/\./\//g ; s/Dec - Wed // ; s/[SMTWFsmtwtf][UOEHRAuoehra][[:alpha:]]*\(day\)\?[[:punct:]]*/ / ; s/^ *// ; s/,//g' | \
while read i ; do
	printf "%-30s %-30s\n" "$i" "$(date -d "$i")"
done 2>date-errors-2.tmp
cat date-errors-2.tmp | sed 's/.*'\`'// ; s/[[:punct:]]*[[:space:]]*$//' > date-errors-2
rm date-errors-2.tmp

echo
echo date-errors-2
echo
cat date-errors-2
