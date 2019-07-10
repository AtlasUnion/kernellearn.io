stage1_probe_mem:               ## probe memory and put mem map starting const_addr_mem_map
    cli                         ## first 4 bytes: entry counts
    pushl %eax                  ## next 4 bytes: total mem length    
    pushl %ecx                  ## entries of 24 bytes each
    pushl %edx
    pushl %ebp
    movl  %esp, %ebp
    pushl const_addr_mem_map
    call probe_mem
    movl %ebp, %esp
    popl %ebp
    popl %eax
    popl %ecx
    popl %edx

    pushl %eax
    pushl %ecx
    pushl %edx
    pushl %ebp
    movl  %esp, %ebp
    lea const_str_welcome, %eax
    pushl %eax 
    call print_string_eax
    movl %ebp, %esp
    popl %ebp
    popl %eax
    popl %ecx
    popl %edx

    pushl %eax
    pushl %ecx
    pushl %edx
    pushl %ebp
    movl  %esp, %ebp
    movl %esp, %eax
    movl const_addr_mem_map, %edx
    movl 4(%edx), %eax
    shr $20, %eax
    pushl %eax
    call print_num_eax
    movl %ebp, %esp
    popl %ebp
    popl %eax
    popl %ecx
    popl %edx

    pushl %eax
    pushl %ecx
    pushl %edx
    pushl %ebp
    movl  %esp, %ebp
    lea const_str_MB, %eax
    pushl %eax 
    call print_string_eax
    movl %ebp, %esp
    popl %ebp
    popl %eax
    popl %ecx
    popl %edx

    movl const_addr_mem_map, %edx
    movl (%edx), %ecx
    add $0x8, %edx
    mov %dx, %di
1:
    pushl %eax
    pushl %ecx
    pushl %edx
    pushl %ebp
    movl  %esp, %ebp
    lea const_str_address_start, %eax
    pushl %eax  
    call print_string_eax
    movl %ebp, %esp
    popl %ebp
    popl %eax
    popl %ecx
    popl %edx

    pushl %eax
    pushl %ecx
    pushl %edx
    pushl %ebp
    movl  %esp, %ebp
    movl %es:(%di), %eax                 ## print starting addr
    push %eax
    call print_num_eax
    movl %ebp, %esp
    popl %ebp
    popl %eax
    popl %ecx
    popl %edx

    pushl %eax
    pushl %ecx
    pushl %edx
    pushl %ebp
    movl  %esp, %ebp
    lea const_str_blank_length, %eax
    pushl %eax   
    call print_string_eax 
    movl %ebp, %esp
    popl %ebp
    popl %eax
    popl %ecx
    popl %edx

    pushl %eax
    pushl %ecx
    pushl %edx
    pushl %ebp
    movl  %esp, %ebp
    movl %es:8(%di), %eax                ## print length
    pushl %eax
    call print_num_eax
    movl %ebp, %esp
    popl %ebp
    popl %eax
    popl %ecx
    popl %edx

    pushl %eax
    pushl %ecx
    pushl %edx
    pushl %ebp
    movl  %esp, %ebp
    lea const_str_address_status, %eax
    pushl %eax
    call print_string_eax
    movl %ebp, %esp
    popl %ebp
    popl %eax
    popl %ecx
    popl %edx

    movl %es:16(%di), %eax               ## mov mem_type into %eax
    add $24, %di                         ## to next entry
    cmpl $1, %eax
    je 2f
    cmpl $2, %eax
    je 3f
2:
    pushl %edx
    pushl %ecx
    lea const_str_memory_type_1, %eax
    popl %ecx
    popl %edx
    jmp 7f
3:
    lea const_str_memory_type_2, %eax
    jmp 7f
7:
    pushl %eax
    pushl %ecx
    pushl %edx
    pushl %ebp
    movl  %esp, %ebp
    pushl %eax
    call print_string_eax
    movl %ebp, %esp
    popl %ebp
    popl %eax
    popl %ecx
    popl %edx

    pushl %eax
    pushl %ecx
    pushl %edx
    pushl %ebp
    movl  %esp, %ebp
    lea  const_str_return, %eax
    pushl %eax
    call print_string_eax
    movl %ebp, %esp
    popl %ebp
    popl %eax
    popl %ecx
    popl %edx

    pushl %eax
    movl %ecx, %eax
    sub $1, %eax
    mov %eax, %ecx
    pop %eax
    jnz 1b
done:
    ret
const_addr_mem_map:
    .long 0x00008300