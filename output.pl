#!/usr/bin/perl
#
# Usage:
# ./output.pl <modules>

my $modules = $ARGV[0];

use POSIX qw(strftime);

my $timestamp = strftime "%Y-%m-%d %H:%M", localtime;

print <<END;
<html>
<head>
<meta charset='utf-8'>
<meta content='width=device-width, initial-scale=1, maximum-scale=1' name='viewport'>
<title>C programming - weighed exercise points</title>
<link href="main.css" media="screen" rel="stylesheet" type="text/css" />
<link href="bootstrap.css" media="screen" rel="stylesheet" type="text/css" />
</head>

<body class='default'>
<div class="scrollable">
<h1>Weighed exercise points</h1>
END

printf("<b>Updated:</b> %s<br/>\n", $timestamp);

print <<END;
<b>Full:</b> number of exercises done before the primary deadline for full points<br/>
<b>Half:</b> number of exercises done after the primary deadline, before Module closed<br/>
<b>Points:</b> Full + Half / 2<br/>
  <table class="points">
    <thead>
      <tr>
        <th></th>
END

for ($i = 1; $i <= $modules; $i++) {
  printf("<th colspan=\"3\">Module %d</th> ", $i);
}

print <<END;
          <th></th>
      </tr>
      <tr class="table-totals">
        <td>Student</td>
END

for ($i = 0; $i < $modules; $i++) {
  printf("<td>Full</td> <td>Half</td> <td>Points</td>");
}
          
print <<END;
          <td>
            Total
          </td>
      </tr>
    </thead>
	<tbody>	  
END

my @count;
my @pct50;
my @numtasks;
my @alldone;
my %line;
my %upoints;

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
		$ll = sprintf("<td>%d</td> <td>%d</td> <td>%.1f</td> ", $fields[1], $fields[2] - $fields[1], $points);
		$line{$fields[0]} = $line{$fields[0]} . $ll;
		$upoints{$fields[0]} += $points;
		#printf("<td>%.1f</td>", $points);
		#printf("<td>%.1f</td></tr>\n", $points);

		if ($fields[2] > 0) {
			$count[$i]++;
		}
		#printf("fields[2]:%d   pct60:%f\n", $fields[2], $a);
		if ($fields[2] >= $numtasks[$i] * 0.6) {
			$pct60[$i]++;
		}
		if ($fields[2] >= $numtasks[$i]) {
			$alldone[$i]++;
		}
	}
}

open(FILE, "<", "module-1.csv");
while(<FILE>) {
  @fields = split(',', $_);
  printf("<tr class=\"student\"> ");
  printf("<td>%s</td> ", $fields[0]);
  printf("%s", $line{$fields[0]});
  printf("<td>%.1f</td></tr>\n", $upoints{$fields[0]});
}

printf("<tr> <td></td> ");
for ($i = 1; $i <= $modules; $i++) {
  printf("<td colspan=\"3\">\n");
  printf("at least one: %d<br/>\n", $count[$i]);
  printf("at least 60%: %d<br/>\n", $pct60[$i]);
  printf("all done: %d\n", $alldone[$i]);
  printf("</td> ");
}
printf("<td></td> </tr> ");

print <<END;
    </tbody>
  </table>
</div>
</body>
</html>
END
