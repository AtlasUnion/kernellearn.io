#include <sys/linked_list.h>
#include <stddef.h>

void *remove_from_head(LIST_ENTRY *head)
{
	if (head->next == NULL)
	{
		return NULL;
	}

	LIST_ENTRY *node_to_remove = head->next;
	head->next = node_to_remove->next;
	if (node_to_remove->next != NULL)
	{
		node_to_remove->next->prev = head;
	}
	node_to_remove->next = NULL;
	node_to_remove->prev = NULL;

	return node_to_remove;
}