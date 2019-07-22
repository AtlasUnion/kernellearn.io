#include <stdio.h>

#if defined(__is_libk)
#include <kernel/tty.h>
#endif

int putchar(int ic) {
    #if defined(is_libk)

    char c = (char) ic;
    terminal_write(&c, sizeof(c));

    #else
        // TODO: implement user space code with system call
    #endif

    return ic;
}