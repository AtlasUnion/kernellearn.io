AS=as
ASFLAGS=--32
OBJECTS=$(patsubst %.o)

all: bootloader_mbr bootloader_stage1
bootloader_stage1: bootloader_stage1.o
	ld -T bootloader.ld bootloader_stage1.o -o bootloader_stage1
bootloader_mbr: bootloader_mbr.o
	ld -T bootloader_elf.ld bootloader_mbr.o -o bootloader_mbr
	objcopy -j .text -O binary bootloader_mbr real_bootloader_mbr
%.o: %.s
	$(AS) $(ASFLAGS) $< -o $@ 
clean:
	@rm bootloader_mbr bootloader_stage1 $(OBJECTS)
write_to_MBR:
	dd conv=notrunc if=./real_bootloader_mbr of=disk.img bs=512 count=1
write_stage1:
	dd conv=notrunc if=./bootloader_stage1 of=disk.img seek=512 bs=1 count=95
write_to_disk:
	make write_to_MBR
	make write_stage1
extract_sym:
	objcopy --only-keep-debug bootloader_mbr real_bootloader_mbr.sym