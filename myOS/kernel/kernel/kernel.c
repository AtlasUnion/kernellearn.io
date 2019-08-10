#include <stdio.h>
#include <kernel/tty.h>
#include <kernel/multiboot.h>
#include <kernel/mem_info.h>

void kernel_main(multiboot_info_t *mbd, unsigned int magic_num)
{
	terminal_initialize();
	printf("Hello World of Kernel! Welcome to my OS!\n");
	printf("The magic number is %X, in decimal is %d\n\n", magic_num, magic_num);

	multiboot_uint32_t flags = mbd->flags;

	if ((flags & 0x41) != 0x41) // check for mem_info flags on
	{
		printf("Error: No memory information. Exiting\n");
		return;
	}

	unsigned int total_mem_length_in_mb = (mbd->mem_upper + mbd->mem_lower) / 1024 + 1;
	printf("System Memory: %u MB \n", total_mem_length_in_mb);
	printf("Lower Mem: %u MB\n", (mbd->mem_lower) / 1024 + 1);
	printf("Upper Mem: %u MB\n", (mbd->mem_upper) / 1024 + 1);

	init_mem_info(mbd);
	get_total_memory_size(mbd, 1);
}