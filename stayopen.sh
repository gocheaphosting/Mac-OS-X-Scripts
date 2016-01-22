#! stayopen for exiftool
# this loads exiftool, tells it to stay open, read commands from argfile,
# and ignore EOF. exiftool will close only when it reads a special command
# from argfile telling it everything is done; i.e.:
# write "−stay_open\nFalse\n" to ARGFILE when done.

argfile="$1"

exiftool −stay_open True −@ "$argfile"