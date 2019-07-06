.globl main
.code16

main:
    cli                                ## clear interrupt flag so will not be interrupted by external interrupt
    mov $0x41, %ah                      
    mov $0x80, %dl
    mov $0x55AA, %bx
    int $0x13
    jc extension_not_avaliable
    push %eax
    push %ebx
    push %ecx
    push %ebp
    mov  %esp, %ebp
    lea const_str_has_extension, %eax
    push %eax 
    call print_string_eax
    mov %ebp, %esp
    pop %ebp
    pop %ecx
    pop %ebx
    pop %eax
    jmp load_stage1_loader_code
    hlt
extension_not_avaliable:
    push %eax
    push %ebx
    push %ecx
    push %ebp
    mov  %esp, %ebp
    lea const_str_no_extension, %eax
    push %eax 
    call print_string_eax
    mov %ebp, %esp
    pop %ebp
    pop %ecx
    pop %ebx
    pop %eax
    hlt
load_stage1_loader_code:
    push %eax
    push %ebx
    push %ecx
    push %ebp
    mov  %esp, %ebp
    lea const_str_starting_loading, %eax
    push %eax 
    call print_string_eax
    mov %ebp, %esp
    pop %ebp
    pop %ecx
    pop %ebx
    pop %eax                        
    lea DAP, %si
    mov $0x42, %ah
    mov $0x80, %dl
    int $0x13
    jc failed
    mov $0x7E00, %eax
    jmp *%eax
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
.include "../Probe Memeory/print_string.s"

const_str_has_extension:
	.asciz "BIOS has extension support\n\r"
const_str_no_extension:
	.asciz "BIOS has no extension support\n\r"
const_str_fail:
    .asciz "Fail to load\n\r"
const_str_starting_loading:
    .asciz "Start loading\n\r"
## do not delete below -> use for lba addressing
DAP:
    .byte 0x10
    .byte 0x0
number_of_sector:
    .word 1
buffer_addr: 
    .word 0x7E00
    .word 0
disk_lba:
    .long 1
    .long 0

.org 0x01FE
.byte 0x55
.byte 0xAA
