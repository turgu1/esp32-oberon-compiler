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

    #include "defs.S"

    .title Oberon ESP32 Startup code
    .sbttl Oberon ESP32 Compiler Version 0.1.0

    .global _call_start_cpu0
    .extern _sbss, _ebss, _sdata, _edata, _sidata, _sitable, _eitable

/* ---- stack ---- */

    .align 4
    .section .stack
    .space 16384

/* ---- application entry_point ---- */

    .section .entry.text

    j _call_start_cpu0

    .align 4

# Main entry point, as defined in the ld/esp32.ld file

_call_start_cpu0:

    # No interrupt vectors for now - TBD
    # movi a0, _init_start      # Set Interrupt vector base address
    # wsr  a0, VECBASE

    movi a1, _tos              # Set Top of stack
    movi a0, 0                 # Initialize return adress to nothing
    addi a1, a1, -16           # stack frame initialization only
    addi a4, sp, 16            #     call4 can be done as 1st call level
    s32e a4, sp, -12

    call4 _stop_watchdog       # Disable both Watchdog
    call4 _set_160mhz          # Set CPU Speed to 160MHz

    # Clear .bss section

    movi a2, _ebss             # Compute size in 4-byte chunks (a2)
    movi a3, _sbss             # a3 = address of .bss
    sub  a2, a2, a3            # a2 = size of .bss in bytes
    beqz a2, 1f                # if .bss is empty, nothing to do
    srli a2, a2, 2             # a2 = size of .bss in words
    movi a4, 0                 # a4 = 0
    loop a2, 1f                # loop to clear memory
    s32i a4, a3, 0             # @a3[0] = 0
    addi a3, a3, 4             # adjust a3 to next word
1:

.if 0
    # Copy initialized data (not used, seems to be done by the ROM loader)
    movi a2, _edata            # Compute size in 4-byte chunks (a2)
    movi a3, _sdata            # a3 = address of _data
    movi a4, _sidata           # a4 = address of initialization data
    sub  a2, a2, a3            # a2 = size of .data in bytes
    beqz a2, 2f                # if .data is empty, nothing to do
    srli a2, a2, 2             # a2 = size of .data in words
    loop a2, 2f                # loop to initialize memory
    l32i a5, a4, 0             # a5 = @a4[0]
    s32i a5, a3, 0             # @a3[0] = a5
    addi a4, a4, 4             # adjust a4 to next word
    addi a3, a3, 4             # adjust a3 to next word
2:
.endif

    # Call modules initialization code (From the last to the first one)
    # The first one is the main program. It is not expected to come back,
    # but if it does, Wathcdog will reset the processor if enabled.

    movi a3, _eitable          # compute size of init table - 4
    movi a2, _sitable          # a3 = init table address
    sub  a2, a3, a2            # a2 = size in bytes
    beqz a2, _init_end         # if table is empty, leave
    srli a2, a2, 2             # a2 = size in words
    loop a2, 3f                # loop for each table entry
    addi a3, a3, -4            # Adjust pointer in table
    l32i a7, a3, 0             # load init code address
    callx4 a7                  # call the module initialization code
    nop
3:

_init_end:
    j _init_end
    
/* ---- _stop_watchdog ---- */

    # Registers to disable both Watchdog
    .equ RTC_CNTL_WDTCONFIG0_REG, 0x3FF4808C
    .equ TIMG0_T0_WDTCONFIG0_REG, 0x3FF5F048

    .align 4

_stop_watchdog:
    entry a1, 16
    movi a2, 0
    movi a3, RTC_CNTL_WDTCONFIG0_REG
    s32i a2, a3, 0
    movi a3, TIMG0_T0_WDTCONFIG0_REG
    s32i a2, a3, 0
    retw

/* ---- _set_160mhz ---- */

    .equ RTC_CNTL_CLK_CONF_REG,  0x3FF48070
    .equ DPORT_CPU_PER_CONF_REG, 0x3ff0003C
    .equ CLKCONF,                0x08002210

    .align 4

_set_160mhz:
    entry a1, 16

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

#include "math_support.S"

#if 0
#include "interrupt_vectors.S"
#include "syscall.S"
#include "context.S"
#endif
