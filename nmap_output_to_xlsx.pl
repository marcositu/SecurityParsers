#!/usr/bin/perl
## Hay que instalar 2 modulos: Excel::Writer::XLSX y  Nmap::Parser

use Module::Load::Conditional qw[can_load check_install requires];
 
my $use_list = {
    'Nmap::Parser'    => undef,
    'Excel::Writer::XLSX' => undef,
};
 
if (can_load( modules => $use_list )) {
}
else {
   print '
   Failed loading Perl modules:
	- Nmap::Parser
	- Excel::Writer::XLSX
   
   For Windows prompt installation:
	- ppm install nmap-parser
	- ppm install excel-writer-xlsx
   
   ';
   exit (1);
}
 
use Nmap::Parser;
if ( @ARGV != 2 ) {

    print "\n\nUsage: nmap_output_xlsx <DIR WITH XML RESULTS> <REPORT NAME>\n\n Example: nmap_output_xlsx . test\n";
	exit(1);

}

## Variables
my $np = new Nmap::Parser;
my $dir = $ARGV[0];
my $reporte = $ARGV[1];
chomp $reporte;


## Escribiendo el Excel
use Excel::Writer::XLSX;
my $workbook  = Excel::Writer::XLSX->new("$reporte.xlsx");
my $worksheet = $workbook->add_worksheet();

##Colores primera fila.
my $format = $workbook->add_format();
    $format->set_bold();
    $format->set_color( 'white' );
	$format->set_bg_color('blue');
    $format->set_align( 'center' );
	$format->set_align( 'vcenter' );

$worksheet->set_row(0,30,$format);
$worksheet->set_column( 0, 8, 20);
$worksheet->autofilter( 'A1:H999999' );

## Contadores para las filas
$a = 0;
$b = 0;
$c = 0;
$d = 0;
$e = 0;
$f = 0;
$g = 0;
$h = 0;

## Agrego el nombre de las columnas
$worksheet->write( 0, 0, "Hostname");
$worksheet->write( 0, 1, "IP");
$worksheet->write( 0, 2, "Protocol");
$worksheet->write( 0, 3, "Port");
$worksheet->write( 0, 4, "State");
$worksheet->write( 0, 5, "Service");
$worksheet->write( 0, 6, "Banner");
$worksheet->write( 0, 7, "Information");

## Leo el directorio con os archivos XML
 @files = <$dir/*.xml>;

 
## Comienzo a escibir el excel
foreach $file (@files) {
$np->parsefile($file);

for my $host ($np->all_hosts()){
    for my $port ($host->tcp_ports()){
        my $service = $host->tcp_service($port);
        #print $host->hostname."|".$host->ipv4_addr()."|"."TCP"."|".$port."|".$host->tcp_port_state($port)."|".$service->name."|".$service->product."|".$service->version."\n";
        $worksheet->write( 1+$a, 0, $host->hostname );
        $a++;
        $worksheet->write( 1+$b, 1, $host->ipv4_addr() );
        $b++;
	$worksheet->write( 1+$c, 2, "TCP");
        $c++;
        $worksheet->write( 1+$d, 3, $port );
        $d++;
	$worksheet->write( 1+$e, 4, $host->tcp_port_state($port) );
        $e++;
 	$worksheet->write( 1+$f, 5, $service->name );
        $f++;     
	$worksheet->write( 1+$g, 6, $service->product);
        $g++;
	$worksheet->write( 1+$h, 7, $service->version );
        $h++;
        }
   
   for my $port ($host->udp_ports()){
        my $service = $host->udp_service($port);
        #print $host->hostname."|".$host->ipv4_addr()."|"."UDP"."|".$port."|".$host->tcp_port_state($port)."|".$service->name."|".$service->product."|".$service->version."\n";
        $worksheet->write( 1+$a, 0, $host->hostname );
        $a++;
        $worksheet->write( 1+$b, 1, $host->ipv4_addr() );
        $b++;
	$worksheet->write( 1+$c, 2, "UDP");
        $c++;
        $worksheet->write( 1+$d, 3, $port );
        $d++;
	$worksheet->write( 1+$e, 4, $host->udp_port_state($port) );
        $e++;
 	$worksheet->write( 1+$f, 5, $service->name );
        $f++;     
	$worksheet->write( 1+$g, 6, $service->product);
        $g++;
	$worksheet->write( 1+$h, 7, $service->version );
        $h++;
        }
}
}
print "==================================================================================\n";
print "Succeed! Please see: $reporte.xlsx\n";