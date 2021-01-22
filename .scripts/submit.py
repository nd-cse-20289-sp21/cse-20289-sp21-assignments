#!/usr/bin/env python3

import glob
import json
import os
import sys

import requests
import yaml

# Globals

ASSIGNMENTS            = {}
DREDD_QUIZ_URL         = 'https://dredd.h4x0r.space/quiz/cse-20289-sp21/'
DREDD_READING_QUIZ_MAX = 4.0

# Utilities

def add_assignment(assignment, path=None):
    if path is None:
        path = assignment

    if assignment.startswith('reading') or assignment.startswith('project'):
        ASSIGNMENTS[assignment] = path

def print_results(results):
    for key, value in sorted(results):
        if key == 'value':
            continue

        try:
            print('{:>8} {:.2f}'.format(key.title(), value))
        except ValueError:
            if key in ('stdout', 'diff'):
                print('{:>8}\n{}'.format(key.title(), value))
            else:
                print('{:>8} {}'.format(key.title(), value))

# Submit Functions

def submit_quiz(assignment, path):
    answers = None

    for mod_load, ext in ((json.load, 'json'), (yaml.safe_load, 'yaml')):
        try:
            answers = mod_load(open(os.path.join(path, 'answers.' + ext)))
        except IOError as e:
            pass
        except Exception as e:
            print('Unable to parse answers.{}: {}'.format(ext, e))
            return 1

    if answers is None:
        print('No quiz found (answers.{json,yaml})')
        return 1

    print('Submitting {} quiz ...'.format(assignment))
    response = requests.post(DREDD_QUIZ_URL + assignment, data=json.dumps(answers))
    print_results(response.json().items())
    print()

    quiz_max = response.json().get('value', DREDD_READING_QUIZ_MAX)
    return 0 if response.json().get('score', 0) >= quiz_max else 1

# Main Execution

# Add GitLab/GitHub branch
for variable in ['CI_BUILD_REF_NAME', 'GITHUB_HEAD_REF']:
    try:
        add_assignment(os.environ[variable])
    except KeyError:
        pass

# Add local git branch
try:
    add_assignment(os.popen('git symbolic-ref -q --short HEAD 2> /dev/null').read().strip())
except OSError:
    pass

# Add current directory
add_assignment(os.path.basename(os.path.abspath(os.curdir)), os.curdir)

# For each assignment, submit quiz answers and program code

if not ASSIGNMENTS:
    print('Nothing to submit!')
    sys.exit(1)

exit_code = 0

for assignment, path in sorted(ASSIGNMENTS.items()):
    print('Submitting {} assignment ...'.format(assignment))
    if 'reading' in assignment or 'homework' in assignment:
        exit_code += submit_quiz(assignment, path)

sys.exit(exit_code)

# vim: set sts=4 sw=4 ts=8 expandtab ft=python:
