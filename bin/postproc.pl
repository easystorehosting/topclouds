require "./arin.pl";

$|=1;

die "no file" if ($ARGV[0] =~ /^\s*$/);

@allips = ();

for ($i = 0; $i < scalar(@arin); $i++) {
	$site = $arin[$i];
	($domain, $ips_ref) = @$site;
	@ips = @$ips_ref;

	for ($j = 0; $j < scalar(@ips); $j++) {
		$range = $ips[$j];
		($begin, $end) = @$range;
		$begin_int = unpack("N",pack("C4",split(/\./,$begin))),"\n";
		$end_int = unpack("N",pack("C4",split(/\./,$end))),"\n";
		push(@allips, [$domain, $begin_int, $end_int]);
	}
}

open(A, $ARGV[0]) || die "can't open file";

OUTER: while ($a = <A>) {
	next OUTER if ($a !~ /^[0-9]/);
	chomp($a);
	chomp($a);

	($num, $url, $ip, $ptr, $sp, $s) = split(/\t/, $a);
	if ($s =~ /^Server:/) { $s =~ s/^Server:\s*//; }
	$s =~ s/^([^\s\/]*).*/$1/;
	$s =~ tr/A-Z/a-z/;

	$ip_int = unpack("N",pack("C4",split(/\./,$ip))),"\n";

	foreach $b (@allips) {
		($domain, $begin, $end) = @$b;
		if ($ip_int >= $begin && $ip_int <= $end) {
			print "$num\t$url\t$ip\t$ptr\t$domain\t$s\t\n";
			next OUTER;
		}
	}

	$domain = $ptr;
	if ($domain =~ /\.(br|jp|uk|au|za|tr|cn|ul|pa|tw|cn|id|in|th|pl|ar|il)$/) {
		$domain =~ s/.*\.([^\.]+\.[^\.]+\.[a-z][a-z])$/$1/;
	} else {
		$domain =~ s/.*\.([^\.]+\.[^\.]+)$/$1/;
	}
	print "$num\t$url\t$ip\t$ptr\t$domain\t$s\n";
}
