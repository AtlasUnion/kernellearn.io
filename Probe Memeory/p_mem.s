.globl main
.code16

main:
    call probe_mem
    lea const_str_welcome, %eax
    call print_string_eax
    movl 0x8004, %eax
    shr $20, %eax
    call print_num_eax
    hlt
probe_mem:
    ## movb $0, %es             ## clear %es
    movl $0, 0x8004
    mov $0x8008, %di        ##　set di to 0x8008 so first 4 bytes can be used to store number of entries and next 4 used to store total memory length
    xor %ebx, %ebx          ## first call, ebx must be 0
    xor %bp, %bp            ## use bp to stors # of entires
    mov $0x0534D4150, %edx  ## move 'SMAP' signature to edx, used by BIOS to verify the caller is requesting the syste map to be returned in ES:DI
    mov $0xe820, %eax       ## function code 
    movl $1, %es:20(%di)    ## force a valid ACPI 3.x entry
    mov $24, %ecx           ## request 24 bytes
    int $0x15               
    jmp in_entry 
loop_entry:
    mov $0xe820, %eax       ## function code
    movl $1, %es:20(%di)    ## force ACPI 3.X entry
    mov $24, %ecx           ## ask for 24 bytes
    int $0x15 
    jc loop_done            ## if carry set -> end of the list
    mov $0x0534D4150, %edx  ## SMAP
in_entry:
    jcxz skipentry          ## jcxz: jump if ecx is zero => skip empty enrty
    cmp  $20, %cl           ## get a 24 byte ACPI 3.x entry?
    jbe notext              ## if %cl <= 20
    testl $1, %es:20(%di)   ## is "ingore the entry" bit set
    je skipentry            ## is set
notext:
    mov %es:(%di), %ecx     ## get lower uint32_t of memory region length
    or %es:12(%di), %ecx    ## or with upper uint32_t to test for zero
    jz skipentry            ## length is zero, skip the entry
    inc %bp                 ## entry_count++
    mov %es:8(%di), %eax    ## store length into eax
    add %eax, 0x8004        ## add length to 0x8004 TODO: init 0x8004
    add $24, %di
skipentry:
    test %ebx, %ebx         ## AND %ebx, %ebx => check if ebx is zero => if ebx is zero, the list is complete
    jne loop_entry
loop_done:
    mov %bp, 0x8000
    clc                     ## clear carry flag
    ret
print_string_eax:
    cld                      ## clear direction flag
    pushl %ebx               ## perserve registers
    pushl %ecx
    movl %eax, %ebx          ## eax -> ebx
    movl %eax, %ecx          ## eax -> ecx
    andl $0x0000FFFF, %ebx   ## to save 0-15 bits in ebx
	andl $0x000F0000, %ecx   ## to save 16-19 bits in ecx
    shr $4, %ecx             ## right shift ecx by 4
    mov %bx, %si             ## bx (0-15 bits of ebx) -> si
    mov %cx, %ds             ## cx (0-15 bits of ecx) -> ds
    call _print_string_ds_si ## call _print_string_ds_si
    popl %ecx                ## mov ecx stack -> ecx
    popl %ebx
    ret 
_print_string_ds_si:
    lodsb                   ## es:di -> al
    cmp $0, %al             ## check if reach the end of string
    je  return              ## if reach the end of string -> time to return
    movb $0x0E, %ah         ## int 10h with ah = 0x0e -> print char in al and advance cursor
    int $0x10       
    jmp _print_string_ds_si ## not done
return:
    ret
print_num_eax:
    pushl %ecx
    movw $8, %cx
    call _print_num_eax
    pop %ecx
    ret
_print_num_eax:
    pushl %eax           ## stack.push(ax)
    pushw %cx            ## stack.push(cx)
    shl $2, %cx          ## cx = cx << 2
    sub $4, %cx          ## cx -= 4
    shr %cl, %eax        ## ax = ax >> cl
    andl $0xF, %eax      ## ax &= 1
    cmp $10, %al         ## if(10 < al)
    jl print_num         ##     print_num(&al, &ah)
    add $55, %al         ## else al += 55
    movb $0x0E, %ah      ## ah = 14
    int $0x10            ## BIOS.int(action = 10, fun_code = ah = 14, print_content = al)
1:
    popw %cx              ## cx = stack.pop()
    popl %eax             ## ax = stack.pop()
    loop _print_num_eax   ## cx --; if cx != 0 goto print_mem;
    ret                   ## return;
print_num:
    add $48, %al         ## al += 48
    movb $0x0E, %ah      ## ah = 0xE
    int $0x10            ## BIOS.int(action = 10, function_code = 14, print_content = al)
    jmp 1b               ## return;
const_str_welcome:
	.asciz "Welcome *** System Memory is: 0x"

.org 0x01FE
.byte 0x55
.byte 0xAA

    