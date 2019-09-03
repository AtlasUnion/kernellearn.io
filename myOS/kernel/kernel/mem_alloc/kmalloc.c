#include <kernel/mem_alloc.h>
#include <stddef.h>

// TODO: optimize e.g write log function
void *kmalloc(uint32_t request_bytes)
{
	if (request_bytes == 0)
		return NULL;
	uint32_t pages_to_request = (request_bytes / PAGE_SIZE) + (request_bytes % PAGE_SIZE != 0);

	uint32_t page_order = 0;

	while ((1 << page_order) < pages_to_request)
	{
		page_order++;
	}

	return alloc_pages(page_order);
}