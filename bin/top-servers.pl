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

foreach $t (@top500000[0..10]) {
	if ($t !~ /^\s*$/) { print "$t\t",$top100{$t},"\t",$top1000{$t},"\t",$top5000{$t},"\t",$top10000{$t},"\t",$top50000{$t},"\t",$top100000{$t},"\t",$top500000{$t},"\n"; }
}
