.globl main
.code16

main:
    cli                                ## clear interrupt flag so will not be interrupted by external interrupt
    mov $0x41, %ah                      
    mov $0x80, %dl
    mov $0x55AA, %bx
    int $0x13
    jc extension_not_avaliable
    lea const_str_has_extension, %eax 
    call print_string_eax
    int $0x11
    jmp load_stage1_loader_code
    hlt
extension_not_avaliable:
    lea const_str_no_extension, %eax
    call print_string_eax
    hlt
load_stage1_loader_code:
    lea const_str_starting_loading, %eax
    call print_string_eax                ## TODO: test if BIOS extension using LBA works
    mov $0x2, %ah                        ## function code
    mov $0x1, %al                        ## number of sectors to read
    mov $0x0, %ch                        ## track/cylinder number
    mov $0x0, %dh                        ## head number
    mov $0x2, %cl                        ## sector number
    mov $0x80, %dl                       ## drive number (0x80=drive 0)
    mov $0x7E00, %bx                     ## es:bx point to buffer                     
    int $0x13
    jc failed
    mov $0x7E00, %eax
    jmp *%eax
failed:
    lea const_str_fail, %eax
    call print_string_eax
    hlt
.include "../Probe Memeory/print_string.s"

const_str_has_extension:
	.asciz "BIOS has extension support\n\r"
const_str_no_extension:
	.asciz "BIOS has no extension support\n\r"
const_str_fail:
    .asciz "Fail to load\n\r"
const_str_starting_loading:
    .asciz "Starting loading\n\r"
DAP:
    .byte 0x10
    .byte 0x0
number_of_sector:
    .word 1
buffer_addr: 
    .word 0x7E00
    .word 0x0
disk_lba:
    .long 2
    .long 0

.org 0x01FE
.byte 0x55
.byte 0xAA
