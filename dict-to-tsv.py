#!/usr/bin/python

"""Simple stupid dictionary to TSV tool"""

import sys
import ast # allows for safer raw python eval

with open(sys.argv[1], 'r') as f:
        s = f.read()
        data = ast.literal_eval(s)

for asn, values in data.iteritems():
	parse=values.split(',')

	# Country is last part, pull it off
	country=parse[-1].strip()

	# some asn names have lots of commas, so grab what you can
	name=','.join(parse[:-1]).strip()

	# some names may have LOTS of trailing commas?
	name=name.replace(',,','',200)

	# Output asnumber,"as name",countrycode
	print "AS%s\t\"%s\",%s" % (asn, name, country)
