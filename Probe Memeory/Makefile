all:
	as --32 -g p_mem.s -o p_mem.o
	ld -T p_mem.ld p_mem.o -o p_mem.intermediate
	objcopy -j .text -O binary p_mem.intermediate p_mem.e
clean:
	rm p_mem.e p_mem.o p_mem.intermediate p_mem.sym
write_to_MBR:
	dd conv=notrunc if=./p_mem of=../disk.img bs=440 count=1
extract_sym:
	objcopy --only-keep-debug p_mem.intermediate p_mem.sym