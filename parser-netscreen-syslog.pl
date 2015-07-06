# Parseo de logs de netscreen
# Uso cat netscreen.txt | perl parser-netscreen-syslog.pl | sort | uniq 

while(<STDIN>){
	if ( ($_ =~ s/^\d{4}-(\d{2})-(\d{2})\s+(\d+)\:(\d+)\:(\d+)\s+\S+\s+(\S+)\s+\S+\:\s+NetScreen\s+device_id=\S+\s+//) || ($_ =~ s/^(\w+)\s+(\d+)\s+(\d+)\:(\d+)\:(\d+)\s+(\S+)\s+\S+\:\s+NetScreen\s+device_id=\S+\s+//)) {
		$MON = $1; 
		$DAY = $2;
		$HOUR = $3; 
		$MIN = $4; 
		$SEC = $5;
		$HOST = $6; 
		if ( $_ =~ s/^\[.+\](\w+-\w+-(\d{5})\(\w+\)):\s+//ox ) {
                    if ( $2 eq "00257" ) {
			if ( $_ =~ s/src=([\d\.]+)\s+//ox ) { $SADDR = $1; };
			if ( $_ =~ s/dst=([\d\.]+)\s+//ox ) { $DADDR = $1; };
			if ( $_ =~ s/src_port=(\d+)\s+//ox ) { $SPORT = $1; };
			if ( $_ =~ s/dst_port=(\d+)//ox ) { $DPORT = $1; };
			if ( $_ =~ s/policy_id=(\d+)\s+//ox ) { $RULE = $1; };
			if ( $_ =~ s/action=(\w+)\s+//ox ) { $ACTION = $1; };
			if ( $_ =~ s/proto=(\S+)\s+//ox ) { $PROTO = $1; };
			if ( $_ =~ s/service=(\S+)\s+//ox ) { $SERVICE = $1; };
			if ( $_ =~ s/src\szone=(\S+)\s+dst\szone=(\S+)//ox ) { $SZONE = $1; $DZONE = $2 };
			}
			print "$MON $DAY $HOUR:$MIN:$SEC - $SADDR ($SZONE) -> $DADDR ($DZONE) : $DPORT ($SERVICE)\n";
		}
	}
}


