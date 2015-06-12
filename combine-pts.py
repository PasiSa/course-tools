#!/usr/bin/python
#
# Collects the exams points from different files into combined CSV file that
# can be passed e.g. in Excel. The file names are given as command line arguments.
#
# Assumes that each file has indicated the task numbers in the beginning like this:
# --TEHT;1;2   (without hash, that causes the line to be ignored)
#
# Example: ../git-tools/combine-pts.py tentti-2014-08-25-pts-1-2.csv tentti-2014-08-25-pts-3-4.csv tentti-2014-08-25-pts-5.csv >testi

import sys

a = sys.argv.pop(0)

lname = dict()
ename = dict()
scores = dict()

for fname in sys.argv:
    f = open(fname, "r")
    for line in f:
        # Get rid of Mac/Win/Unix newlines
        line = line.rstrip('\r\n;,')
        if line.startswith('#'):
            continue
        arr = line.split(';')
        if arr[0] == "--TEHT":
            taskspec = arr
            continue

        if len(arr) < 3:
            continue
        
        id = arr[0]
        if id not in lname:
            lname[id] = arr[1]
            ename[id] = arr[2]
            scores[id] = [ -1, -1, -1, -1, -1 ]

        for i in range(3, len(arr)):
            # it is possible that some lines have too many fields
            # (compared to the initial line in the beginning).
            # print warning, but use the numbers nevertheless.
            if i - 2 >= len(taskspec):
                sys.stderr.write("Warning: " + fname + ": student " + id + " has unexpected nr of columns: " + line + "\n")
            else:
                scores[id][int(taskspec[i-2])-1] = arr[i]

# finally, output what we got, ordered by student id
for i in sorted(lname.keys()):
    scorestr = ""
    scorestr =  ";".join([str(x) for x in scores[i]] )
    scorestr = scorestr.replace("-1", "")
    print i + ";" + lname[i] + ";" + ename[i] + ";" + scorestr
    
