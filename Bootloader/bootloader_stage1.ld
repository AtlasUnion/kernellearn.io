OUTPUT_FORMAT("elf32-i386")
OUTPUT_ARCH(i386)
ENTRY(main)
SECTIONS
{
  . = 0x7E00;
  .text : { *(.text) }
}