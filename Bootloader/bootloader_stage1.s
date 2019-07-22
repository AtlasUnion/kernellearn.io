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

Set_Video_Mode:
    movb $0x00, %ah
    movb $0x03, %al
    int $0x10

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

Main_Probe_Mem:
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

Enter_Unreal_Mode:
    xorl %eax, %eax
    movw %ax, %ds

    cli 
    pushw %ds

    lgdt gdt_ptr

    movl %cr0, %eax
    or $1, %al
    movl %eax, %cr0
    jmp .+2
1:
    movw $0x10, %bx
    movw %bx, %ds

    andb $0xFE, %al
    movl %eax, %cr0

    popw %ds 

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

Main_test_A20:
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
Load_Kernel:
    lea DAP, %si
    mov $0x42, %ah
    mov $0x80, %dl
    int $0x13
    jc failed
    jmp Enter_Protected_Mode
failed:
    push %eax
    push %ebx
    push %ecx
    push %ebp
    mov  %esp, %ebp
    lea const_str_fail, %eax
    push %eax 
    call print_string_eax
    mov %ebp, %esp
    pop %ebp
    pop %ecx
    pop %ebx
    pop %eax
    hlt 
.include "./include/stage1_probe_mem.s"
.include "../Probe Memeory/print_string.s"
.include "../Probe Memeory/print_num.s"
.include "../Probe Memeory/probe_mem.s"

DAP:
    .byte 0x10
    .byte 0x0
number_of_sector:
    .word 3
buffer_addr: 
    .word 0x0
    .word 0x1000
disk_lba:
    .long 2047
    .long 0
stack_starting_address:
    .long 0x00301000

Enter_Protected_Mode:
    lgdt gdt_ptr
    movl $0, %eax
    movl %cr0, %eax
    orb $0x1, %al
    movl %eax, %cr0
Enter_Protected_Mode_stage_two:
    ljmp $0x8, $Protected       ## flush the pipeline
.code32
    jmp .+2
Protected:
    movw $0x10, %ax
    movw %ax, %ss
    movw %ax, %ds
    movw %ax, %es
    movw %ax, %fs
    movw %ax, %gs
    movl $0x301000, %esp

Jump_to_Kernel:
    movl $0x00010000, %eax
    jmp *%eax
## TODO: enable A20 for the case it is not on

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
const_str_fail:
    .asciz "Fail to load\n\r"

gdt:                ## null descriptor
    .long 0x0
    .long 0x0   
code_seg:
    .long 0x0000FFFF
    .long 0x00CF9A00
data_seg:
    .long 0x0000FFFF
    .long 0x00CF9200
gdt_ptr:
    .short 0x100
    .long gdt
