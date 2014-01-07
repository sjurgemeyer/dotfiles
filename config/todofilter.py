#!/usr/bin/python

import sys
import re

def grp(pat, txt): 
   dt = re.search(pat, txt)
   num = re.search("^\d\d", txt)

   return dt.group(0) if dt else "z" + num.group(0)

data = sys.stdin.readlines()
data.sort(key=lambda l: grp("t:\d\d\d\d-\d\d-\d\d", l))

for line in data:
    sys.stdout.write(line)



