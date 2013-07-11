$|=1;

die "no file" if ($ARGV[0] =~ /^\s*$/);

die "error opening file: $!\n" if (!open(A, $ARGV[0]));

@all = <A>;

$i=0;
foreach $a (@all) {
	$i++;
	chomp($a);
	chomp($a);

	($num, $url, $ip, $ptr, $sp, $s) = split(/\t/, $a);
	if ($i <= 100) { 
		$top100{$sp}++; 
		$servers100{$sp}{apache}++ if ($s =~ /apache/i);
		$servers100{$sp}{microsoft}++ if ($s =~ /microsoft/i);
		$servers100{$sp}{nginx}++ if ($s =~ /nginx/i);
		$servers100{$sp}{others}++ if ($s !~ /microsoft/i && $s !~ /apache/i && $s !~ /nginx/i);
	}

	if ($i <= 1000) { 
		$top1000{$sp}++; 
		$servers1000{$sp}{apache}++ if ($s =~ /apache/i);
		$servers1000{$sp}{microsoft}++ if ($s =~ /microsoft/i);
		$servers1000{$sp}{nginx}++ if ($s =~ /nginx/i);
		$servers1000{$sp}{others}++ if ($s !~ /microsoft/i && $s !~ /apache/i && $s !~ /nginx/i);
	}

	if ($i <= 5000) { 
		$top5000{$sp}++; 
		$servers5000{$sp}{apache}++ if ($s =~ /apache/i);
		$servers5000{$sp}{microsoft}++ if ($s =~ /microsoft/i);
		$servers5000{$sp}{nginx}++ if ($s =~ /nginx/i);
		$servers5000{$sp}{others}++ if ($s !~ /microsoft/i && $s !~ /apache/i && $s !~ /nginx/i);
	}

	if ($i <= 10000) { 
		$top10000{$sp}++; 
		$servers10000{$sp}{apache}++ if ($s =~ /apache/i);
		$servers10000{$sp}{microsoft}++ if ($s =~ /microsoft/i);
		$servers10000{$sp}{nginx}++ if ($s =~ /nginx/i);
		$servers10000{$sp}{others}++ if ($s !~ /microsoft/i && $s !~ /apache/i && $s !~ /nginx/i);
	}

	if ($i <= 50000) { 
		$top50000{$sp}++; 
		$servers50000{$sp}{apache}++ if ($s =~ /apache/i);
		$servers50000{$sp}{microsoft}++ if ($s =~ /microsoft/i);
		$servers50000{$sp}{nginx}++ if ($s =~ /nginx/i);
		$servers50000{$sp}{others}++ if ($s !~ /microsoft/i && $s !~ /apache/i && $s !~ /nginx/i);
	}

	if ($i <= 100000) { 
		$top100000{$sp}++; 
		$servers100000{$sp}{apache}++ if ($s =~ /apache/i);
		$servers100000{$sp}{microsoft}++ if ($s =~ /microsoft/i);
		$servers100000{$sp}{nginx}++ if ($s =~ /nginx/i);
		$servers100000{$sp}{others}++ if ($s !~ /microsoft/i && $s !~ /apache/i && $s !~ /nginx/i);
	}

	$top500000{$sp}++; 
	$servers{$sp}{apache}++ if ($s =~ /apache/i);
	$servers{$sp}{microsoft}++ if ($s =~ /microsoft/i);
	$servers{$sp}{nginx}++ if ($s =~ /nginx/i);
	$servers{$sp}{others}++ if ($s !~ /microsoft/i && $s !~ /apache/i && $s !~ /nginx/i);
}

@top100 = sort { $top100{$b} <=> $top100{$a} } keys %top100;
@top1000 = sort { $top1000{$b} <=> $top1000{$a} } keys %top1000;
@top5000 = sort { $top5000{$b} <=> $top5000{$a} } keys %top5000;
@top10000 = sort { $top10000{$b} <=> $top10000{$a} } keys %top10000;
@top50000 = sort { $top50000{$b} <=> $top50000{$a} } keys %top50000;
@top100000 = sort { $top100000{$b} <=> $top100000{$a} } keys %top100000;
@top500000 = sort { $top500000{$b} <=> $top500000{$a} } keys %top500000;

