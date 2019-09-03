#ifndef INIT_H
#define INIT_H

#include <kernel/multiboot.h>

int start_all_init_routine(multiboot_info_t *mbd, unsigned int magic_num);
int init_mem_info(multiboot_info_t *mbd);
void setup_paging();

#endif