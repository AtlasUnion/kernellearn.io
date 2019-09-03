#include <sys/linked_list.h>
#include <stddef.h>

void *has_entry(LIST_ENTRY *head, LIST_ENTRY *entry_to_search)
{
	LIST_ENTRY *current_entry = head->next;

	while (current_entry != NULL)
	{
		if (current_entry == entry_to_search)
		{
			return current_entry;
		}

		current_entry = current_entry->next;
	}

	return NULL;
}