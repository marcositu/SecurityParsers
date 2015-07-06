#!/bin/bash
# ver IPs en googlemaps -> http://display-kml.appspot.com/
echo
echo Creando el archivo ver.kml con las IPs:
echo
IPS=$(cat access.log | grep -v -e 127.0.0.1 -e localhost -e 192.168| awk '{print $1;}'| sort -nr | uniq | grep -v ':')
echo "
<?xml version=\"1.0\" encoding=\"UTF-8\"?>
<kml xmlns=\"http://www.opengis.net/kml/2.2\">
  <Document>" >> ver.kml
for x in $IPS
do
L1=`geoiplookup -f GeoLiteCity.dat $x | cut -d "," -f 7 | sed 's/ //g'`
L2=`geoiplookup -f GeoLiteCity.dat $x | cut -d "," -f 6| sed 's/ //g'`
PAIS=`geoiplookup -f GeoLiteCity.dat $x | cut -d "," -f 2 | cut -d ":" -f 2|sed 's/ //g'`
echo "
<Placemark>
      <name>$x</name>
      <description>
        <![CDATA[
          <h1>PAIS=$PAIS</h1>
        ]]>
      </description>
      <Point>
        <coordinates>$L1,$L2</coordinates>
      </Point>
    </Placemark>" >> ver.kml
done
echo "
  </Document>
</kml>" >> ver.kml