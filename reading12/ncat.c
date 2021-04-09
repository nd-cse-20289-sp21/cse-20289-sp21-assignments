/* ncat.c */

#include <errno.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>

#include <arpa/inet.h>
#include <netdb.h>
#include <sys/socket.h>
#include <sys/types.h>
#include <unistd.h>

int main(int argc, char *argv[]) {
    /* Parse command line options */
    if (argc != 3) {
	fprintf(stderr, "Usage: %s HOST PORT\n", argv[0]);
	return EXIT_FAILURE;
    }

    char *host = argv[1];
    char *port = argv[2];

    /* Lookup server address information */
    struct addrinfo *results;
    struct addrinfo  hints = {
        .ai_family   = ____, /* Return IPv4 and IPv6 choices */
        .ai_socktype = ____, /* Use TCP */
    };
    int status;
    if ((status = ____(host, port, &hints, &results)) != 0) {
    	fprintf(stderr, "getaddrinfo failed: %s\n", ____(status));
	return EXIT_FAILURE;
    }

    /* For each server entry, allocate socket and try to connect */
    int socket_fd = -1;
    for (struct addrinfo *p = results; p != NULL && socket_fd < 0; p = p->ai_next) {
	/* Allocate socket */
	if ((socket_fd = ____(p->ai_family, p->ai_socktype, p->ai_protocol)) < 0) {
	    fprintf(stderr, "Unable to make socket: %s\n", strerror(errno));
	    continue;
	}

	/* Establish connection to host */
	if (____(socket_fd, p->ai_addr, p->ai_addrlen) < 0) {
	    ____(socket_fd);
	    socket_fd = -1;
	    continue;
	}
    }

    /* Release allocate address information */
    ____(results);

    if (socket_fd < 0) {
	fprintf(stderr, "Unable to connect to %s:%s: %s\n", host, port, strerror(errno));
    	return EXIT_FAILURE;
    }

    printf("Connected to %s:%s\n", host, port);

    /* Open file stream from socket file descriptor */
    FILE *socket_file = ____(____, "w");
    if (!socket_file) {
        fprintf(stderr, "Unable to fdopen: %s\n", strerror(errno));
        ____(socket_fd);
        return EXIT_FAILURE;
    }

    /* Read from stdin and write to server */
    char buffer[BUFSIZ];
    while (____(buffer, BUFSIZ, stdin)) {
        ____(buffer, ____);
    }

    /* Release socket */
    ____(socket_file);

    return EXIT_SUCCESS;
}

/* vim: set expandtab sts=4 sw=4 ts=8 ft=c: */
