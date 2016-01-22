#!/bin/bash

src=2
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

for i in st nd rd th ; do
	s="$s ; s/\([[:digit:]]\)$i/\1/"
done
s="${s:3}"

echo "Removing: $s"
echo

#cat date-errors"-$src" | sed 's/st// ; s/nd// ; s/rd// ; s/th//' | \
cat date-errors"-$src" | sed "$s" | \
while read i ; do
	printf "%-30s %-30s\n" "$i" "$(date -d "$i")"
done 2>date-errors"-$dst".tmp
cat date-errors"-$dst".tmp | sed 's/.*'\`'// ; s/[[:punct:]]*[[:space:]]*$//' > date-errors"-$dst"
rm date-errors"-$dst".tmp

echo
echo date-errors"-$dst"
echo
cat date-errors"-$dst"
