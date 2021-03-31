#!/usr/bin/env python3

import ctypes
import unittest

# Str Utilities - Library

libstr = ctypes.CDLL('./libstr.so')
libstr.str_to_int.restype = ctypes.c_int

# Str Utilities - Test Case

class StrTestCase(unittest.TestCase):
    Points = 0

    def test_00_str_lower(self):
        words = [b'', b'abc', b'ABC', b'AbC']
        for source in map(ctypes.create_string_buffer, words):
            target = source.value.lower()
            libstr.str_lower(source)
            self.assertTrue(source.value == target)
            StrTestCase.Points += 0.5 / len(words)

    def test_01_str_upper(self):
        words = [b'', b'abc', b'ABC', b'AbC']
        for source in map(ctypes.create_string_buffer, words):
            target = source.value.upper()
            libstr.str_upper(source)
            self.assertTrue(source.value == target)
            StrTestCase.Points += 0.5 / len(words)
    
    def test_02_str_title(self):
        words = [b'', b'abc', b'ABC', b'AbC', b'a b c', b'aa b0b c!!c']
        for source in map(ctypes.create_string_buffer, words):
            target = source.value.title()
            libstr.str_title(source)
            self.assertTrue(source.value == target)
            StrTestCase.Points += 1.0 / len(words)

    def test_03_str_chomp(self):
        words = [b'', b'\n', b'abc', b'abc\n', b'\nabc']
        for source in map(ctypes.create_string_buffer, words):
            target = source.value
            while target and chr(target[-1]).isspace():
                target = target[:-1]
            libstr.str_chomp(source)
            self.assertTrue(source.value == target)
            StrTestCase.Points += 1.0 / len(words)

    def test_04_str_strip(self):
        words = [b'', b' ', b' A', b'A ', b' A ', b' A B ']
        for source in map(ctypes.create_string_buffer, words):
            target = source.value.strip()
            libstr.str_strip(source)
            self.assertTrue(source.value == target)
            StrTestCase.Points += 1.00 / len(words)

    def test_05_str_reverse(self):
        words = [b'', b' ', b' A', b'A ', b' A ', b' A B ']
        for source in map(ctypes.create_string_buffer, words):
            target = source.value[::-1]
            libstr.str_reverse(source)
            self.assertTrue(source.value == target)
            StrTestCase.Points += 2.0 / len(words)

    def test_06_str_translate(self):
        cases = [
            (b'', b'', b'', b''),
            (b'hello', b'', b'430', b'hello'),
            (b'hello', b'aeo', b'', b'hello'),
            (b'hello', b'aeo', b'430', b'h3ll0'),
            (b' hello ', b'aeo', b'430', b' h3ll0 '),
            (b' hello ', b'aeol', b'4301', b' h3110 '),
        ]
        for a, b, c, d in cases:
            a = ctypes.create_string_buffer(a)
            libstr.str_translate(a, b, c)
            self.assertTrue(a.value == d)
            StrTestCase.Points += 2.0 / len(cases)

    def test_07_str_to_int(self):
        cases = (
            (b'0', 2),
            (b'1', 2),
            (b'10', 2),
            (b'11', 2),
            (b'0', 8),
            (b'44', 8),
            (b'644', 8),
            (b'0', 10),
            (b'9', 10),
            (b'10', 10),
            (b'19', 10),
            (b'0', 16),
            (b'A', 16),
            (b'AF', 16),
            (b'a', 16),
            (b'aF', 16),
        )

        for s, b in cases:
            self.assertTrue(libstr.str_to_int(s, b) == int(s, b))
            StrTestCase.Points += 2.0 / len(cases)

    @classmethod
    def setupClass(cls):
        cls.Points = 0

    @classmethod
    def tearDownClass(cls):
        print('   Score {:.2f}'.format(cls.Points))

# Main Execution

if __name__ == '__main__':
    unittest.main()
