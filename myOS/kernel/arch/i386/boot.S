.globl _start
.align 4

_start:
    cli
    call kernel_main
    hlt