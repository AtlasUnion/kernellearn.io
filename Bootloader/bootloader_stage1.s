.globl main
.code16
## TODO:
## Probe Mem => Save somewhere
## Probe avaliable video mode => Save somewhere
## Enable A20
## Load GDT
## Enter Protected Mode
main:
    cli
    lea const_str_success, %eax
    call print_string_eax
    hlt
.include "../Probe Memeory/print_string.s"

const_str_success:
    .asciz "Hello, World! I am in stage1.\n\r"
