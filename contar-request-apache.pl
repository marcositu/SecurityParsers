#!/bin/perl
## situ
if ( @ARGV != 1 ) {

    die "\nUso: $0 <file> \n\n"

      . "   <host>    Archivo de logs del apache\n"
      ;

}

$archivo= $ARGV[0];
chomp $archivo;

my %top_ten = ();
open(LOG,"<$archivo") or die "can't open $archivo: $!";
while(my $line = <LOG>){
   my ($ip) = $line =~ /^([^\s]+)/;
   $top_ten{$ip}++;
}
close(LOG);
my @top_list = map {"$_->[0] ($_->[1] requests)"}
               sort {$b->[1] <=> $a->[1]}
               map {[$_,$top_ten{$_}]} keys %top_ten;

for my $i (0..9) {
   print "@{[$i+1]}: $top_list[$i]\n";
}
