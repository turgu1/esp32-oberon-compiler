/*
 * GNU linker script for Espressif ESP32 for the Oberon Compiler
 */

ENTRY(_call_start_cpu0)

MEMORY {
  IRAM (RX) : ORIGIN = 0x40080400, len = 127K
  DRAM (RW) : ORIGIN = 0x3FFB0000, len = 192K
}

_heap_end = 0x3FFB0000 + 192K;

SECTIONS {

  .iram.text : ALIGN(4)
  {
    . = ALIGN(16);
    _iram_start = ABSOLUTE(.);

    /* Vectors go to IRAM 
    _init_start = ABSOLUTE(.);
    . = 0x0;
    KEEP(*(.WindowVectors.text));
    . = 0x180;
    KEEP(*(.Level2InterruptVector.text));
    . = 0x1c0;
    KEEP(*(.Level3InterruptVector.text));
    . = 0x200;
    KEEP(*(.Level4InterruptVector.text));
    . = 0x240;
    KEEP(*(.Level5InterruptVector.text));
    . = 0x280;
    KEEP(*(.Level6InterruptVector.text));
    . = 0x2c0;
    KEEP(*(.NMIExceptionVector.text));
    . = 0x300;
    KEEP(*(.KernelExceptionVector.text));
    . = 0x340;
    KEEP(*(.UserExceptionVector.text));
    . = 0x3C0;
    KEEP(*(.DoubleExceptionVector.text));
    . = 0x400;
    */

    KEEP (*(.iram1))

    . = ALIGN(4);
    _sitable = .;
    KEEP (*(.init_table*))
    _eitable = .;
    _sptable = .;
    KEEP (*(.pointers_table*))
    _eptable = .;
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
  } >IRAM

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
  } >DRAM

  .bss (NOLOAD) : ALIGN(4)
  {
    . = ALIGN(4);
    _sbss = .;
    *(.bss)
    *(.bss*)
    *(COMMON)
    _bos = .;
    *(.stack)
    _tos = .;
    . = ALIGN(4);
    _ebss = .;
    _heap_start = .;
  } >DRAM

  . = ALIGN(4);
  PROVIDE ( end = .);
  PROVIDE (_end = .);
}

