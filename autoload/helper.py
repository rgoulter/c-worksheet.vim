# Helper script: Given the worksheetified output,
# Construct a list-of-lists, corresponding to the output
# to add for each line.

import re

# Have to *search* for the first line comment.
firstLineCmt = re.compile("\s*//>.*$")

# Continued comments must begin from the start
secondLineCmt = re.compile("^\s*//\|.*$")

def acc_worksheet_output(acc, line):
	fl = re.search(firstLineCmt, line)
	sl = re.search(secondLineCmt, line)
	if fl != None:
		return acc + [[fl.group()]]
	elif sl != None:
		return acc[:-1] + [acc[-1] + [sl.group()]]
	else:
		return acc + [[]]

# reduce(f, xs, init)
# output = reduce(acc_worksheet_output, lines, [])
