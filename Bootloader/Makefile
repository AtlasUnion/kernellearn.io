all: bootloader_mbr bootloader_stage1
bootloader_stage1:
	as --32 bootloader_stage1.s -o bootloader_stage1.o
	ld -T bootloader.ld bootloader_stage1.o -o bootloader_stage1
bootloader_mbr:
	as --32 bootloader_mbr.s -g -o bootloader_mbr.o
	ld -T bootloader_elf.ld bootloader_mbr.o -o bootloader_mbr
	objcopy -j .text -O binary bootloader_mbr real_bootloader_mbr
clean:
	rm bootloader_mbr bootloader_stage1 *.o
write_to_MBR:
	dd conv=notrunc if=./real_bootloader_mbr of=disk.img bs=512 count=1
write_stage1:
	dd conv=notrunc if=./bootloader_stage1 of=disk.img seek=512 bs=1 count=95
write_to_disk:
	make write_to_MBR
	make write_stage1
extract_sym:
	objcopy --only-keep-debug bootloader_mbr real_bootloader_mbr.sym