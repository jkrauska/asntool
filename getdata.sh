#!/bin/bash

# Safe mode
set -euo pipefail
IFS=$'\n\t'

# Get latest IPv4 to ASN data.
echo "--------------------------------------------------------------------"
echo "Getting IPv4 RIB"
pyasn_util_download.py --latest
rename -v -e "s/rib/current-ipv4-rib/" rib*.bz2
ipv4rib=`compgen -f current-ipv4-rib.*.bz2`

# Get latest IPv6 to ASN data.
echo "--------------------------------------------------------------------"
echo "Getting IPv6 RIB"
pyasn_util_download.py --latestv6
rename -v -e "s/rib/current-ipv6-rib/" rib*.bz2
ipv6rib=`compgen -f current-ipv6-rib.*.bz2`

# Convert to text
echo "--------------------------------------------------------------------"
echo "Converting IPv4 RIB to text"
pyasn_util_convert.py --single ${ipv4rib} ipv4-to-asn.txt
echo "--------------------------------------------------------------------"
echo "Converting IPv6 RIB to text"
pyasn_util_convert.py --single ${ipv6rib} ipv6-to-asn.txt

# Convert formatting
echo "--------------------------------------------------------------------"
echo "Converting text formats, filtering rfc1918 and sorting"
/opt/text-to-csv.py ipv4-to-asn.txt | sort -n > ipv4-asn-ip.csv
# ipv6 table doesn't show /128 for /128s (only keep ones with slash notation)
/opt/text-to-csv.py ipv6-to-asn.txt | grep '/' | sort -n > ipv6-asn-ip.csv

# Get current AS# to Name data
echo "--------------------------------------------------------------------"
echo "Getting ASNames"
pyasn_util_asnames.py > asnames.dict

# convert to tsv
echo "--------------------------------------------------------------------"
echo "Converting ASNames formats"
/opt/dict-to-tsv.py asnames.dict | sort -n > asn-to-name.tsv


echo "--------------------------------------------------------------------"
echo "Copy New Data"
# copy output
mydate=`date +"%Y-%m-%d"`
mkdir /data/${mydate}
cp *.csv *.tsv /data/${mydate}/.

echo "--------------------------------------------------------------------"
echo "Done"
