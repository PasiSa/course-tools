#!/usr/bin/perl
#
# Usage: points.pl <full-points-file> <half-points-file> <module #>

open(FILEF, "<", $ARGV[0]);
open(FILEH, "<", $ARGV[1]);

my @ffull, @fhalf;
my $module = $ARGV[2];

while(<FILEH>) {
	chomp;
	@fhalf = split(',', $_);
  
	# Find the title row in full points file
	if ($fhalf[0] =~ m/"(.*)"/) {
		if ($1 eq "Username") {
			@titles = @fhalf;
			next;
		}

		seek(FILEF, 0, SEEK_SET);
		# Line parsed from half points, find corresponding line in full points
		# Remember: half-set should be a superset of full-set
		do {
			my $line = <FILEF>;
			chomp $line;
			@ffull = split(',', $line);
		} while(($ffull[0] ne $fhalf[0]) && !(eof FILEF));

		if ($ffull[0] ne $fhalf[0]) {
		  $ffull[$module] = 0;
		}

		#printf("UserId: %s / %s  -- Points mod 1: %s / %s\n",
		#$fields[0], $ffull[0], $fields[1], $ffull[1]);
		$fhalf[0] =~ s/"//g;
		$fhalf[$module] =~ s/"//g;
		$ffull[$module] =~ s/"//g;
		printf("%s,%s,%s\n", $fhalf[0], $ffull[$module], $fhalf[$module]);
	}
}
