
src="root@titan:/root/rsync/"
dest="/Volumes/mybook/rsync"

opts="$opts -h" # human-readable
opts="$opts""n" # dry run
opts="$opts""v" # verbose
opts="$opts""i" # itemize changes
opts="$opts""P" # --partial --progress
opts="$opts""a" # archive -rlptgoD
#opts="$opts""E" # copy extended attrs
opts="$opts""W" # copy files whole
#opts="$opts""A" # preserve ACLs
#opts="$opts""X" # preserve extended attributes
#opts="$opts""E" # preserve executability
opts="$opts --executability"       # preserve executability
opts="$opts --stats"               # output some performance stats
opts="$opts --log-file=rsync-log"           # set filename for log
opts="$opts --ignore-existing"     # do not clobber existing files
opts="$opts --remove-source-files" # remove source files
opts="$opts --numeric-ids"         # do not map map uid/gid values by user/group name

echo 
echo Executing rsync using "$opts ..."
echo

#opts="$opts -r" # recursive
#opts="$opts -l" # copy symlinks as symlinks
#opts="$opts -p" # preserve permissions
#opts="$opts -t" # preserve times
#opts="$opts -g" # preserve group
#opts="$opts -o" # preserve owner
#opts="$opts -D" # --devices --specials
#opts="$opts -u" # update; skip files that are newer on the receiver
# we will skip any existing file
#opts="$opts --chmod=755"              # change access rights
#opts="$opts""R" # use relative path names
#opts="$opts --partial"             # keep partially-transferred files
#opts="$opts --progress"            # show some progress updates
#opts="$opts --include="            # include files matching pattern

rsync $opts $src $dest
