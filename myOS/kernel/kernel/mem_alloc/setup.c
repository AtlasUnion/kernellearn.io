#include <kernel/mem_alloc.h>
#include <kernel/mem_info.h>
#include <stddef.h>

struct free_area free_area[MAX_ORDER];

void setup()
{
	char *current_addr;
	LIST_ENTRY *current_entry[MAX_ORDER];
	uint64_t current_length;

	for (int i = 0; i < MAX_ORDER; i++) // init array of entry
	{
		current_entry[i] = &(free_area[i].list_head);
	}

	for (int i = 0; i < NUM_OF_FREE_REGIONS; i++)
	{
		if (!free_mem_region[i].valid_bit)
		{ // reach maximum region
			break;
		}

		current_addr = (char *)free_mem_region[i].entry_info.addr;
		current_length = free_mem_region[i].entry_info.len;

		for (int j = MAX_ORDER - 1; j >= 0; j--) // start from max order to order = 0
		{
			uint64_t size_of_block_at_order = (PAGE_SIZE * (1 << j));
			uint16_t number_of_entry_to_write = (uint16_t)(current_length / size_of_block_at_order);

			if (number_of_entry_to_write < 1)
			{
				continue;
			}

			current_length = current_length - (number_of_entry_to_write * size_of_block_at_order);
			free_area[j].num_free += number_of_entry_to_write;

			for (int k = 0; k < number_of_entry_to_write; k++)
			{
				LIST_ENTRY new_entry = {.next = NULL, .prev = current_entry[j]};
				*((LIST_ENTRY *)current_addr) = new_entry;
				current_entry[j]->next = current_addr;
				current_entry[j] = current_addr;
				current_addr = current_addr + size_of_block_at_order;
			}
		}
	}
}