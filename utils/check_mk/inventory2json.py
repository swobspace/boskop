#!/usr/bin/env python3

import sys
import json

file = sys.argv[1]

f = open(file, "r")
data = eval(f.read())
f.close()

print(json.dumps(data))


