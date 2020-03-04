/*
 * GNU linker script for Espressif ESP32 for the Oberon Compiler
 */

ENTRY(_init_start)

MEMORY {
  IRAM (RX) : ORIGIN = 0x40080400, LENGTH = 127K
  DRAM (RW) : ORIGIN = 0x3FFFF000, LENGTH = 200K + 128K
}

SECTIONS {

  .text : ALIGN(4)
  {
    . = ALIGN(16);
    _sitable = ABSOLUTE(.);
    KEEP (*(.init_table*))
    _eitable = ABSOLUTE(.);
    KEEP(*(.entry.text))
    KEEP(*(.entry.trap_support))
    *(.literal .text)
    *(.literal* .text*)
    . = ALIGN(4);
    KEEP (*(.init*))
    KEEP (*(.fini))
    . = ALIGN(4);
    _etext = ABSOLUTE(.);
  } >IRAM

  _sidata = .;
  .data : AT(_sidata) ALIGN(4) 
  {
    . = ALIGN(4);
    _sdata = ABSOLUTE(.);
    *(.data)
    *(.data_types*)
    *(.data_strs*)
    . = ALIGN(4);
    _edata = ABSOLUTE(.);
  } >DRAM

  .rodata : ALIGN(4)
  {
    *(.rodata)
    *(.rodata*)
  } >DRAM

  .bss (NOLOAD) : ALIGN(4)
  {
    . = ALIGN(4);
    KEEP(*(.__trap_support_data))
    _sbss = ABSOLUTE(.);
    *(.bss)
    *(.bss*)
    *(COMMON)
    . = ALIGN(4);
    _ebss = ABSOLUTE(.);
  } >DRAM

  end = .; PROVIDE (_end = .);
}

