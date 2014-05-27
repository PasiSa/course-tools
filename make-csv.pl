#!/usr/bin/perl
#
# Usage:
# ./make-csv.pl <oodifile>

my $modules = 6;
my $oodifile = $ARGV[0];

use POSIX qw(strftime);

my $timestamp = strftime "%Y-%m-%d %H:%M", localtime;

my @count;
my @pct50;
my @numtasks;
my @alldone;
my %line;
my %upoints;
my %accepted;

$numtasks[1] = 10;
$numtasks[2] = 12;
$numtasks[3] = 15;
$numtasks[4] = 13;
$numtasks[5] = 13;
$numtasks[6] = 12;

for ($i = 1; $i <= $modules; $i++) {
  my $fname = sprintf("module-%d.csv", $i);
	open(FILE, "<", $fname);
	while (<FILE>) {
		@fields = split(',', $_);
		my $points = $fields[1] + ($fields[2] - $fields[1]) * 0.5;
		#printf("<tr class=\"student\"> ");
		#printf("<td>%s</td> ", $fields[0]);
		if ($i == 1) {
		  $line{$fields[0]} = "";
		  $upoints{$fields[0]} = 0;
		}

		if ($fields[2] > 0) {
			$count[$i]++;
		}
		#printf("fields[2]:%d   pct60:%f\n", $fields[2], $a);
		my $acc = 1;
		if ($fields[2] >= $numtasks[$i] * 0.6) {
			$pct60[$i]++;
			$accepted{$fields[0]}++;
		} else {
		  $acc = 0;
		}

		if ($fields[2] >= $numtasks[$i]) {
			$alldone[$i]++;
		}

		# Concatenate point data for one module for this student
		# there is a separate $line item for each student

		$ll = sprintf("%.1f;%d;", $points, $acc);

		$line{$fields[0]} = $line{$fields[0]} . $ll;
		$upoints{$fields[0]} += $points;

	}
}

open(FILE, "<", $oodifile);
while(<FILE>) {
  chomp;

  # remove Windows CR
  $_ =~ s/\r//g;

  @fields = split(';', $_);

  my $acc = 0;
  if ($accepted{$fields[0]} >= 5) {
    $acc = 1;
  }

  printf("%s;%s;%s", $fields[0], $fields[1], $fields[2]);

  # semicolon included at the end of $line
  if (length($line{$fields[0]}) > 5) {
    printf(";%s%d\n", $line{$fields[0]}, $acc);
  } else {
    # for people who are in Oodi but never showed up on TMC
    printf(";0;0;0;0;0;0;0;0;0;0;0;0;0\n");
  }
}
