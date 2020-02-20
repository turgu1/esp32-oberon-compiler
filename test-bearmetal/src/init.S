# ----
# Oberon Compiler
#
# Bear Metal Trial
# Main initializing code
#
# Guy Turcotte
# 2020.02.18
#
# Oberon Modules are compiled with the following memory organisation:
#
# - Constants that cannot be kept in registers are put in the
#   .data section (maybe .rodata in the future...)
#
# - Main code of a Module is put in an .init section. All init 
#   sections (but the first) will be called in sequence to 
#   initialize modules. The first module in the list is considered
#   the main module and its initialization code will be launched
#   at the end.
#
# - One entry in the .init_table section must be defined to point
#   at the module initialization code. Not required if the 
#   initialization is empty
#
# - All procedural code is put in a .text section
#
# - Global variables are placed in a .bss section. They will be
#   initialized with zeroes by this code.
#
# - All procedure and initialization code must be using 
#   the ENTRY A1, xxxx and RETW instructions (Windowing option).
# ----

    .global _init_start
    .extern _sbss, _ebss, _sdata, _edata, _sidata, _sitable, _eitable

    .section .entry.text

    j _init_start

    .align 4

# Main entry point, as defined in the ld/esp32.ld file

_init_start:

    call4 _stop_watchdog      # Disable both Watchdog
    call4 _set_160mhz         # Set CPU Speed to 160MHz

    # Clear .bss section

    movi a2, _ebss            # Compute size in 4-byte chunks (a2)
    movi a3, _sbss            # a3 = address of .bss
    sub  a2, a2, a3           # a2 = size of .bss in bytes
    beqz a2, loop_1           # if .bss is empty, nothing to do
    srli a2, a2, 2            # a2 = size of .bss in words
    movi a4, 0                # a4 = 0
    loop a2, loop_1           # loop to clear memory
    s32i a4, a3, 0            # @a3[0] = 0
    addi a3, a3, 4            # adjust a3 to next word
loop_1:

    # Copy initialized data

    movi a2, _edata            # Compute size in 4-byte chunks (a2)
    movi a3, _sdata            # a3 = address of _data
    movi a4, _sidata           # a4 = address of initialization data
    sub  a2, a2, a3            # a2 = size of .data in bytes
    beqz a2, loop_2            # if .data is empty, nothing to do
    srli a2, a2, 2             # a2 = size of .data in words
    loop a2, loop_2            # loop to initialize memory
    l32i a5, a4, 0             # a5 = @a4[0]
    s32i a5, a3, 0             # @a3[0] = a5
    addi a4, a4, 4             # adjust a4 to next word
    addi a3, a3, 4             # adjust a3 to next word
loop_2:

    # Call modules initialization code (but the first one)

    movi a2, _eitable          # compute size of init table - 4
    movi a3, _sitable          # a3 = init table address
    addi a3, a3, 4             # pass the first entry
    sub  a2, a2, a3            # a2 = size in bytes
    bltz a2, _init_end         # if table is empty, leave
    beqz a2, loop_3            # if there is only one module, it is the main one
    srli a2, a2, 2             # a2 = size in words
    loop a2, loop_3            # loop for each table entry
    l32i a4, a3, 0             # load init code address
    callx4 a4                  # call the module initialization code
    addi a3, a3, 4             # adjust for next table entry
loop_3:

    # Call main module init code

    movi a2, _sitable          # get init table address
    l32i a2, a2, 0             # retrieve the init code adress
    callx4 a2                  # call main module initialization code

_init_end:
    j _init_end                # never return. May reboot if watchdog enabled.


# ---- _stop_watchdog ----

    # Registers to disable both Watchdog
    .equ RTC_CNTL_WDTCONFIG0_REG, 0x3FF4808C
    .equ TIMG0_T0_WDTCONFIG0_REG, 0x3FF5F048

    .align 4

_stop_watchdog:
    entry a1, 0
    movi a2, 0
    movi a3, RTC_CNTL_WDTCONFIG0_REG
    s32i a2, a3, 0
    movi a3, TIMG0_T0_WDTCONFIG0_REG
    s32i a2, a3, 0
    retw

# ---- _set_160mhz ----

    .equ RTC_CNTL_CLK_CONF_REG,  0x3FF48070
    .equ DPORT_CPU_PER_CONF_REG, 0x3ff0003C
    .equ CLKCONF,                0x08002210

    .align 4

_set_160mhz:
    entry a1, 0

    # Switch SoC clock source to PLL (instead of the default which is XTAl).
    # This switches the CPU (and APB) clock from 40MHz to 80MHz.
    movi a2, RTC_CNTL_CLK_CONF_REG
    movi a3, CLKCONF
    s32i a3, a2, 0

    # Switch CPU from 80MHz to 160MHz
    movi a2, DPORT_CPU_PER_CONF_REG
    movi a3, 1
    s32i a3, a2, 0

    retw 