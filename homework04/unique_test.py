#!/usr/bin/env python3

import io
import unittest
import unittest.mock

import unique

# Unit Tests

class UniqueTest(unittest.TestCase):
    ''' Unique Unit Tests '''

    POKEMON = '''pikachu
pikachu
charmander
Squirtle
squirtle
squirtle
'''

    def test_00_count_frequencies(self):
        stream = io.StringIO(self.POKEMON)
        counts = unique.count_frequencies(stream)
        self.assertEqual(counts['pikachu']   , 2)
        self.assertEqual(counts['charmander'], 1)
        self.assertEqual(counts['Squirtle']  , 1)
        self.assertEqual(counts['squirtle']  , 2)

    def test_01_count_frequencies_ignore_case(self):
        stream = io.StringIO(self.POKEMON)
        counts = unique.count_frequencies(stream, True)
        self.assertEqual(counts['pikachu']   , 2)
        self.assertEqual(counts['charmander'], 1)
        self.assertEqual(counts['squirtle']  , 3)

    def test_02_print_lines(self):
        stream = io.StringIO(self.POKEMON)
        counts = unique.count_frequencies(stream)

        with unittest.mock.patch('sys.stdout', new=io.StringIO()) as output:
            unique.print_lines(counts)
            lines = output.getvalue().splitlines()

        self.assertEqual(lines, ['pikachu', 'charmander', 'Squirtle', 'squirtle'])

    def test_03_print_lines_ignore_case(self):
        stream = io.StringIO(self.POKEMON)
        counts = unique.count_frequencies(stream, True)

        with unittest.mock.patch('sys.stdout', new=io.StringIO()) as output:
            unique.print_lines(counts)
            lines = output.getvalue().splitlines()

        self.assertEqual(lines, ['pikachu', 'charmander', 'squirtle'])

    def test_04_print_lines_occurrences(self):
        stream = io.StringIO(self.POKEMON)
        counts = unique.count_frequencies(stream)

        with unittest.mock.patch('sys.stdout', new=io.StringIO()) as output:
            unique.print_lines(counts, occurrences=True)
            lines = output.getvalue().splitlines()

        self.assertEqual(lines, [
            '      2 pikachu',
            '      1 charmander',
            '      1 Squirtle',
            '      2 squirtle'
        ])

    def test_05_print_lines_ignore_case_occurrences(self):
        stream = io.StringIO(self.POKEMON)
        counts = unique.count_frequencies(stream, True)

        with unittest.mock.patch('sys.stdout', new=io.StringIO()) as output:
            unique.print_lines(counts, occurrences=True)
            lines = output.getvalue().splitlines()

        self.assertEqual(lines, [
            '      2 pikachu',
            '      1 charmander',
            '      3 squirtle'
        ])

    def test_06_print_lines_duplicates(self):
        stream = io.StringIO(self.POKEMON)
        counts = unique.count_frequencies(stream)

        with unittest.mock.patch('sys.stdout', new=io.StringIO()) as output:
            unique.print_lines(counts, duplicates=True)
            lines = output.getvalue().splitlines()

        self.assertEqual(lines, ['pikachu', 'squirtle'])

    def test_07_print_lines_ignore_case_duplicates(self):
        stream = io.StringIO(self.POKEMON)
        counts = unique.count_frequencies(stream, True)

        with unittest.mock.patch('sys.stdout', new=io.StringIO()) as output:
            unique.print_lines(counts, duplicates=True)
            lines = output.getvalue().splitlines()

        self.assertEqual(lines, ['pikachu', 'squirtle'])

    def test_08_print_lines_unique_only(self):
        stream = io.StringIO(self.POKEMON)
        counts = unique.count_frequencies(stream)

        with unittest.mock.patch('sys.stdout', new=io.StringIO()) as output:
            unique.print_lines(counts, unique_only=True)
            lines = output.getvalue().splitlines()

        self.assertEqual(lines, ['charmander', 'Squirtle'])

    def test_09_print_lines_ignore_unique_only(self):
        stream = io.StringIO(self.POKEMON)
        counts = unique.count_frequencies(stream, True)

        with unittest.mock.patch('sys.stdout', new=io.StringIO()) as output:
            unique.print_lines(counts, unique_only=True)
            lines = output.getvalue().splitlines()

        self.assertEqual(lines, ['charmander'])

    def test_10_print_lines_occurrences_duplicates(self):
        stream = io.StringIO(self.POKEMON)
        counts = unique.count_frequencies(stream)

        with unittest.mock.patch('sys.stdout', new=io.StringIO()) as output:
            unique.print_lines(counts, occurrences=True, duplicates=True)
            lines = output.getvalue().splitlines()

        self.assertEqual(lines, [
            '      2 pikachu',
            '      2 squirtle'
        ])

    def test_11_print_lines_ignore_case_occurrences_duplicates(self):
        stream = io.StringIO(self.POKEMON)
        counts = unique.count_frequencies(stream, True)

        with unittest.mock.patch('sys.stdout', new=io.StringIO()) as output:
            unique.print_lines(counts, occurrences=True, duplicates=True)
            lines = output.getvalue().splitlines()

        self.assertEqual(lines, [
            '      2 pikachu',
            '      3 squirtle'
        ])

    def test_12_print_lines_occurrences_unique_only(self):
        stream = io.StringIO(self.POKEMON)
        counts = unique.count_frequencies(stream)

        with unittest.mock.patch('sys.stdout', new=io.StringIO()) as output:
            unique.print_lines(counts, occurrences=True, unique_only=True)
            lines = output.getvalue().splitlines()

        self.assertEqual(lines, [
            '      1 charmander',
            '      1 Squirtle'
        ])

    def test_13_print_lines_ignore_case_occurrences_unique_only(self):
        stream = io.StringIO(self.POKEMON)
        counts = unique.count_frequencies(stream, True)

        with unittest.mock.patch('sys.stdout', new=io.StringIO()) as output:
            unique.print_lines(counts, occurrences=True, unique_only=True)
            lines = output.getvalue().splitlines()

        self.assertEqual(lines, [
            '      1 charmander',
        ])

# Main Execution

if __name__ == '__main__':
    unittest.main()
