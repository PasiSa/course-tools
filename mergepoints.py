#!/usr/bin/python
#
# Merge C project points from assistants into single sheet

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
        arr = line.split(";")
        ptsindex.append(arr)

# Reads one points csv file
#
# fname: tiedosto
# points: array to put points into
# idx: column index from csv file to read
def read_file(fname, points, idx):
    f = open(fname, "r")
    for line in f:
        line = line.rstrip('\r\n;')
        if line.startswith('#'):
            continue
        arr = line.split(";")
        student = arr[0].strip('\"')

        try:
            pts = float(arr[idx])
        except ValueError:
            continue
        except IndexError:
            continue

        points[student] = pts
        #if not points.has_key(student):
        #    points[student] = dict()
        
        #points[student][fname] = pts

#
#  Execution starts here
#
        
# Read index file for points tables
ptsindex = list()
read_index(ptsindex)

# Iterate through all exercise rounds
for i in ptsindex:
    read_file(i[0], points, int(i[1]))

for a in points.keys():
    print("{};{}".format(a, points[a]))
