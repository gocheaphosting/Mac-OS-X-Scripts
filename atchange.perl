#!/usr/bin/env perl
# by Jeff Haemer
#	and a tip o' the hat to Tom Schneider
#       who wrote the original version as a shell script

#  For current version and other information about this program, see:
#  http://alum.mit.edu/www/toms/atchange.html

# Thomas D. Schneider, Ph.D.
# National Institutes of Health
# National Cancer Institute
# Molecular Information Theory Group
# Frederick, Maryland  21702-1201
# schneidt@mail.nih.gov
# toms@alum.mit.edu (permanent)
# http://alum.mit.edu/www/toms (permanent)

#    version = 2.10 of atchange 2010 Jul 10
# 2010 Jun 23, 2.10: TDS standardized and upgraded documentation; adjust indents
# 2010 Jun 23, 2.091: Added support for globing in atchange file format.
#                     by Andr\'e R Brodtkorb, http://babrodtk.at.ifi.uio.no

#    version = 2.09 of atchange 2006 Mar 22
# 2006 Mar 22, 2.09: Remove the -w to avoid a warning message:
# Use of uninitialized value in numeric eq (==) at [path]atchange line 96.
#
# 2006 Mar 22, 2.08: change first line to #!/usr/bin/env perl -w
#     Formerly it was:
#!/usr/local/bin/perl
#     but that only worked on the Sun.  The new version should
#     work on Sun, Linux, Open BSD and Mac OSX.
#     The -w gives warnings, see
#     http://www.perl.com/pub/a/2002/05/07/mod_perl.html
# 1999 Dec 30, 2.07: functional!

# 1999 Dec 18:  Added shell call to /bin/csh so that
# atchange works under Linux.

# 1999 Feb 5: By setting the PERLCSH variable, the new shell can tell
#             it has been called by atchange.
# The test inside the .cshrc is:
#if ( (! $?PERLCSH ) && $?prompt) then 
#   stty erase '^H'
#   set prompt = "`uname -n` \!% "
#endif
# This is necessary under Sun Solaris 2.6 because otherwise the
# call to stty gives an error message now.

# previous change: 1997 Jan 9
# delay time is 0.25 seconds

# 1999 Dec 30:  James Haefner (jhaefner@biology.usu.edu)
# has found that some changes are needed to make atchange
# work under Linux.  See the web site for details.
# This code will be revised when a good solution is found.

$0 =~ s(.*/)();			# basename
$usage = "usage: $0 filename cmd | $0 command_file";
@ARGV || die $usage;		# check for proper invocation

# This allows the .cshrc to know that atchange has called it:
$ENV{'PERLCSH'} = "TRUE";

# Haefner Suggestion 1999 Dec 18:
##if default SHELL is sh or csh or tcsh use the following line
###$shell = $ENV{"SHELL"} ? $ENV{"SHELL"} : "/bin/sh";
##if default SHELL is bash (eg, Linux) use the following line
# 1999 Dec 28 - this is not a good idea - untestable by me
# $shell = "/bin/csh";

$shell = $ENV{"SHELL"} ? $ENV{"SHELL"} : "/bin/sh";
open(SHELL, "|$shell") || die "Can't pipe to $shell: $!";
select(SHELL); $| = 1;

if (@ARGV > 1) {		# it's a file and a command
	$file = shift;				# peel off the filename
	$cmd{$file} = join(" ", @ARGV) . "\n";	#	and the command
	$old{$file} = (stat($file))[9];	# mod time.
} else {			# it's a program
	open(PGM, shift) || die "Can't open $_: $!";
	$/ = "";			# paragraph mode
	while(<PGM>) {			# first read the program
		s/#.*\n/\n/g;
		($file_string, $cmd) = /(\S*)\s+([^\000]+)/;
                @files = glob($file_string);
                foreach $file (@files) {
		   $cmd{$file} = $cmd;
		   unless ($file) { print $cmd{$file}; next; }
		   if ($file && ! $cmd{$file}) { warn "odd line"; next; };
		   $old{$file} = (stat($file))[9];	# mod time.
                }
	}
}

while(1) {
	# sleep 1;		# wait a second, then
	select(undef, undef, undef, 0.25); # wait a quarter second, then
	foreach (keys %cmd) {	#	rip through the whole list
		atchange($_);
	}
}
close(SHELL);

sub atchange {		# if $file has changed, do $cmd{$file}
	my($file) = @_;
	my($new);

	$new = (stat($file))[9];
	return 0 if ($old{$file} == $new);
	while (1) {			# wait until it stops changing
		$old{$file} = $new;
		sleep 1;
		$new = (stat($file))[9];
		if ($old{$file} == $new) {
			print $cmd{$file};
			return 1;
		}
	}
}

