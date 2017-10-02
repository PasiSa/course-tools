#!/usr/bin/python
#
# Attach Oodi information to file B based on Email
# Oodi information format: "studentnumber;lastname;firstname;email"
# File B can be anything semicolon separated, as long as email is the first field
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

        
# Reads one TIM-exported points csv file
def read_file(fname, points):
    f = open(fname, "r")
    for line in f:
        line = line.rstrip('\r\n;')
        if line.startswith('#'):
            continue
        arr = line.replace(",", ";").split(";")
        student = arr[0].strip('\"')
        #print(str(student))

        if not points.has_key(student):
            points[student] = dict()
        else:
            print(str(student) + " something wrong")

        points[student]['pts'] = arr
        #print(str(points[student]))


def read_oodi(fname, points):
    f = open(fname, "r")
    for line in f:
        line = line.rstrip('\r\n;')
        arr = line.split(";")
        student = arr[3]
        if not points.has_key(student):
            print(str(student) + " does not exist")
            continue
#        else:
#            print(str(student) + " found")

        points[student]['opnro'] = arr[0]
        points[student]['lname'] = arr[1]
        points[student]['fname'] = arr[2]


#
#  Execution starts here
#
        
# Read index file for points tables
ptsindex = list()
#read_index(ptsindex)

# Iterate through all exercise rounds
#for i in ptsindex:
#    read_file(i, points)

read_file(sys.argv[1], points)

read_oodi('osallistujat.csv', points)

# Output everything
order = [ 'opnro', 'lname', 'fname', 'pts' ]
#order.extend(ptsindex)

for a in points.keys():
    #print("{}: {}".format(a, points[a]))
#    if len(sys.argv) > 2 and sys.argv[2] == "oodi":
    if not 'opnro' in points[a].keys() or len(points[a]['opnro']) == 0:
        #print(str(a) + " no opnro")
        continue
                
    for i in order:
        try:
            if (i != 'pts'):
                print(str(points[a][i]) + ",", end="")
            else:
                for j in points[a][i]:
                    print(j + ",", end="")
                    
        except KeyError:
            print(",", end="")

    print()

    # print also the key, i.e., email address
    #print(a)
