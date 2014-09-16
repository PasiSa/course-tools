#!/usr/bin/python
#
# Take exam scores from a file (containing with student data from Oodi),
# and add exercise points at the end of each line
#
# Example: ../git-tools/attach-exercises.py tentti-2014-08-25-pts-all.csv >work-ex-sum14.csv
# (tentti-2014-08-25-pts-all.csv produced with combine-pts.py)

import sys

# Number of available points in each module
numtasks = [ 10, 12, 15, 13, 13, 12 ]
stline = dict()
upoints = dict()
accepted = dict()

# Collect points from each module, as exctracted to separate file
for i in range(6):
    f = open("module-" + str(i+1) + ".csv", "r")
    for line in f:
        fields = line.split(',')
        points = int(fields[1]) + ((int(fields[2]) - int(fields[1])) * 0.5)
        if i == 0:
            stline[fields[0]] = ""
            upoints[fields[0]] = 0
            accepted[fields[0]] = 0

        acc = 1
        if (int(fields[2]) >= numtasks[i] * 0.6):
            accepted[fields[0]] += 1
        else:
            acc = 0

        stline[fields[0]] = stline[fields[0]] + str(points) + ";" + str(acc) + ";"
        upoints[fields[0]] += points

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
    
    acc = 0
    if accepted[fields[0]] >= 5:
        acc = 1
        
    print line.rstrip() + ";" + stline[fields[0]] + str(upoints[fields[0]]) + ";" + str(acc)
