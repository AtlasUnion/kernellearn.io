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
    push %eax
    push %ebx
    push %ecx
    push %ebp
    mov  %esp, %ebp
    lea const_str_success, %eax
    push %eax 
    call print_string_eax
    mov %ebp, %esp
    pop %ebp
    pop %ecx
    pop %ebx
    pop %eax

    push %eax
    push %ebx
    push %ecx
    push %ebp
    mov  %esp, %ebp
    mov %esp, %eax
    push $0x20
    call print_num_eax
    mov %ebp, %esp
    pop %ebp
    pop %ecx
    pop %ebx
    pop %eax

    

    hlt
.include "../Probe Memeory/print_string.s"
.include "../Probe Memeory/print_num.s"

const_str_success:
    .asciz "Hello, World! I am in stage1.\n\r"
const_str_new_line:
    .asciz "\n\r"