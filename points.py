#!/usr/bin/python

import sys
from sets import Set

def read_conf():
    f = open("points.conf", "r")
    conf = []
    i = 0
    for line in f:
        line = line.rstrip('\r\n;')
        if line.startswith('#'):
            continue
        arr = line.split()
        conf.append(arr)
        i = i + 1
        
    return conf

def read_points(file, points, modidx, students):
    #print "opening " + file
    f = open(file, "r")
    for line in f:
        line = line.rstrip('\r\n;')
        if line.startswith('#'):
            continue
        arr = line.split(",")
        student = arr[0].strip('\"')

        # The int conversion fails at least once, for the title line
        try:
            p = int(arr[modidx+1].strip('\"'))
        except ValueError:
            continue
        
        if (points.has_key(student)):
            cur = points[student]
        else:
            cur = [0] * 6
            students.add(student)
            
        cur[modidx] = p
        points[student] = cur
        #print "full " + student + ": ", points[student]

def print_html(fullpoints, halfpoints, students, conf):
    print """<html>
<head>
<meta charset='utf-8'>
<meta content='width=device-width, initial-scale=1, maximum-scale=1' name='viewport'>
<title>C programming - weighed exercise points</title>
<link href="main.css" media="screen" rel="stylesheet" type="text/css" />
<link href="bootstrap.css" media="screen" rel="stylesheet" type="text/css" />
</head>

<body class='default'>
<div class="scrollable">
<h1>Weighed exercise points</h1>
"""

    timestamp = "XXX"
    print("<b>Updated:</b> %s<br/>\n" % timestamp);

    print """
<b>Full:</b> number of exercises done before the primary deadline for full points<br/>
<b>Half:</b> number of exercises done after the primary deadline, before Module closed<br/>
<b>Points:</b> Full + Half / 2<br/>
Red module score means that the module is not accepted: not enough tasks were completed.<br/>
<b>Passed:</b> Number of modules passed (at least 60% of tasks completed)<br/>
  <table class="points">
    <thead>
      <tr>
        <th></th>"""

    for i in range(0, len(conf)):
        print("<th colspan=\"3\">Module %d</th> " % (i+1));

    print """
          <th></th>
      </tr>
      <tr class="table-totals">
        <td>Student</td>
"""

    for i in range(0, len(conf)):
        print "<td>Full</td> <td>Half</td> <td>Points</td>"

          
    print """
          <td>
            Total
          </td>
<td>
Passed
</td>
      </tr>
    </thead>
	<tbody>	  
"""
    
    count = [0] * 6
    pct60 = [0] * 6
    alldone = [0] * 6
    acount = 0
    numtasks = [0] * 6
    for i in range(0, len(conf)):
        m = conf[i]
        numtasks[i] = m[2]
    
    for s in sorted(students):
        print("<tr class=\"student\"> "),
        print("<td>%s</td> " % s),
        
        totalpoints = 0
        accepted = 0
        for i in range(0, len(conf)):
            try:
                fp = fullpoints[s]
                fpi = int(fp[i])
            except KeyError:
                fpi = 0
                
            hp = halfpoints[s]
            points = float(fpi) + float(hp[i] - fpi) / 2
            if hp[i] > 0:
                count[i] = count[i] + 1
                
            color = "black"
            if hp[i] > float(numtasks[i]) * 0.6:
                pct60[i] = pct60[i] + 1
                accepted = accepted + 1
            else:
                color = "red"

            if hp[i] >= numtasks[i]:
                alldone[i] = alldone[i] + 1
                
            totalpoints = totalpoints + points
            print("<td><font color=\"%s\">%d</font></td> " % (color, fpi)),
            print("<td><font color=\"%s\">%d</font></td> " % (color, hp[i] - fpi)),
            print("<td><font color=\"%s\">%.1f</font></td> " % (color, points)),
            
        print("<td>%.1f</td>" % totalpoints),
        color = "red"
        if accepted >= 5:
            color = "black";
            acount = acount + 1
        print("<td><font color=\"%s\">%d</font></td></tr>\n" % (color, accepted))
        
    print("<tr> <td></td> ")
    for i in range(0, len(conf)):
        print("<td colspan=\"3\">\n")
        print("at least one: %d<br/>\n" % count[i]),
        print("at least 60%%: %d<br/>\n" % pct60[i]),
        print("all done: %d\n" % alldone[i]),
        print("</td> ")
        
    print("<td></td> <td>%d</font></td> </tr>" % acount)
    print "</tbody></table></div></body></html>"

    
### main execution starts here
            
conf = read_conf()

fullpoints = { }
halfpoints = { }

for i in range(0, len(conf)):
    modfiles = conf[i]
    students = Set()
    read_points(modfiles[0], fullpoints, i, students)
    read_points(modfiles[1], halfpoints, i, students)

#print halfpoints
print_html(fullpoints, halfpoints, students, conf)