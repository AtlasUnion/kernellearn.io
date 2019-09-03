#include <sys/linked_list.h>
#include <stddef.h>

void *remove_entry(LIST_ENTRY *head, LIST_ENTRY *entry_to_remove)
{
	LIST_ENTRY *prev_entry = head;
	LIST_ENTRY *current_entry = head->next;

	while (current_entry != NULL)
	{
		if (current_entry == entry_to_remove)
		{
			prev_entry->next = current_entry->next;
			if (current_entry->next != NULL)
			{
				current_entry->next->prev = prev_entry;
			}
			current_entry->prev = NULL;
			current_entry->next = NULL;
		}
		else
		{
			prev_entry = current_entry;
			current_entry = current_entry->next;
		}
	}

	return entry_to_remove;
}