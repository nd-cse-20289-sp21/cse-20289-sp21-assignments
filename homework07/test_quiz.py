#!/usr/bin/env python3

import json
import sys

import requests
import yaml

# Quiz

def submit_quiz():
    answers = None

    for mod_load, ext in ((json.load, 'json'), (yaml.safe_load, 'yaml')):
        try:
            answers = mod_load(open('answers.' + ext))
        except IOError as e:
            pass
        except Exception as e:
            print(f'Unable to parse answers.{ext}: {e}')
            return 0.0

    if answers is None:
        print('Cannot find answers.json or answers.yaml file')
        return 0.0

    print('Submitting homework08 quiz ...')

    url = 'https://dredd.h4x0r.space/quiz/cse-20289-sp20/homework08'
    response = requests.post(url, data=json.dumps(answers))

    for key, value in sorted(response.json().items()):
        if key == 'score':
            print()
        try:
            print(f'{key.title():>8} {value:.2f}')
        except ValueError:
            print(f'{key.title():>8} {value}')

    return response.json().get('score', 0)

# Main Execution

if __name__ == '__main__':
    sys.exit(submit_quiz() != 2.0)
