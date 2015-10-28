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

# My Courses points
f = open(sys.argv[2], "r")
for line in f:
    fields = line.rstrip().replace(",", ";").split(";")
    stline[fields[0]] = ""
    for i in fields[0:len(fields)]:
        stline[fields[0]] = stline[fields[0]] + i + ";"
    
f = open(sys.argv[1], "r")
for line in f:
    fields = line.replace(",", ";").split(";")
    k = fields[0].strip('\"')
    if k in stline:
        print line.rstrip() + ";" + stline[k]
