#ifndef I386_PAGE_H
#define I386_PAGE_H

#define SIZE_OF_ZONE_NORMAL (896 * 1024 * 1024)
#define SIZE_OF_MAX_SPACE (4 * 1024 * 1024 * 1024)
#define KERNEL_PAGE_SIZE (4 * 1024 * 1024)

#include <stdalign.h>

typedef struct // define page table entry
{
	unsigned long pte;
} pte_t;

typedef struct // define page directory entry
{
	unsigned long pde;
} pde_t;

extern alignas(4096) pde_t page_directory[1024];
extern alignas(4096) pte_t first_four_MB_page_table[1024];

#define pte_val(x) ((x).pte)
#define pde_val(x) ((x).pde)

#define __pte(x) ((pte_t){x})
#define __pde(x) ((pde_t){x})

#define PAGE_OFFSET 0xC0000000

#endif