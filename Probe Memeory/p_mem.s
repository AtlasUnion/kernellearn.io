.globl main
.code16

.section .text
main:
    call probe_mem
    lea const_str_welcome, %eax
    call print_string_eax
    movl 0x8004, %eax
    shr $20, %eax
    call print_num_eax
    lea const_str_MB, %eax
    call print_string_eax
    mov 0x8000, %ecx
    mov $0x8008, %di
1:
    lea const_str_address_start, %eax  
    call print_string_eax
    mov %es:(%di), %eax                 ## print starting addr
    call print_num_eax
    lea const_str_blank_length, %eax    
    call print_string_eax              
    mov %es:8(%di), %eax                ## print length
    call print_num_eax
    lea const_str_address_status, %eax
    call print_string_eax
    mov %es:16(%di), %eax               ## mov mem_type into %eax
    add $24, %di                        ## to next entry
    cmp $1, %eax
    je 2f
    cmp $2, %eax
    je 3f
2:
    push %edx
    push %ecx
    lea const_str_memory_type_1, %eax
    pop %ecx
    pop %edx
    jmp 7f
3:
    lea const_str_memory_type_2, %eax
    jmp 7f
7:
    call print_string_eax
    lea  const_str_return, %eax
    call print_string_eax
    loop 1b
done:
    hlt
.include "probe_mem.s"
.include "print_string.s"
.include "print_num.s"
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
.org 0x01B8
.org 0x01FE
.byte 0x55
.byte 0xAA

    