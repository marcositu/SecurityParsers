#!/bin/sh
IFS=$'\n'
## Nos muestra los objetos duplicados en la zona
## sh objetos-duplicados-zonas.sh "zona" configuration.txt
function analize {
NOM=$1
ARCH=$2
for i in `grep -i -w "set address \"$NOM\"" $ARCH | awk '{print $5" "$6}'|sort`
do
CNT=`grep -i "set address \"$NOM\"" $ARCH | grep -i -w $i -c`
if [ "$CNT" -ge "2" ]
then
echo "$i|$CNT" 
fi
done
}
analize $1 $2 | uniq

