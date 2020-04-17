# ----
# Oberon ESP32 Compiler
#
# Main initializing code
#
# Guy Turcotte
# 2020.02.18
#
# Oberon Modules are compiled with the following memory organisation:
#
# - Constants that cannot be kept in registers are put in
#   .rodata sections 
#
# - Main code of a Module is put in .text_init sections. All init 
#   sections will be called in reverse sequence order to 
#   initialize modules. The first module in the list is considered
#   the main module and its initialization code is not expected to return.
#
# - Entries in the .text_init_table section must be defined to point
#   at each module initialization code. Program OIOrderESP32 is used to
#   automate the creation of this table.
#
# - All procedural code is put in .text... sections
#
# - Global variables are placed in .bss sections. They will be
#   initialized with zeroes by the ROM loader.
#
# - All procedure and initialization code must be using 
#   the ENTRY a1, xxxx and RETW instructions (Windowing option).
# ----

    .title Oberon ESP32 Startup code
    .sbttl Oberon ESP32 Compiler Version 0.2.0

    .global oberon_startup
    .section .entry.text

    .extern _sitable, _eitable

  oberon_startup:

    entry sp, 16

    # Call modules initialization code (From the last to the first one)
    # The first one is the main program. It is not expected to come back,
    # but if it does, it will return to the calling program.

    # compute size of init table

    movi a3, _eitable          # a3 = init table end address
    movi a2, _sitable          # a2 = init table start address
    sub  a2, a3, a2            # a2 = size in bytes
    beqz a2, _init_end         # if table is empty, leave
    srli a2, a2, 2             # a2 = size in 32bits words

    # initialize all modules

    loop a2, 1$                # loop for each table entry
    addi a3, a3, -4            # Adjust pointer in table
    l32i a7, a3, 0             # load init code address
    callx4 a7                  # call the module initialization code
    nop
  1$:

  _init_end:
    retw
    
