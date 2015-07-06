#!/usr/bin/perl -w
# Compruebo que este el modulo instalado
BEGIN {

    eval "use Net::DNS";

    if ( $@ ) {

        warn  "Error al cargar el modulo: Net::DNS\n"

        . "Instalar Modulo:\n"       

        . "\t\tcpan\n"

        . "\t\tcpan> install Net::DNS\n";

exit ();

 }

}
# Compruebe que este el argumento pasado
if ( @ARGV != 1 ) {

    die "\nUso: $0 <dominio> \n\n"

      . "   <dominio>  Dominio [ej -> dominio.com]\n"

      ;

}

$dominio= $ARGV[0];
chomp $dominio;

  use Net::DNS;
       $addr = shift || "$dominio";
    $res   = Net::DNS::Resolver->new;
    $query = $res->query($addr, "NS");

   if ($query) {
      foreach  $rr (grep { $_->type eq 'NS' } $query->answer) {
 push @archivos, $rr->nsdname;

      }
  }
  else {
      warn "query failed: ", $res->errorstring, "\n";
  }

$res = Net::DNS::Resolver->new( nameservers => [ @archivos ] );

my @zone = $res->axfr("$dominio");

if (@zone) {
    foreach my $rr (@zone) {
     $rr->print;
    }
}
else {
    print 'Zone transfer failed: ', $res->errorstring, "\n";
}

