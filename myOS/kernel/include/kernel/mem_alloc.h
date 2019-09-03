#ifndef MEM_ALLOC_H
#define MEM_ALLOC_H

#define MAX_ORDER 11
#define PAGE_SIZE (4 * 1024)
#define MAX_MEMORY_SIZE_IN_BYTES (4 * 1024 * 1024 * 1024)

#include <stdint.h>
#include <sys/linked_list.h>

#define atomic_t unsigned long // NOTE: placeholder

//TODO: implement semaphore

struct page
{
	uint32_t flags;
	atomic_t count;
};

struct page memory_array[MAX_MEMORY_SIZE_IN_BYTES / PAGE_SIZE];

struct free_area
{
	LIST_ENTRY list_head;
	uint32_t num_free;
};

enum memory_request_flags
{
	ZONE_NORMAL = 0 << 1,
	ZONE_HIGHMEM = 1 << 1
};

extern struct free_area free_area[MAX_ORDER];

// TODO: rewrite alloc_pages with struct page instead of free_area

void *kmalloc(uint32_t request_bytes);
void kfree(void *memory);
void *vmalloc(uint32_t request_bytes);
void *alloc_pages(uint32_t order, uint32_t memory_request_flags); // alloc and return physical page
void free_pages(void *mem_to_free, uint32_t order);				  // free physical page
void *get_free_pages(uint32_t order);							  // alloc and return virtual page
void setup();

#endif