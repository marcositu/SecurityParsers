#!/usr/bin/perl
#Obtengo todas las IPs de los equipos juniper, guardo todo en excel, columna y debajo la IP correspondiente
# 27/10/2012

### creo la variable con la fecha
use POSIX qw(strftime);
$fecha= strftime("%Y-%m-%d", localtime);


use Excel::Writer::XLSX;
 
my $workbook  = Excel::Writer::XLSX->new("$fecha-juniper.xlsx");
my $worksheet = $workbook->add_worksheet('Equipos');
$worksheet->set_tab_color( 'red' );
$worksheet->set_column( 0, 100, 20 );
##Formato para las columnas
my $header = $workbook->add_format();
$header->set_bold();
$header->set_size(12);
$header->set_color(0x09);
$header->set_align('center');
$header->set_fg_color(0x16);
$header->set_border(1);
$header->set_border_color ('black');

## Formato para las filas
my $row = $workbook->add_format();
$row->set_border(1);
$row->set_border_color ('black');

my $columna = 0;
 
opendir (DIR, '.');
while (my $file = readdir(DIR)) {
    next if not -f $file;             # saltar al siguiente si no es un archivo normal
 
    open(INPUT, $file) or die "ERROR: No puedo abrir $file: $!\n";
 
    while (my $linea = <INPUT>) {
			if ($linea =~ m/^.*RANCID.*\sjuniper/ ) {                       # si hay una 'juniper'
            my $fila = 0;
            $worksheet->write( $fila++, $columna, $file, $header );  # agregamos los nombres de las columanas, que son los nombres de los equipos
			print "Analizando - $file\n";
            seek INPUT, 0, 0;                               # volvemos al principio
            while (<INPUT>) {                               # ahora buscaremos IP
                if (m/^                address\s([0-9|\.].*)\//) {
                    $worksheet->write($fila++, $columna, $1, $row);
                }
            }
 
            $columna++;                # apuntamos a la siguiente columna
            last;                      # no hace falta seguir buscando más 'juniper'. Salimos del while
        }
    }
 
    close INPUT;
}
closedir DIR;