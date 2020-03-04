/*
 * GNU linker script for Espressif ESP32 for the Oberon Compiler
 */

ENTRY(_init_start)

MEMORY {
  CODE_RAM (RX) : ORIGIN = 0x40080400, len = 0xFC00
  DATA_RAM (RW) : ORIGIN = 0x3FFFF000, len = 0x1000
}

SECTIONS {

  .iram.text : ALIGN(4)
  {
    . = ALIGN(16);
    _sitable = .;
    KEEP (*(.init_table*))
    _eitable = .;
    *(.entry.text)
    *(.entry.trap_support)
    *(.text)
    *(.text*)
    . = ALIGN(4);
    KEEP (*(.init*))
    KEEP (*(.fini))
    *(.rodata)
    *(.rodata*)
    . = ALIGN(4);
    _etext = .;
  } >CODE_RAM

  _sidata = .;
  .data : AT(_sidata) ALIGN(4) 
  {
    . = ALIGN(4);
    _sdata = .;
    KEEP (*(.data))
    *(.data*)
    *(._trap_support_data)
    . = ALIGN(4);
    _edata = .;
  } >DATA_RAM

  .bss (NOLOAD) : ALIGN(4)
  {
    . = ALIGN(4);
    _sbss = .;
    *(.bss)
    *(.bss*)
    *(COMMON)
    . = ALIGN(4);
    _ebss = .;
  } >DATA_RAM

  . = ALIGN(4);
  PROVIDE ( end = .);
  PROVIDE (_end = .);
}

