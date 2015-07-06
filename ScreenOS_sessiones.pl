# Analiza las sessiones obtenidas con 'get session' en ScreenOS 5.0
# Beta. Como todo lo de Gas
# GasFed Jan 2004

use Switch;

sub mostrar_hash {
	$source = shift;
	$arrayref = shift;
	$hashref = shift;

@$arrayref = sort keys %$hashref;
%listhash = %$hashref;
@$arrayref = sort {
                $hash{$b} <=> $hash{$a}
                } keys %listhash;

	print "\nProtocolo: $source\n\n";
	foreach $key (reverse sort { $listhash{$a} <=> $listhash{$b} } keys %listhash) {
        	printf "%4d\t%s\n", $listhash{$key}, $key;
	}
	$size=@$arrayref;
	printf "   -\n%4d\n", $size;

}

foreach (<STDIN>){
	next if /^\s*$/;    # skip blank lines
        @_=/([0-9]+)\(([0-9]+)\)\:([0-9\.]+)\/([0-9]+)->([0-9\.]+)\/([0-9]+),([0-9]+),([a-e0-9]+),([0-9]+),vlan ([0-9]+),tun ([0-9]+),vsd ([0-9]+),route ([0-9]+)/;
        if ($3, $4, $5, $6, $7) {
	        $ip_src = $3;
        	$port_src =$4;
	        $ip_dst = $5;
	        $port_dst = $6;
	        $proto = $7;
	        $mac_address = $8;
	        $vlan = $10;
	        $tun = $11;
	        $vsd = $12;
	        $route = $13;
        	switch ($proto) {
        		case 6  { $stack = "tcp_$vsd";  push @$stack, "$3\t->\t$5:$6"; }
        		case 17 { $stack = "udp_$vsd";  push @$stack, "$3\t->\t$5:$6";}
        		case 1  { $stack = "icmp_$vsd"; push @$stack, "$3\t->\t$5";}
        		else    { $stack = "misc_$vsd"; push @$stack, "$3\t->\t$5\t($proto)"; }
        	}
        	push @vsd, $vsd;
        }
}
@vsdlist = sort(grep { ! $seen{$_} ++ } @vsd);
foreach $vsd (@vsdlist) {
	print "\n\nvsd: $vsd\n";
	$stack = "tcp_$vsd" ; foreach $element (@$stack)  { $$stack{$element}++; }; 
	&mostrar_hash("TCP",\@$stack, \%$stack), if (@$stack);
	$stack = "udp_$vsd" ; foreach $element (@$stack)  { $$stack{$element}++; };
	&mostrar_hash("UDP",\@$stack, \%$stack), if (@$stack);
	$stack = "icmp_$vsd" ; foreach $element (@$stack)  { $$stack{$element}++; };
	&mostrar_hash("ICMP",\@$stack, \%$stack), if (@$stack);
	$stack = "misc_$vsd" ; foreach $element (@$stack)  { $$stack{$element}++; };
	&mostrar_hash("MISC",\@$stack, \%$stack), if (@$stack);
}

