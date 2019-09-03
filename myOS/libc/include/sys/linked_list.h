#ifndef LINKED_LIST_H
#define LINKED_LIST_H

typedef struct _LIST_ENTRY
{
	struct _LIST_ENTRY *next;
	struct _LIST_ENTRY *prev;
} LIST_ENTRY;

// assume head cannot be removed

void add_to_head(LIST_ENTRY *head, LIST_ENTRY *node_to_add);
void *remove_from_head(LIST_ENTRY *head);
void *remove_entry(LIST_ENTRY *head, LIST_ENTRY *entry_to_remove);
void *has_entry(LIST_ENTRY *head, LIST_ENTRY* entry_to_search);

#endif