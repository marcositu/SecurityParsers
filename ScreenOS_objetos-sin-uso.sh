#!/bin/sh
## Nos muestra los objetos sin uso
## sh ScreenOS_objetos-sin-uso.sh "zona" configuration.txt
NOM=$1
ARCH=$2
for i in `grep -i -w "set address \"$NOM\"" $ARCH | awk -F\" '{print $4}'`
do
CNT=`grep -i -w $i -c $ARCH`
if [ "$CNT" -eq "1" ]
then
echo "unset address \"$NOM\" $i"
fi
done