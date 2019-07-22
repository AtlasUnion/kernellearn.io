AS=~/opt/cross/bin/i686-elf-as
ASFLAGS=-g
OBJECTS=$(patsubst %.s, %.o, $(wildcard *.s)) $(wildcard *.e) $(wildcard *.intermediate) $(wildcard *.sym)
OUTPUT_DIR=./build
STAGE_ONE_SIZE=$(shell stat bootloader_stage1.e | grep -Eo 'Size: [0-9]*' | grep -Eo '[0-9]*')

all: bootloader_mbr.e bootloader_stage1.e

.PRECIOUS: %.o %.intermediate

%.o: %.s
	$(AS) $(ASFLAGS) $< -o $@ 
%.intermediate: %.ld %.o 
	ld -T $^ -o $@
%.e: %.intermediate
	objcopy -j .text -O binary $< $@
clean:
	rm $(OBJECTS)
write_to_MBR:
	dd conv=notrunc if=./bootloader_mbr.e of=../disk.img bs=512 count=1
write_stage1:
	dd conv=notrunc if=./bootloader_stage1.e of=../disk.img seek=512 bs=1 count=$(STAGE_ONE_SIZE)
write_to_disk:
	make write_to_MBR
	make write_stage1
extract_sym_mbr:
	objcopy --only-keep-debug bootloader_mbr.intermediate bootloader_mbr.sym
extract_sym_stage1:
	objcopy --only-keep-debug bootloader_stage1.intermediate bootloader_stage1.sym