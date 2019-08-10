#include <kernel/mem_info.h>
#include <stdio.h>
#include <stdint.h>

struct free_mem_entry free_mem_region[NUM_OF_FREE_REGIONS];


int init_mem_info(multiboot_info_t *mbd)
{
	free_mem_region[0].valid_bit = 0;
	free_mem_region[1].valid_bit = 0;

	if (((mbd->flags) & 0x40) == 0) // no memory map info
		return -1;

	multiboot_memory_map_t *mmap = (multiboot_memory_map_t *)(mbd->mmap_addr);
	multiboot_memory_map_t *end_addr = (multiboot_memory_map_t *)(mbd->mmap_addr + mbd->mmap_length);

	int index_in_free_mem_region = 0;

	while (mmap < end_addr)
	{
		if (mmap->type == MULTIBOOT_MEMORY_AVAILABLE)
		{
			free_mem_region[index_in_free_mem_region].entry_info = *mmap;
			free_mem_region[index_in_free_mem_region].valid_bit = 1;
			index_in_free_mem_region++;

			printf("Base Address: 0x%llX Length %llX\n", mmap->addr, mmap->len);
		}
		mmap = (multiboot_memory_map_t *)((unsigned int)mmap + mmap->size + sizeof(mmap->size));
	}
	printf("Total seg of free mem is %u\n\n", index_in_free_mem_region);

	return 0;
}

unsigned int get_total_memory_size(multiboot_info_t *mbd, char flag)
{
	unsigned int totalsize = (mbd->mem_upper + mbd->mem_lower) / 1024 + 1;
	return totalsize;
}