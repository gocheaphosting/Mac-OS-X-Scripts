#!/bin/bash

src=4
(( dst = src + 1 ))

echo src=$src
echo dst=$dst

echo
echo date-errors"-$src"
echo
cat date-errors"-$src"

echo
echo Work:
echo

cat date-errors"-$src" | sed 's/^[[:space:]]*\([[:digit:]]\+\)[[:space:]]*\/[[:space:]]*\([[:digit:]]\+\)/\2\/\1/' | \
while read i ; do
	printf "%-30s %-30s\n" "$i" "$(date -d "$i")"
done 2>date-errors"-$dst".tmp
cat date-errors"-$dst".tmp | sed 's/.*'\`'// ; s/[[:punct:]]*[[:space:]]*$//' > date-errors"-$dst"
rm date-errors"-$dst".tmp

echo
echo date-errors"-$dst"
echo
cat date-errors"-$dst"
