#include <kernel/mem_alloc.h>
#include <iso646.h>
#include <stddef.h>

void free_pages(void *mem_to_free, uint32_t order)
{
	char *mem_to_be_free = mem_to_free;
	char *buddy;

	uint64_t size_of_block_at_order = (4 * 1024 * (1 << order));
	uint32_t mem_index = (uint32_t)mem_to_be_free / size_of_block_at_order;

	if ((mem_index bitand 1) == 0) // if odd
		buddy = mem_to_be_free + size_of_block_at_order;
	else // if even
		buddy = mem_to_be_free - size_of_block_at_order;

	void *buddy_free = has_entry(&free_area[order].list_head, buddy); // check if buddy is free

	if (buddy_free == NULL) // buddy is not free
	{
		add_to_head(&free_area[order].list_head, mem_to_be_free);
		free_area[order].num_free++;
	}
	else // buddy is free
	{
		remove_entry(&free_area[order].list_head, buddy); // remove buddy from current list
		// merge into bigger block
		if (buddy < mem_to_be_free)
		{
			free_pages(buddy, order + 1);
		}
		else
		{
			free_pages(mem_to_be_free, order + 1);
		}
	}
}