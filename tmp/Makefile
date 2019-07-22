AS=~/opt/cross/bin/i686-elf-as
ASFLAGS=--32 -g
OBJECTS=$(patsubst %.s, %.o, $(wildcard *.s)) $(wildcard *.e) $(wildcard *.intermediate) $(wildcard *.sym)
OUTPUT_DIR=./build
CC=~/opt/cross/bin/i686-elf-gcc
CC_FLAGS=-g -ffreestanding
LD=~/opt/cross/bin/i686-elf-ld
all: kernel.e

kernel.e: kernel.intermediate
	objcopy -j .text -O binary kernel.intermediate kernel.e
kernel.intermediate: kernel.o kernel_start.o
	$(LD) -T kernel.ld kernel_start.o kernel.o -o kernel.intermediate
kernel.o: kernel.c
	$(CC) $(CC_FLAGS) -c kernel.c -o kernel.o
kernel_start.o:
	$(AS) $(ASFLAGS) kernel_start.s -o kernel_start.o
clean:
	rm $(OBJECTS)
	
