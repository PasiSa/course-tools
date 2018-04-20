#!/usr/bin/python
#
# Collects TIM feedback to a single CSV. Looks for files
# XX-difficulty.txt and XX-learning.txt, which are exported from TIM,
# from the respective parts of round feedback.
# XX is given as command line parameter, e.g.:
#
# collect-feedback.py 04
#
# CSV is provided to stdout.

import sys

def read_file(fname, param, table):
    f = open(fname, "r")
    student = ""
    score = -1
    for line in f:
        splitted = line.split(";")
        #print str(splitted)
        if len(splitted) > 2:
            student=splitted[1]
            score = -1
        else:
            try:
                score=int(line)
            except ValueError:
                # no operation
                pass

        if score >= 0:
            #print "stud: " + str(student) + "  point: " + str(score)
            if not table.has_key(student):
                table[student] = dict()
            table[student][param] = score
            score = -1
            
table = { }
read_file(sys.argv[1] + "-difficulty.txt", "diff", table)
read_file(sys.argv[1] + "-learning.txt", "learn", table)

for a in table.keys():
    try:
        sdiff = str(table[a]['diff'])
    except KeyError:
        sdiff = '-1'

    try:
        slearn = str(table[a]['learn'])
    except KeyError:
        slearn = '-1'
        
    print str(a) + ";" + sdiff + ";" + slearn
    
