#include <sys/linked_list.h>
#include <stddef.h>

void add_to_head(LIST_ENTRY *head, LIST_ENTRY *node_to_add)
{
	if (head->next == NULL)
	{
		node_to_add->next = head->next;
		node_to_add->prev = head;
		head->next = node_to_add;
		return;
	}
	LIST_ENTRY *old_next = head->next;
	head->next = node_to_add;
	node_to_add->next = old_next;
	node_to_add->prev = head;
	old_next->prev = node_to_add;
}