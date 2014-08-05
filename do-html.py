#!/usr/bin/python
#
# ugly quick script that goes through all modules, and calculates points
# separating to half/full points
# Mainly used for summer-2014 course, where the rules are following
# * all exercises done by 2014-07-05 gain full points, after that half points
# ** except module 6, where all exercises gain full points


import sys
from subprocess import call

def usage():
    print "Usage: ./do-html.py <modules> <full-points> <half-points>"

if len(sys.argv) < 4 or not sys.argv[1].isdigit():
        usage()
        exit()

# make this environment variable
dir = "../git-tools/"
        
# Module 6 is all full points
for i in range(1, int(sys.argv[1])+1):
    f = open("module-" + str(i) + ".csv", "w")
    
    if i < 6:
        call([dir + "points.pl", sys.argv[2], sys.argv[3], str(i)], stdout=f)
    else:
        call([dir + "points.pl", sys.argv[3], sys.argv[3], str(i)], stdout=f)
        
# make the HTML version
f = open("points.html", "w")
call([dir + "output.pl", str(i)], stdout=f)
