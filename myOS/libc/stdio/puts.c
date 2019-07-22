#include <stdio.h>

/**
 * print to screen (automatically add trailing newline character)
 */
int puts (const char* string) {
    return printf("%s\n", string);
}