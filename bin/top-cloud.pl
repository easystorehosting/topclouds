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

print "\t1000\t\tapache\tmicrosoft\tnginx\tothers\n";
foreach $t (1..20) {
	$site = $top1000[$t];
	print $site,"\t",$top1000{$site},"\t\t",$servers1000{$site}{apache},"\t",$servers1000{$site}{microsoft},"\t",$servers1000{$site}{nginx},"\t",$servers1000{$site}{others},"\n"; 
}
	
print "\n\t10000\t\tapache\tmicrosoft\tnginx\tothers\n";
foreach $t (1..20) {
	$site = $top10000[$t];
	print $site,"\t",$top10000{$site},"\t\t",$servers10000{$site}{apache},"\t",$servers10000{$site}{microsoft},"\t",$servers10000{$site}{nginx},"\t",$servers10000{$site}{others},"\n"; 
}
	
print "\n\t100\t1000\t5000\t10000\t50000\t100000\t\tapache\tmicrosoft\tnginx\tothers\n";
foreach $t (1..20) {
	$site = $top100000[$t];
	print $site,"\t",$top100{$site},"\t",$top1000{$site},"\t",$top5000{$site},"\t",$top10000{$site},"\t",$top50000{$site},"\t",$top100000{$site},"\t\t",$servers100000{$site}{apache},"\t",$servers100000{$site}{microsoft},"\t",$servers100000{$site}{nginx},"\t",$servers100000{$site}{others},"\n"; 
}
	
print "\n\t500000\t\tapache\tmicrosoft\tnginx\tothers\n";
foreach $t (0..100) {
	$site = $top500000[$t];
	print $site,"\t",$top500000{$site},"\t\t",$servers{$site}{apache},"\t",$servers{$site}{microsoft},"\t",$servers{$site}{nginx},"\t",$servers{$site}{others},"\n"; 
}
	
print "\n\n\t100\t1000\t5000\t10000\t50000\t100000\t500000\t\tapache\tmsft\tnginx\tothers\n";

#foreach $t ("rackspace.com", "amazonaws.com", "gogrid.net", "opsourcecloud.net", "linode.com", "softlayer.com", "savvis.net", "terremark.com", "hosting.com", "appengine.google.com") {
#foreach $t (splice(@top100000, 1, 10), "savvis.net", "terremark.com", "att.net") {
foreach $t (@top500000[1..20], "savvis.net", "att.net", "terremark.com", "verizonbusiness.com", "appengine.google.com", "venyu.com", "intermedia.net", "datapipe.com", "fusionstorm.com", "iland.com") {
	if ($t !~ /^\s*$/) { print "$t\t",$top100{$t},"\t",$top1000{$t},"\t",$top5000{$t},"\t",$top10000{$t},"\t",$top50000{$t},"\t",$top100000{$t},"\t",$top500000{$t},"\t\t",$servers{$t}{apache},"\t",$servers{$t}{microsoft},"\t",$servers{$t}{nginx},"\t",$servers{$t}{others},"\n"; }
}

print "\n\t100\t1000\t5000\t10000\t50000\t100000\t\tapache\tmicrosoft\tnginx\tothers\n";
foreach $t (1..20) {
	$site = $top100000[$t];
	$tc100 = $top100{$site};
	$tc1000 = $top1000{$site} - $top100{$site};
	$tc5000 = $top5000{$site} - $top1000{$site};
	$tc10000 = $top10000{$site} - $top5000{$site};
	$tc50000 = $top50000{$site} - $top10000{$site};
	$tc100000 = $top100000{$site} - $top50000{$site};




	print '{ "name": "',$site,'","values": [ ',$tc100,", ",$tc1000,", ",$tc5000,", ",$tc10000,", ",$tc50000,", ",$tc100000," ] },\n";
}
	
