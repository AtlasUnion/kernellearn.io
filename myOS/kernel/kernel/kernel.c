#include <stdio.h>
#include <kernel/tty.h>
#include <kernel/multiboot.h>
#include <kernel/mem_info.h>
#include <stdint.h>
#include <kernel/mem_alloc.h>
#include <iso646.h>
#include <kernel/init.h>

void print_kernel_usable_mem()
{
	printf("Printing kernel usable\n");

	for (int i = 0; i < NUM_OF_FREE_REGIONS; i++)
	{
		if (free_mem_region[i].valid_bit)
		{
			printf("Start addr: %llX len: %llX\n", free_mem_region[i].entry_info.addr, free_mem_region[i].entry_info.len);
		}
	}
}

void mem_init(multiboot_info_t *mbd)
{
	multiboot_uint32_t flags = mbd->flags;

	if ((flags bitand 0x41) != 0x41) // check for mem_info flags on
	{
		printf("Error: No memory information. Exiting\n");
		return;
	}
	unsigned int total_mem_length_in_mb = (mbd->mem_upper + mbd->mem_lower) / 1024 + 1;
	printf("System Memory: %u MB \n", total_mem_length_in_mb);
	printf("Lower Mem: %u MB\n", (mbd->mem_lower) / 1024 + 1);
	printf("Upper Mem: %u MB\n", (mbd->mem_upper) / 1024 + 1);

	init_mem_info(mbd);
	print_kernel_usable_mem();
	// setup();
}

void kernel_main(multiboot_info_t *mbd, unsigned int magic_num)
{
	terminal_initialize();
	printf("Initializing Memory Info...\n");
	start_all_init_routine(mbd, magic_num);
	print_kernel_usable_mem();
	printf("Memory Info initialized\n\n");
}