$top = 100;

print '
var tc = [
';

print '
	{
	    "keys": [ 100 ],
		"data": [
';

foreach $t (1..$top) {
	$site = $top100[$t];
	if ($site =~ /^\s*$/) { next; }
	$tc100 = $top100{$site};

	print '            { "name": "',$site,'","values": [ ',$tc100," ] },\n";
}

print '
        ]
    },
	{
	    "keys": [ 100, 1000 ],
		"data": [
';

foreach $t (1..$top) {
	$site = $top1000[$t];
	if ($site =~ /^\s*$/) { next; }
	$tc100 = $top100{$site};
	$tc1000 = $top1000{$site} - $top100{$site};

	print '            { "name": "',$site,'","values": [ ',($tc100 || 0),", ",($tc1000 || 0)," ] },\n";
}

print '
        ]
    },
	{
	    "keys": [ 100, 1000, 5000 ],
		"data": [
';

foreach $t (1..$top) {
	$site = $top5000[$t];
	if ($site =~ /^\s*$/) { next; }
	$tc100 = $top100{$site};
	$tc1000 = $top1000{$site} - $top100{$site};
	$tc5000 = $top5000{$site} - $top1000{$site};

	print '            { "name": "',$site,'","values": [ ',($tc100 || 0),", ",($tc1000 || 0),", ",($tc5000 || 0)," ] },\n";
}

print '
        ]
    },
	{
	    "keys": [ 100, 1000, 5000, 10000 ],
		"data": [
';

foreach $t (1..$top) {
	$site = $top10000[$t];
	if ($site =~ /^\s*$/) { next; }
	$tc100 = $top100{$site};
	$tc1000 = $top1000{$site} - $top100{$site};
	$tc5000 = $top5000{$site} - $top1000{$site};
	$tc10000 = $top10000{$site} - $top5000{$site};

	print '            { "name": "',$site,'","values": [ ',($tc100 || 0),", ",($tc1000 || 0),", ",($tc5000 || 0),", ",($tc10000 || 0)," ] },\n";
}

print '
        ]
    },
    {
	    "keys": [ 100, 1000, 5000, 10000, 50000 ],
		"data": [
';

foreach $t (1..$top) {
	$site = $top50000[$t];
	if ($site =~ /^\s*$/) { next; }
	$tc100 = $top100{$site};
	$tc1000 = $top1000{$site} - $top100{$site};
	$tc5000 = $top5000{$site} - $top1000{$site};
	$tc10000 = $top10000{$site} - $top5000{$site};
	$tc50000 = $top50000{$site} - $top10000{$site};

	print '            { "name": "',$site,'","values": [ ',($tc100 || 0),", ",($tc1000 || 0),", ",($tc5000 || 0),", ",($tc10000 || 0),", ",($tc50000 || 0)," ] },\n";
}

print '
        ]
    },
	{
	    "keys": [ 100, 1000, 5000, 10000, 50000, 100000 ],
		"data": [
';

foreach $t (1..$top) {
	$site = $top100000[$t];
	if ($site =~ /^\s*$/) { next; }
	$tc100 = $top100{$site};
	$tc1000 = $top1000{$site} - $top100{$site};
	$tc5000 = $top5000{$site} - $top1000{$site};
	$tc10000 = $top10000{$site} - $top5000{$site};
	$tc50000 = $top50000{$site} - $top10000{$site};
	$tc100000 = $top100000{$site} - $top50000{$site};

	print '            { "name": "',$site,'","values": [ ',($tc100 || 0),", ",($tc1000 || 0),", ",($tc5000 || 0),", ",($tc10000 || 0),", ",($tc50000 || 0),", ",($tc100000 || 0)," ] },\n";
}

print '
        ]
    }
];
';
