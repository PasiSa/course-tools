#!/usr/bin/python
#
# Merge TIM exam points into single sheet

import sys

points = { }

# Reads points index file (argv[1])
#
# indexfile has filename;index of points field
def read_index(ptsindex):
    f = open(sys.argv[1], "r")
    for line in f:
        line = line.rstrip('\r\n;')
        if line.startswith('#') or len(line) == 0:
            continue
        ptsindex.append(line)

# Reads one points csv file
#
# fname: tiedosto
# points: array to put points into
# idx: column index from csv file to read
def read_file(fname, points):
    f = open(fname, "r")
    for line in f:
        line = line.rstrip('\r\n;')
        if line.startswith('#'):
            continue
        arr = line.split(",")
        student = arr[1].strip('\"').lower()

        try:
            pts = float(arr[3])
        except ValueError:
            continue
        except IndexError:
            continue

        if not points.has_key(student):
            points[student] = dict()
        
        points[student]['points'] = pts

        
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
    
for a in points.keys():
    try:
        opnro = points[a]['opnro']
    except KeyError:
        opnro = '??????'
    print("{};{};{}".format(opnro, a, points[a]['points']))
