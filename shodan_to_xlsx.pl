#!/usr/bin/env perl
# Author: achillean
# Modificado por @artssec
use Shodan::WebAPI;
use Module::Load::Conditional qw[can_load check_install requires];


my $use_list = {
    'Excel::Writer::XLSX' => undef,
};

if (can_load( modules => $use_list )) {
}
else {
   print '
   Failed loading Perl modules:
        - Excel::Writer::XLSX

   For Windows prompt installation:
        - ppm install excel-writer-xlsx

   ';
   exit (1);
}


if ( @ARGV != 2 ) {

    print "\n\nUsage: shodan-pl <LIST IP> <REPORT>\n\n Example: perl shodan.pl ips.txt shodan.xlsx\n";
        exit(1);

}

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
$worksheet->set_column( 0, 2, 20);
$worksheet->autofilter( 'A1:H999999' );

## Contadores para las filas
$a = 0;
$b = 0;

## Agrego el nombre de las columnas
$worksheet->write( 0, 0, "IP");
$worksheet->write( 0, 1, "PUERTO");


# Configuration
my $API_KEY = "xxxxxxxxxxx";

$api = new Shodan::WebAPI($API_KEY);

$file = $ARGV[0];
chomp $file;
open  $FILE, '<', $file or die $!;
@archivos = <$FILE>;

for  $archivo(@archivos){

#Lista de hosts
$host = $api->host("$archivo");
print "[+]$archivo";
$worksheet->write( 1+$a, 0, $archivo );
        $a++;

#Imprimo los puertos
@banners = @{ $host->{'data'} };
for ( $i = 0; $i < $#banners; $i++ ) {
push (@puerto,$banners[$i]{port});
}

#Borro los puertos duplicados de ese hosts
use List::MoreUtils qw(uniq);
@unique = uniq(@puerto);

#Limpio el array @puerto
undef @puerto;

for $siport (@unique) {
print  " [-]Puerto: $siport\n";
        $worksheet->write( 1+$b, 1, $siport );
        $b++;
}
}
