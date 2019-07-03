AS=as
ASFLAGS=--32
OBJECTS=$(patsubst %.s, %.o, $(wildcard *.s)) $(wildcard *.e) $(wildcard *.intermediate)
OUTPUT_DIR=./build

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
	dd conv=notrunc if=./real_bootloader_mbr of=disk.img bs=512 count=1
write_stage1:
	dd conv=notrunc if=./bootloader_stage1 of=disk.img seek=512 bs=1 count=95
write_to_disk:
	make write_to_MBR
	make write_stage1
extract_sym:
	objcopy --only-keep-debug bootloader_mbr real_bootloader_mbr.symls
start: write_to_disk