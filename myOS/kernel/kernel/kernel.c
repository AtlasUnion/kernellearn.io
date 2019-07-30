#include <stdio.h>
#include <kernel/tty.h>
#include <kernel/multiboot.h>

void kernel_main(multiboot_info_t *mbd, unsigned int magic_num)
{
	terminal_initialize();
	printf("Hello World of Kernel! Welcome to my OS!\n");
	printf("The magic number is %X\n", magic_num);
}