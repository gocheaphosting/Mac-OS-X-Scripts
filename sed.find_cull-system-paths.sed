#!/usr/bin/sed -r -

# find_cull-system-paths

# Used to process output from find, it searched for lines containing the characteristic system paths,
# and simply drops them.

# Notes:

# uses POSIX.2 BRE (except for options causing too much system load)

# : specifies a label

# -r uses egrep-style regular expressions. In extended regex, ? + ( ) { } are special
# unless escaped with \. (whereas in basic regex, these chars are not special, unless escaped.)

# colon char ':' means 'label' here

# percent char % used below as delimiter to the regular expression - only for this line.
# avoids needing to escape the slashes.
# everything between the two % is the line mask.

\%[\W^]/sys[\W/$]|[\W^]/proc[\W/$]|[\W^]/lib[\W/$]|[\W^]/share[\W/$]|[\W^]/cache[\W/$]|[\W^]/dev[\W/$]/|[\W^]/mnt[\W/$]|[\W^]/media[\W/$]|[\W^]/home[\W/$]|[\W^]/boot[\W/$]|[\W^]/var/run[\W/$]% d
