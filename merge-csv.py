#!/usr/bin/python
#
# Generic script to merge two csv files based on first field
# (e.g. TMC points and exam evaluation)
#
# Example: ../git-tools/merge-csv.py tentti-2014-08-25-pts-all.csv exercises.csv
# (tentti-2014-08-25-pts-all.csv produced with combine-pts.py)
# (exercises.csv produced with points.py -c)

# Order is based on the first file, where second file is appended


import sys

# Number of available points in each module
stline = dict()

# In some cases fields are surrounded by double quotes
# Also tries to consider both ';' and ',' as field separator
f = open(sys.argv[2], "r")
for line in f:
    fields = line.rstrip().replace(",", ";").split(";")

    # ignore too short lines
    if len(fields) > 4:
        k = fields[0].strip('\"')
        stline[k] = ""
        for i in fields[0:len(fields)]:
            stline[k] = stline[k] + i.strip('\"') + ";"
    
f = open(sys.argv[1], "r")
for line in f:
    fields = line.replace(",", ";").split(";")

    # ignore too short lines
    if len(fields) > 4:
        k = fields[0].strip('\"')
        if k in stline:
            print line.rstrip() + ";" + stline[k]
