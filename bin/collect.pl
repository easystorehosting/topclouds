require "arin.pl";

$|=1;

die "no file" if ($ARGV[0] =~ /^\s*$/);

die "error opening file: $!\n" if (!open(A, $ARGV[0]));

@top100k = <A>;

$count = 0;
foreach $a (@top100k) {
chop($a);
($num, $name) = split(/,|\t/, $a);

$url = "www.$name";
$ip = `host -s -W 2 -c IN $url |grep -m 1 "has address"`;
chop($ip);
$ip =~ s/.* has address (\d+\.\d+\.\d+\.\d+)/$1/;
$ptr = "";
$domain = "";
$arininfo = "";
if ($ip !~ /^\s*$/) {
	$ptr = `host -s -W 2 $ip |grep -m 1 "domain name pointer"`;
	chop($ptr);
	$ptr =~ s/^.* domain name pointer (.*)$/$1/;
	$ptr =~ s/\.$//;

	$ip_int = unpack("N",pack("C4",split(/\./,$ip))),"\n";

	OUTER: foreach $b (keys %arin) {

		INNER: foreach $c (@$b) {
		($begin, $end) = @$c;
		$begin_int = unpack("N",pack("C4",split(/\./,$begin))),"\n";
		$end_int = unpack("N",pack("C4",split(/\./,$end))),"\n";

		if ($ip_int >= $begin_int && $ip_int <= $end_int) {
		$arininfo = $arin{$b};
		last OUTER;
		}
		}
	}

	if ($arininfo =~ /^\s*$/) {
		$domain = $ptr;
		if ($ptr =~ /\.[a-z][a-z]$/) {
			$domain =~ s/.*\.([^\.]+\.[^\.]+\.[a-z][a-z])$/$1/;
		} else {
			$domain =~ s/.*\.([^\.]+\.[^\.]+)$/$1/;
		}

		$arininfo = $domain;
	}
}

$s = `curl --connect-timeout 5 --max-time 5 -I $url 2>/dev/null|grep "Server:"`;
chop($s);
$s =~ s/^Server: (.*)$/$1/;

print "$num\t$url\t$ip\t$ptr\t$arininfo\t$s\n";

$count++;
if ($count >2) {
sleep 1;
$count = 0;
}
}


