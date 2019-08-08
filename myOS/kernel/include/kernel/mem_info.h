#ifndef MEM_INFO_H
#define MEM_INFO_H
#include <kernel/multiboot.h>
#define NUM_OF_FREE_REGIONS 4
struct free_mem_entry
{
	struct multiboot_mmap_entry entry_info;
	char valid_bit;
};

extern struct free_mem_entry free_mem_region[NUM_OF_FREE_REGIONS];

int init_mem_info(multiboot_info_t *mbd);

unsigned int get_total_memory_size(multiboot_info_t *mbd, char flag);

#endif
