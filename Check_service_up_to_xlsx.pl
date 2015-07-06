#!/usr/bin/perl -w
use IO::Socket::PortState qw(check_ports);
use POSIX qw(strftime);
use Excel::Writer::XLSX;
my $hora= strftime("%Y-%m-%d", localtime);

if ( @ARGV != 2 ) {

    die "\nUso: $0 <servicio> <listaip>\n\n"
	  . "   <servicio>   Servicio a verificar -> 23\n"
      . "   <listaip>    Listado de direcciones IP -> ip.txt\n"
      ;

}

my $puerto= $ARGV[0];
chomp $puerto;

my $hostfile= $ARGV[1];
chomp $hostfile;

my $workbook  = Excel::Writer::XLSX->new("migracion_fw_servicio_tcp$puerto-$hora.xlsx");
my $worksheet = $workbook->add_worksheet( 'Servicios' );
$worksheet->set_tab_color( 'red' );
$worksheet->set_column( 0, 14, 20 );

##Iniciadores de las variables q corresponden a las columnas
my $m = 0;
my $n = 0;
my $l = 0;

## Formato para los nombres de las columnas
my $header = $workbook->add_format();
$header->set_bold();
$header->set_size(12);
$header->set_color(0x09);
$header->set_align('center');
$header->set_fg_color(0x16);
$header->set_border(1);
$header->set_border_color ('black');

## Nombre de las columnas del TAB vulnerabilities
my @columnas = qw(
    Host	Puerto	Estado

);

for(my $i = 0; $i < @columnas; $i++) {
    $worksheet->write( 0, $i, $columnas[$i], $header );
}

## Formato para las filas
my $files = $workbook->add_format();
$files->set_border(1);
$files->set_border_color ('black');

#Pruebas de servicios
print "#"  x 50 . "\n";
print "# Pruebas de conectividad #\n";
print "#"  x 50 . "\n";

my %port_hash = (
        tcp => {
            $puerto   => {},
            }
        );

my $timeout = 3;

open HOSTS, '<', $hostfile or die "crear el archivo $hostfile:$!\n";


while (my $host = <HOSTS>) {
    chomp $host;
    my $host_hr = check_ports($host,$timeout,\%port_hash);
    for my $port (sort {$a <=> $b} keys %{$host_hr->{tcp}}) {
        my $sino = $host_hr->{tcp}{$port}{open} ? "responde" : "no responde";
		$worksheet->write( 1+$m, 0, $host);
		$m++;
		$worksheet->write( 1+$n, 1, $port);
		$n++;
		$worksheet->write( 1+$l, 2, $sino);
		$l++;
        print "$host => puerto $port tcp -> $sino\n";
    }
    print "\n";
	sleep 1;
}
print "#"  x 50 . "\n";
print "Se creo el archivo servicio_tcp$puerto-$hora.xlsx\n";
print "#"  x 50 . "\n";
close HOSTS;