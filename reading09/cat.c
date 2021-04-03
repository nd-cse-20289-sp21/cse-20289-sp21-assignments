/* cat.c */

#include <errno.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/* Globals */

char * PROGRAM_NAME = NULL;

/* Functions */

void usage(int status) {
    ____(stderr, "Usage: %s\n", PROGRAM_NAME);                                    /* 1 */
    ____(status);                                                                 /* 2 */
}

bool cat_stream(FILE *stream) {
    char buffer[BUFSIZ];

    while (____(buffer, BUFSIZ, stream)) {                                        /* 3 */
        ____(buffer, stdout);                                                     /* 4 */
    }

    return true;
}

/* Main Execution */

int main(int argc, char *argv[]) {
    int argind = 1;

    /* Parse command line arguments */
    PROGRAM_NAME = ____;                                                          /* 5 */
    while (argind < argc && ____(argv[argind]) > 1 && argv[argind][0] == '-') {   /* 6 */
        char *arg = argv[argind++];
        switch (arg[1]) {
            case 'h':
                usage(0);
                break;
            default:
                usage(1);
                break;
        }
    }

    /* Process each file */
    return !cat_stream(stdin);
}

/* vim: set sts=4 sw=4 ts=8 expandtab ft=c: */
