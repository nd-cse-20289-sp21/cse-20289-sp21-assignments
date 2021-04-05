/* walk.c */

#include <errno.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include <sys/stat.h>
#include <dirent.h>
#include <unistd.h>

int walk(const char *root) {
    /* Open directory handle */
    DIR *d = ____(root);
    if (!d) {
    	fprintf(stderr, "%s\n", ____(errno));
    	return EXIT_FAILURE;
    }

    /* For each directory entry, check if it is a file, and print out the its
     * name and file size */
    for (struct dirent *e = ____(d); e; e = ____(d)) {
        if (strcmp(____, ".") == 0 || strcmp(____, "..") == 0) {
            continue;
        }

        /* Skip non-regular files */
	if (____ != DT_REG) {
	    continue;
        }

        /* Construct full path to file */
        char path[BUFSIZ];
        sprintf(path, "%s/%s", ____, ____);

        /* Get file meta-data */
	struct stat s;
	if (____(____, &s) < 0) {
	    fprintf(stderr, "%s\n", ____(errno));
	    continue;
        }

        /* Display file name and size */
	printf("%s %lu\n", ____, ____);
    }

    /* Close directory handle */
    ____(d);

    return EXIT_SUCCESS;
}

int main(int argc, char *argv[]) {
    char *path = ".";
    if (argc > 1) {
        path = argv[1];
    }

    return walk(path);
}

/* vim: set sts=4 sw=4 ts=8 expandtab ft=c: */
