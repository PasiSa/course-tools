#!/usr/bin/python
#
# Collect points from the TIM csv output
# Used on C++ course (fall 2016)
#
# Usage:
# ./collectpoints.py <indexfile> [oodi]
#
# 'oodi' includes only those who can be found in "osallistujat.csv"


from __future__ import print_function
import sys


points = { }

# Reads points index file (argv[1])
def read_index(ptsindex):
    f = open(sys.argv[1], "r")
    for line in f:
        line = line.rstrip('\r\n;')
        if line.startswith('#') or len(line) == 0:
            continue
        ptsindex.append(line)
#        print("testi: " + line)

        
# Reads one TIM-exported points csv file
def read_file(fname, points):
    f = open(fname, "r")
    for line in f:
        line = line.rstrip('\r\n;')
        if line.startswith('#'):
            continue
        arr = line.split(",")
        student = arr[1].strip('\"')

        try:
            pts = int(arr[3])
        except ValueError:
            continue

        if not points.has_key(student):
            points[student] = dict()
        
        points[student][fname] = pts


def read_oodi(fname, points):
    f = open(fname, "r")
    for line in f:
        line = line.rstrip('\r\n;')
        arr = line.split(";")
        student = arr[3]
        if not points.has_key(student):
            continue
        points[student]['opnro'] = arr[0]
        points[student]['lname'] = arr[1]
        points[student]['fname'] = arr[2]


#
#  Execution starts here
#
        
# Read index file for points tables
ptsindex = list()
read_index(ptsindex)

# Iterate through all exercise rounds
for i in ptsindex:
    read_file(i, points)

read_oodi('osallistujat.csv', points)

# Output everything
#order = [ 'opnro', 'lname', 'fname', 'm1', 'm2', 'm3', 'm4', 'ex' ]
order = [ 'opnro', 'lname', 'fname' ]
order.extend(ptsindex)

for a in points.keys():
    #print("{}: {}".format(a, points[a]))
    if len(sys.argv) > 2 and sys.argv[2] == "oodi":
        if not 'opnro' in points[a].keys() or len(points[a]['opnro']) == 0:
            continue
                
    for i in order:
        try:
            print(str(points[a][i]) + ",", end="")
        except KeyError:
            print(",", end="")

    # print also the key, i.e., email address
    print(a)
