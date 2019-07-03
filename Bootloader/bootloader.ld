OUTPUT_FORMAT("binary")
OUTPUT_ARCH(i386)
ENTRY(main)
SECTIONS
{
  . = 0x7E00;
  .text : { *(.text) }
}