$|=1;

die "no file" if ($ARGV[0] =~ /^\s*$/);

die "error opening file: $!\n" if (!open(A, $ARGV[0]));

@all = <A>;

$i=0;
foreach $a (@all) {
	$i++;
	($num, $url, $ip, $ptr, $sp, $s) = split(/\t/, $a);
	chomp($s);
	chomp($s);
	if ($s =~ /^Server:/) {
		$s =~ s/^Server:\s*//;
	}
	$s =~ s/^([^\s\/]*).*/$1/;
	#$s = (split(/\/|\s/, $s))[0];
	$s =~ s/\"//g;
	if ($i <= 100) { $top100{$s}++; }
	if ($i <= 1000) { $top1000{$s}++; }
	if ($i <= 5000) { $top5000{$s}++; }
	if ($i <= 10000) { $top10000{$s}++; }
	if ($i <= 50000) { $top50000{$s}++; }
	if ($i <= 100000) { $top100000{$s}++; }
	$top500000{$s}++; 
}

@top100 = sort { $top100{$b} <=> $top100{$a} } keys %top100;
@top1000 = sort { $top1000{$b} <=> $top1000{$a} } keys %top1000;
@top5000 = sort { $top5000{$b} <=> $top5000{$a} } keys %top5000;
@top10000 = sort { $top10000{$b} <=> $top10000{$a} } keys %top10000;
@top50000 = sort { $top50000{$b} <=> $top50000{$a} } keys %top50000;
@top100000 = sort { $top100000{$b} <=> $top100000{$a} } keys %top100000;
@top500000 = sort { $top500000{$b} <=> $top500000{$a} } keys %top500000;

foreach $t ("apache") {
	if ($t !~ /^\s*$/) { print "$t\t",$top100{$t},"\t",$top1000{$t},"\t",$top5000{$t},"\t",$top10000{$t},"\t",$top50000{$t},"\t",$top100000{$t},"\t",$top500000{$t},"\n"; }
}

exit;

$top = 100;

print '
var ws = [
';

print '
	{
	    "keys": [ 100 ],
		"data": [
';

foreach $t (1..$top) {
	$ws = $top100[$t];
    if ($ws =~ /^\s*$/ || $ws =~ /\"\"/) { next; }
	$ws100 = $top100{$ws};

	print '            { "name": "',$ws,'","values": [ ',$ws100," ] },\n";
}

print '
        ]
    },
	{
	    "keys": [ 100, 1000 ],
		"data": [
';

foreach $t (1..$top) {
	$ws = $top1000[$t];
    if ($ws =~ /^\s*$/ || $ws =~ /\"\"/) { next; }
	$ws100 = $top100{$ws};
	$ws1000 = $top1000{$ws} - $top100{$ws};

	print '            { "name": "',$ws,'","values": [ ',($ws100 || 0),", ",($ws1000 || 0)," ] },\n";
}

print '
        ]
    },
	{
	    "keys": [ 100, 1000, 5000 ],
		"data": [
';

foreach $t (1..$top) {
	$ws = $top5000[$t];
    if ($ws =~ /^\s*$/ || $ws =~ /\"\"/) { next; }
	$ws100 = $top100{$ws};
	$ws1000 = $top1000{$ws} - $top100{$ws};
	$ws5000 = $top5000{$ws} - $top1000{$ws};

	print '            { "name": "',$ws,'","values": [ ',($ws100 || 0),", ",($ws1000 || 0),", ",($ws5000 || 0)," ] },\n";
}

print '
        ]
    },
	{
	    "keys": [ 100, 1000, 5000, 10000 ],
		"data": [
';

foreach $t (1..$top) {
	$ws = $top10000[$t];
    if ($ws =~ /^\s*$/ || $ws =~ /\"\"/) { next; }
	$ws100 = $top100{$ws};
	$ws1000 = $top1000{$ws} - $top100{$ws};
	$ws5000 = $top5000{$ws} - $top1000{$ws};
	$ws10000 = $top10000{$ws} - $top5000{$ws};

	print '            { "name": "',$ws,'","values": [ ',($ws100 || 0),", ",($ws1000 || 0),", ",($ws5000 || 0),", ",($ws10000 || 0)," ] },\n";
}

print '
        ]
    },
    {
	    "keys": [ 100, 1000, 5000, 10000, 50000 ],
		"data": [
';

foreach $t (1..$top) {
	$ws = $top50000[$t];
    if ($ws =~ /^\s*$/ || $ws =~ /\"\"/) { next; }
	$ws100 = $top100{$ws};
	$ws1000 = $top1000{$ws} - $top100{$ws};
	$ws5000 = $top5000{$ws} - $top1000{$ws};
	$ws10000 = $top10000{$ws} - $top5000{$ws};
	$ws50000 = $top50000{$ws} - $top10000{$ws};

	print '            { "name": "',$ws,'","values": [ ',($ws100 || 0),", ",($ws1000 || 0),", ",($ws5000 || 0),", ",($ws10000 || 0),", ",($ws50000 || 0)," ] },\n";
}

print '
        ]
    },
	{
	    "keys": [ 100, 1000, 5000, 10000, 50000, 100000 ],
		"data": [
';

foreach $t (1..$top) {
	$ws = $top100000[$t];
    if ($ws =~ /^\s*$/ || $ws =~ /\"\"/) { next; }
	$ws100 = $top100{$ws};
	$ws1000 = $top1000{$ws} - $top100{$ws};
	$ws5000 = $top5000{$ws} - $top1000{$ws};
	$ws10000 = $top10000{$ws} - $top5000{$ws};
	$ws50000 = $top50000{$ws} - $top10000{$ws};
	$ws100000 = $top100000{$ws} - $top50000{$ws};

	print '            { "name": "',$ws,'","values": [ ',($ws100 || 0),", ",($ws1000 || 0),", ",($ws5000 || 0),", ",($ws10000 || 0),", ",($ws50000 || 0),", ",($ws100000 || 0)," ] },\n";
}

print '
        ]
    }
];
';
