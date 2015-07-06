# Parseo de logs de cisco-pix
# Uso cat asa.txt | perl parser-cisco-pix-syslog.pl | sort | uniq 
while(<STDIN>){
        if ( ($_ =~
s/(\w{3})\s+(\d+)\s+(\d+)\:(\d+)\:(\d+)\s+(\S+)\s+\w{3}\s+\d+\s+\d+\s+\S+\s+\S+\s+\:?\s+(\%ASA-(\d)-\d+):\saccess-list\s(.*)\spermitted\s(.*)cablevision\/(.*)(\([0-9]+\))\s->?.sucursales-cv\/(.*)\(([0-9]+)+\)\shit-cnt.*//))
{
                $SRC = $11;
                $DST = $13;
                $PORT = $14;
         if ( $PORT > 0 && $PORT <= 1024  ) {
    print "SRC=$SRC -> DST=$DST -> PORT=$PORT \n";
}       
}
}


