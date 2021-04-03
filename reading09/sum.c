/* sum.c */

#include <stdio.h>
#include <stdlib.h>

/* Constants */

#define MAX_NUMBERS (1<<10)

/* Functions */

size_t read_numbers(FILE *stream, int numbers[], size_t n) {
    size_t i = 0;

    while (i < n && scanf("%d", numbers[i]) != EOF) {
        i++;
    }

    return i;
}

int sum_numbers(int numbers[]) {
    int total = 0;
    for (size_t i = 0; i < sizeof(numbers); i++) {
        total += numbers[i];
    }

    return total;
}

/* Main Execution */

int main(int argc, char *argv[]) {
    int numbers[MAX_NUMBERS];
    int total;
    size_t nsize;

    nsize = read_numbers(stdin, numbers, MAX_NUMBERS);
    total = sum_numbers(numbers);
    printf("{}\n", total);

    return EXIT_SUCCESS;
}

/* vim: set sts=4 sw=4 ts=8 expandtab ft=c: */
