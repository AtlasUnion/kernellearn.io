#include <kernel/mem_info.h>
#include <stdio.h>
#include <stddef.h>
#include <kernel/multiboot.h>
#include <stdint.h>

struct free_mem_entry free_mem_region[NUM_OF_FREE_REGIONS];

static void init_free_mem_region_entries()
{
	for (int i = 0; i < NUM_OF_FREE_REGIONS; i++)
	{
		free_mem_region[i].valid_bit = 0;
	}
}

int init_mem_info(multiboot_info_t *mbd)
{
	if ((mbd->flags & 0x40) == 0)
		return -1;

	init_free_mem_region_entries();

	multiboot_memory_map_t *mmap = (multiboot_memory_map_t *)(mbd->mmap_addr);
	multiboot_memory_map_t *end_addr = (multiboot_memory_map_t *)(mbd->mmap_addr + mbd->mmap_length);

	uint32_t index_in_free_mem_region_entries = 0;

	while (mmap < end_addr)
	{
		if (mmap->type == MULTIBOOT_MEMORY_AVAILABLE)
		{
			free_mem_region[index_in_free_mem_region_entries].valid_bit = 1;
			free_mem_region[index_in_free_mem_region_entries].entry_info = *mmap;
			index_in_free_mem_region_entries++;
		}

		mmap = (multiboot_memory_map_t *)((unsigned int)mmap + mmap->size + sizeof(mmap->size));
	}
	return 0;
}