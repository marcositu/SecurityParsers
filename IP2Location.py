#!usr/bin/python
#Python Script that searches the country location for a given IP address. The search is carried out by querying an offline database.
#Under Windows platform must install win_inet_pton and patch geoip.py in order to import the module.
#@MMerianus
#2015

try:
    from geoip import geolite2
except ImportError:
    print '\nERROR - GeoLite2 module not found.\n'
    print 'You may get the library directly by executing:'
    print ' pip install python-geoip'
    print ' pip install python-geoip-geolite2\n'
    exit()
        
        
def geoLocateIp(ipAddress):
    try:
        ipResult = geolite2.lookup(ipAddress)
        allData = ipResult.get_info_dict()
        countries = re.search(r"en': u'.+?',",re.search(r"country(.*)",str(allData)).group())
        ipCountry = countries.group().replace("en': u'", '').replace("',", '')
        return ipCountry
    except:
        return 'ERROR - "%s" is not a valid public ip address.' % ipAddress
            
    
def writeOutputFile(ips, outputFileName):
    try:
        outputFileName = outputFileName.strip('.txt') + '_and_countries.csv'
        ipsOutput = open(outputFileName, 'w')
        ipsOutput.write('IP,Country\n')
        
        for ip in ips.split():
            ipsOutput.write(ip + ',' + geoLocateIp(ip))
            ipsOutput.write('\n')
        ipsOutput.close()
        print '\nJob Complete!. Please see the file %s\n' % outputFileName
    
    except:
        print 'ERROR - Could not write to output file.'
        exit()
    

import sys
import socket
import re
import os


if len(sys.argv) == 2:
    usrParam = str(sys.argv[1])

    if usrParam.endswith('.txt'):
        try:
            ips = open(usrParam).read()          
        except:
            print 'ERROR - Invalid input text file.'
            exit()
            
        writeOutputFile(ips, usrParam)  
        
    else:
        print 'The country location for %s is %s.-' % (usrParam, geoLocateIp(usrParam))
else:
	print 'Usage:'
	print 'IP2Location.py [IP Address] -> Gives the country location for a valid IP Address.'
	print 'IP2Location.py [Filename].txt -> Gives the country location for a valid list of IP Addresses stored within a line separated .txt file.'
    
	if os.name == 'nt':
		print '\nWARNING - Under Windows platform must install win_inet_pton and patch geoip.py in order to import the module.'    
         
    


