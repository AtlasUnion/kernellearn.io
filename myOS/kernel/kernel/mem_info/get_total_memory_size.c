#include <kernel/mem_info.h>
#include <stdio.h>
#include <stdint.h>

// return total memory size in MB

uint64_t get_total_memory_size(multiboot_info_t *mbd, char flag)
{
	uint64_t total_mem_size = 0;

	for (int i = 0; i < NUM_OF_FREE_REGIONS; i++)
	{
		if (free_mem_region[i].valid_bit)
		{
			total_mem_size += free_mem_region[i].entry_info.len;
		}
	}

	total_mem_size = (total_mem_size / 1024 / 1024);
	return total_mem_size;
}