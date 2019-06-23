.globl print_num_eax
.code16

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
