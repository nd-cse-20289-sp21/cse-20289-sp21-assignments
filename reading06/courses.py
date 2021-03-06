#!/usr/bin/env python3

import collections
import re
import requests

# Globals

URL = 'https://cse.nd.edu/undergraduate/computer-science-course-map/'

# Initialize a default dictionary with integer values
counts = None

# TODO: Make a HTTP request to URL
response = None

# TODO: Access text from response object
data = None

# TODO: Compile regular expression to match CSE courses (ie. CSE XXXXX)
regex = None

# TODO: Search through data using compiled regular expression and count up all
# the courses per class year
for course in re.findall(None, None):
    pass

# Sort items in counts dictionary by value in reverse order and display counts
# and class year
for year, count in sorted(counts.items(), key=lambda p: p[1]):
    print(f'{count:>7} {year}')
