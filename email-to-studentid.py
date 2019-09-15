#!python3

import sys

def read_osallistujat(filename):
    f = open(filename, "r")
    os = {}
    for line in f:
        line = line.rstrip('\r\n')
        a = line.split(";")
        os[a[1]] = a[0]
    return os

def remove_emails(osallistujat):
    for line in sys.stdin:
        line = line.rstrip('\r\n')
        a = line.split(";")

        if a[1] == 'None':
            a[1] = '0.0'

        if a[0] in osallistujat:
            print(osallistujat[a[0]] + ";" + a[1])
        else:
            print(a[0] + ";" + a[1])

osallistujat = read_osallistujat(sys.argv[1])
#print(osallistujat)
remove_emails(osallistujat)
