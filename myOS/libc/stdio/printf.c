#include <limits.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdarg.h>
#include <string.h>

static bool print(const char* data, size_t length) {
    const unsigned char* bytes = (const unsigned char*) data;

    for (size_t i = 0; i < length; i++) {
        if (putchar(bytes[i]) == EOF)
            return false;
    }

    return true;
}

int printf(const char* restrict format, ...) {
    va_list parameters;
    va_start(parameters, format);

    int written = 0;

    while (*format != '\0') {
        size_t maxrem = INT_MAX - written;

        // Case: no special format
        if (format[0] != '%' || format[1] == '%') {
            if (format[0] == '%')
                format++;
            size_t amount = 1;
            // not zero and not format char
            while (format[amount] && format[amount] != '%')
                amount++;
            if (maxrem < amount) {
                return -1;
            }
            if(!print(format, amount))
                return -1;
            format += amount;
            written += amount;
            continue;
        }

        // Case: format[0] = '%' and format[1] != '%'
        // Special format
        const char* format_begun_at = format++;

        if (*format == 'c') {
            format++;
            char c = (char) va_arg(parameters, int);
            if (!maxrem) {
                return -1;
            }
            if (!print(&c, sizeof(c)))
                return -1;
            written++;
        } else if (*format == 's') {
            format++;
            const char* str = va_arg(parameters, const char*);
            size_t len = strlen(str);
            if (maxrem < len) {
                return -1;
            }
            if (!print(str, len))
                return -1;
            written += len;
        } else if (*format == 'd') {
            format++;
            int i = va_arg(parameters, int);

            while (i != 0) {
                char digit_to_be_print = (i % 10) + 48;
                i = i / 10;
                if (!print(&digit_to_be_print, sizeof(digit_to_be_print)))
                    return -1;
            }
        } else {
            format = format_begun_at;
            size_t len = strlen(format);
            if (maxrem < len) {
                return -1;
            }
            if (!print(format, len))
                return -1;
            written += len;
            format += len;
        }
    }

    va_end(parameters);
    return written;
}