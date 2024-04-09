OUTPUT_ARCH( "riscv" )
OUTPUT_FORMAT("elf32-littleriscv")
ENTRY( _start )

MEMORY
{
  ram (rwxai) : ORIGIN = 0x80000000, LENGTH = 0x8000000
}

SECTIONS
{
  /* text: test code section */
  . = 0x80000000;
  .text : { *(.text) }
  /* gnu_build_id: readonly build identifier */
  .gnu_build_id : { *(.note.gnu.build-id) }
  /* rodata: readonly data segment */
  .rodata : { *(.rodata) }

  /* data: Initialized data segment */
  . = 0x80001000;
  .data : { *(.data) }
  .sdata : { *(.sdata) }
  .debug : { *(.debug) }
  . += 0x1000;
  stack_top = .;

  /* End of uninitalized data segement */
  _end = .;
}