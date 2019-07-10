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

    pushl %eax
    pushl %ecx
    pushl %edx
    pushl %ebp
    movl  %esp, %ebp
    lea const_str_success, %eax
    pushl %eax 
    call print_string_eax
    movl %ebp, %esp
    popl %ebp
    popl %edx
    popl %ecx
    popl %eax

    pushl %eax
    pushl %ecx
    pushl %edx
    push %ebp
    movl  %esp, %ebp
    call stage1_probe_mem
    movl %ebp, %esp
    popl %ebp
    popl %edx
    popl %ecx
    popl %eax

    pushl %ecx
    pushl %edx
    push %ebp
    movl  %esp, %ebp
    call test_A20
    movl %ebp, %esp
    popl %ebp
    popl %edx
    popl %ecx

    cmpw $1, %ax    
    je A20_on

    pushl %eax
    pushl %ecx
    pushl %edx
    pushl %ebp
    movl  %esp, %ebp
    lea const_str_A20_off, %eax
    pushl %eax 
    call print_string_eax
    movl %ebp, %esp
    popl %ebp
    popl %edx
    popl %ecx
    popl %eax

    ## TODO: enable A20 for it is not on
    
    hlt
A20_on:
    pushl %eax
    pushl %ecx
    pushl %edx
    pushl %ebp
    movl  %esp, %ebp
    lea const_str_A20_on, %eax
    pushl %eax 
    call print_string_eax
    movl %ebp, %esp
    popl %ebp
    popl %edx
    popl %ecx
    popl %eax


    hlt
test_A20:
    pushf
    pushw %ds
    pushw %es
    pushw %di
    pushw %si
    cli
    xor %ax, %ax     ## ax = 0
    movw %ax, %es

    not %ax         ## ax = 0XFFFF
    movw %ax, %ds

    movw $0x0500, %di
    movw $0x0510, %si

    movb %es:(%si), %al
    pushw %ax
    
    movb %ds:(%si), %al
    pushw %ax

    movb $0x00, %es:(%di)
    movb $0xFF, %ds:(%si)

    cmpb $0xFF, %es:(%di)

    popw %ax
    movb %al, %ds:(%si)

    popw %ax
    movb %al, %es:(%di)

    movw $0, %ax
    je check_a20_exit   ## if (0x500) == 0xFF => ax = 0 (A20 is off)

    movw $1, %ax
check_a20_exit:
    popw %si
    popw %di
    popw %es
    popw %ds
    popf

    ret
.include "./include/stage1_probe_mem.s"
.include "../Probe Memeory/print_string.s"
.include "../Probe Memeory/print_num.s"
.include "../Probe Memeory/probe_mem.s"

const_str_success:
    .asciz "Hello, World! I am in stage1.\n\r"
const_str_new_line:
    .asciz "\n\r"
const_str_welcome:
	.asciz "Memory: 0x"
const_str_MB:
    .asciz "MB\n\r"
const_str_address_start:
	.asciz "Addr: "
const_str_blank_length:
    .asciz " Len: "
const_str_address_status:
	.asciz " stat: "
const_str_memory_type_1:
	.asciz "Free"
const_str_memory_type_2:
	.asciz "Reserved"
const_str_return:
	.asciz "\n\r"
const_str_A20_on:
    .asciz "A20 is on\n\r"
const_str_A20_off:
    .asciz "A20 is off\n\r"
