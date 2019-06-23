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
