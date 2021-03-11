#!/usr/bin/env python3

import inspect
import io
import unittest
import unittest.mock

import hulk

# Unit Tests

class HulkTestCase(unittest.TestCase):
    ''' Hulk Unit Test Cases '''

    HASHES = (
       '0cc175b9c0f1b6a831c399e269772661',
       '92eb5ffee6ae2fec3ad71c777531578f',
       '4a8a08f09d37b73795649038408b5f33',
       '900150983cd24fb0d6963f7d28e17f72',
    )

    def test_00_md5sum(self):
        hashes = {
            'marvel' : '0e561187d51609f59a35e1079f062c7a',
            'bruce'  : 'e8315caa4eb8c2a2625d4e97dbba100a',
            'banner' : '12df53fea8b3adfa6c2ec456dd22e204',
        }

        for source, md5sum in hashes.items():
            self.assertEqual(hulk.md5sum(source), md5sum)

    def test_01_permutations(self):
        tests = (
            (1, 'abc', ['a', 'b', 'c']),
            (2, 'abc', ['aa', 'ab', 'ac', 'ba', 'bb', 'bc', 'ca', 'cb', 'cc']),
            (3, 'abc', [
                'aaa', 'aab', 'aac', 'aba', 'abb', 'abc', 'aca', 'acb', 'acc',
                'baa', 'bab', 'bac', 'bba', 'bbb', 'bbc', 'bca', 'bcb', 'bcc',
                'caa', 'cab', 'cac', 'cba', 'cbb', 'cbc', 'cca', 'ccb', 'ccc',
            ]),
        )
        self.assertTrue(inspect.isgeneratorfunction(hulk.permutations))

        for length, alphabet, permutations in tests:
            results = hulk.permutations(length, alphabet)
            for result, expected in zip(results, permutations):
                self.assertEqual(result, expected)

    def test_02_flatten(self):
        tests = (
            (('abc', 'def', 'ghi')     , 'abcdefghi'),
            ((range(0, 3), range(3, 6)), range(0, 6)),
        )
        self.assertTrue(inspect.isgeneratorfunction(hulk.flatten))

        for sequence, flattened in tests:
            results = hulk.flatten(sequence)
            for result, expected in zip(results, flattened):
                self.assertEqual(result, expected)

    def test_03_crack(self):
        self.assertEqual(
            hulk.crack([hulk.md5sum('ab')], 2),
            ['ab']
        )
        self.assertEqual(
            hulk.crack([hulk.md5sum('abc')], 2, prefix='a'),
            ['abc']
        )
        self.assertEqual(
            hulk.crack(map(hulk.md5sum, 'abc'), 1),
            ['a', 'b', 'c']
        )
        self.assertEqual(
            hulk.crack(self.HASHES, 1),
            ['a', 'b', 'c']
        )
        self.assertEqual(
            hulk.crack(self.HASHES, 3),
            ['abc']
        )
    
    def test_04_whack(self):
        self.assertEqual(
            hulk.whack([hulk.md5sum('ab'), 2, hulk.ALPHABET, '']),
            ['ab']
        )
        self.assertEqual(
            hulk.whack([hulk.md5sum('abc'), 2, hulk.ALPHABET, 'a']),
            ['abc']
        )
        self.assertEqual(
            hulk.whack([map(hulk.md5sum, 'abc'), 1, hulk.ALPHABET, '']),
            ['a', 'b', 'c']
        )
        self.assertEqual(
            hulk.whack([self.HASHES, 1, hulk.ALPHABET, '']),
            ['a', 'b', 'c']
        )
        self.assertEqual(
            hulk.whack([self.HASHES, 3, hulk.ALPHABET, '']),
            ['abc']
        )

    def test_05_smash(self):
        self.assertEqual(
            list(hulk.smash([hulk.md5sum('ab')], 2, cores=2)),
            ['ab']
        )
        self.assertEqual(
            list(hulk.smash([hulk.md5sum('abc')], 2, prefix='a', cores=2)),
            ['abc']
        )
        self.assertEqual(
            list(hulk.smash(self.HASHES, 3, cores=2)),
            ['abc']
        )

# Main Execution

if __name__ == '__main__':
    unittest.main()
