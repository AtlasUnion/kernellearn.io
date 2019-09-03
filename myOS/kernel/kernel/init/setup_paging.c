#include <kernel/init.h>
#include <kernel/page.h> // TODO: make it general case
#include <kernel/mem_info.h>

alignas(4096) pde_t page_directory[1024];
alignas(4096) pte_t first_four_MB_page_table[1024];

#define kernel_page_directory_starting_index ((PAGE_OFFSET) / KERNEL_PAGE_SIZE)

void enable_pse()
{
	asm("movl %cr4, %eax");
	asm("orl $0x10, %eax");
	asm("movl %eax, %cr4");
}

/**
 * set up proper page for kernel space
 * Map as follow:
 * v_addr 0 : 1G <-> p_addr 0xC0000000 : (0xC0000000 + 1G)
 */
void setup_page_map()
{
	for (int i = 768; i < 1024; i++)
	{
		page_directory[i] = __pde((0x400000 * (i - 768)) | 0x83);
	}

	unsigned long p_addr_of_page_directory = (unsigned long)(&page_directory) - 0xc0000000;
	asm("movl %0, %%eax"
		:
		: "b"(p_addr_of_page_directory)
		: "eax");
	asm("movl %eax, %cr3");
}

void setup_paging()
{
	enable_pse();
	setup_page_map();
}