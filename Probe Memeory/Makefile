all:
	as --32 p_mem.s -o p_mem.o
	ld -T p_mem.ld p_mem.o -o p_mem
clean:
	rm p_mem p_mem.o
write_to_MBR:
	dd conv=notrunc if=./p_mem of=../disk.img bs=440 count=1