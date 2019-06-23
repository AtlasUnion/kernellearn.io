probe_mem:
    mov $0, %eax
    mov %eax, %es         ## clear %es
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
