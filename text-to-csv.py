#!/usr/bin/python

"""
Convert from IP\tASN to ASN,IP
"""
from IPy import IP

import fileinput
for line in fileinput.input():

    # skip comments
    if ';' in line: continue

    # split on tabs
    values = line.split("\t")

    # decode
    asn=values[1].strip()
    ip = IP(values[0])

    # Skip private IP space
    if ip.iptype() == 'PRIVATE':continue

    # output, ASN,IP
    print "%s,%s" %(asn, ip)
