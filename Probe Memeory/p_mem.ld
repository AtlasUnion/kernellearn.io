OUTPUT_FORMAT("binary")
OUTPUT_ARCH(i386)
ENTRY(main)
SECTIONS
{
  . = 0x7C00;
  .prog : { *(.text) }
}