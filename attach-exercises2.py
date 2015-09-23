#!/usr/bin/python
#
# Take exam scores from a file (containing with student data from Oodi),
# and add exercise points at the end of each line
#
# Example: ../git-tools/attach-exercises.py tentti-2014-08-25-pts-all.csv exercises.csv
# (tentti-2014-08-25-pts-all.csv produced with combine-pts.py)
# (exercises.csv produced with points.py -c)

import sys

# Number of available points in each module
stline = dict()
upoints = dict()
accepted = dict()

f = open(sys.argv[2], "r")
for line in f:
    fields = line.rstrip().split(';')
    stline[fields[0]] = ""
    for i in fields[1:len(fields)]:
        stline[fields[0]] = stline[fields[0]] + i + ";"
    

# Produce output file by taking the exam points and Oodi student data as basis
# Concatenate the exercise points at the end of lines with matching student ID
# (can be repeated multiple times, for example for combining summer and spring course)
f = open(sys.argv[1], "r")
for line in f:
    fields = line.split(';')
    # Exercises not done, fill matching number of zeros
    if fields[0] not in stline:
        print line.rstrip() + ";" + "0;0;0;0;0;0;0;0;0;0;0;0;0;0"
        continue
        
    print line.rstrip() + ";" + stline[fields[0]]
