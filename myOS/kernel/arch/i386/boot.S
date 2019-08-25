# Declare constants for the multiboot header.
.set ALIGN,    1<<0             # align loaded modules on page boundaries
.set MEMINFO,  1<<1             # provide memory map
.set FLAGS,    ALIGN | MEMINFO  # this is the Multiboot 'flag' field
.set MAGIC,    0x1BADB002       # 'magic number' lets bootloader find the header
.set CHECKSUM, -(MAGIC + FLAGS) # checksum of above, to prove we are multiboot
.set KERNEL_VMA, 0xC0000000
.set KERNEL_LMA, 0x00100000
.set ADDR_OFFSET, (KERNEL_VMA - KERNEL_LMA)
# Declare a header as in the Multiboot Standard.
.section .multiboot
.align 4
.long MAGIC
.long FLAGS
.long CHECKSUM

# Reserve a stack for the initial thread.
.section .bss, "aw", @nobits
.align 4096
boot_page_directory:
.skip 4096
boot_page_table_1:
.skip 4096
boot_page_table_2:
.skip 4096

.section .bootstrap_stack, "aw", @nobits
.align 16
stack_bottom:
.skip 16384 # 16 KiB
stack_top:


# The kernel entry point.
.section .text
.global _start
_start:
	movl $stack_top, %esp
kernel_early_main:
# Setup Paging (Must do first; otherwise cannot jump nor call)
setup_boot_page_table_1:
	movl $(boot_page_table_1 - ADDR_OFFSET), %edi
	movl $0, %esi
	movl $1024, %ecx
1:
	cmpl $(kernel_end - ADDR_OFFSET), %esi // beyond kernel
	jge 3f

	movl %esi, %edx
	orl  $0x003, %edx
	movl %edx, (%edi)
2:
	addl $4096, %esi
	addl $4, %edi
	loop 1b
setup_boot_page_table_2:
3:
	movl $(boot_page_table_2 - ADDR_OFFSET), %edi
	movl $0x00100000, %esi
	movl $1024, %ecx
1:
	cmpl $(kernel_end - ADDR_OFFSET), %esi // beyond kernel
	jge 3f

	movl %esi, %edx
	orl  $0x003, %edx
	movl %edx, (%edi)
2:
	addl $4096, %esi
	addl $4, %edi
	loop 1b
3:
	movl $(boot_page_table_1 - ADDR_OFFSET + 0x003), boot_page_directory - ADDR_OFFSET + 0
	movl $(boot_page_table_2 - ADDR_OFFSET + 0x003), boot_page_directory - ADDR_OFFSET + 768*4
	movl $(boot_page_directory - ADDR_OFFSET), %ecx
	movl %ecx, %cr3
	movl %cr3, %ecx

	movl %cr0, %ecx
	orl $0x80000000, %ecx
	movl %ecx, %cr0

	lea 4f, %ecx
	jmp *%ecx
4:
	movl %eax, (magic_num)		# preserce magic number and multiboot_addr
	movl %ebx, (multiboot_addr)
	call _init

	# setup GDT
	lgdt gdt_ptr
	ljmp $0x08, $1f
1:	
	movw $0x10, %ax
	movw %ax, %ss
	movw %ax, %ds
	movw %ax, %es
	movw %ax, %fs
	movw %ax, %gs
	# TODO: setup IDT
	# Transfer control to the main kernel.
	push (magic_num)
	push (multiboot_addr)
	movl %cr4, %eax
	cli 
	call kernel_main

	# Hang if kernel_main unexpectedly returns.
	cli
1:	hlt
	jmp 1b
.size _start, . - _start

.section .data
gdt:
	.long 0
	.long 0
code_seg:
	.long 0x0000FFFF
	.long 0x00CF9A00
data_seg:
	.long 0x0000FFFF
	.long 0x00CF9200
gdt_ptr:
	.short 0x17
	.long gdt
magic_num:
	.long 0x0
multiboot_addr:
	.long 0x0