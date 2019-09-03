#include <kernel/init.h>

int start_all_init_routine(multiboot_info_t *mbd, unsigned int magic_num)
{
	init_mem_info(mbd);
	setup_paging();
}