#include <kernel/mem_alloc.h>
#include <sys/linked_list.h>
#include <stddef.h>

void *alloc_pages(uint32_t order, uint32_t memory_request_flags)
{
	if (order >= MAX_ORDER)
		return NULL;
	if (free_area[order].num_free != 0)
	{
		free_area[order].num_free--;
		void *to_return = remove_from_head(&(free_area[order].list_head));
		return to_return;
	}

	char *order_plus_one = alloc_pages(order + 1, memory_request_flags);

	if (order_plus_one == NULL)
		return NULL;

	uint64_t size_of_block_at_order = (4 * 1024 * (1 << order));

	LIST_ENTRY *first_entry = order_plus_one;
	LIST_ENTRY *second_entry = order_plus_one + size_of_block_at_order;

	add_to_head(&(free_area[order].list_head), second_entry);
	free_area[order].num_free++;
	return first_entry;
}