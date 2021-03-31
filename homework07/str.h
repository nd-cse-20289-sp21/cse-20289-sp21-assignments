/* str.h: string utilities library */

#pragma once

#include <stdbool.h>
#include <stdlib.h>

/* Case */
void    str_lower(char *s);
void    str_upper(char *s);
void    str_title(char *s);

/* Strip */
void    str_chomp(char *s);
void    str_strip(char *s);

/* Reverse */
void    str_reverse(char *s);

/* Translation */
void    str_translate(char *s, char *from, char *to);

/* vim: set sts=4 sw=4 ts=8 expandtab ft=c: */
