OUTPUT_FORMAT("elf64-x86-64")
ENTRY(main)
SECTIONS
{
  . = 0x0;
  .text : { *(.text) }
}