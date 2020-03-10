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

    .equ init_data, 0        # ESP32 loader is doing it
    .equ math_support, 1
    .equ trap_support, 1

    .title Oberon ESP32 Startup code
    .sbttl Oberon ESP32 Compiler Version 0.1.0

    .global _init_start
    .extern _sbss, _ebss, _sdata, _edata, _sidata, _sitable, _eitable

    .section .entry.text

    j _init_start

    .align 4

# Main entry point, as defined in the ld/esp32.ld file

_init_start:

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

.if init_data
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

.if trap_support
    addi a1, a1, -4
    s32i a2, a1, 0
    movi a2, 99                 # Trap reason 99: End of program, restart
    j __TRAP__
.else
    j _init_end
.endif
    
# ---- _stop_watchdog ----

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

# ---- _set_160mhz ----

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

.if trap_support
    .align 4
    .section ._trap_support_data

_a0:       .int 0
_a1:       .int 0
_a2:       .int 0
_a3:       .int 0
_a4:       .int 0
_a5:       .int 0
_a6:       .int 0
_a7:       .int 0
_a8:       .int 0
_a9:       .int 0
_a10:      .int 0
_a11:      .int 0
_a12:      .int 0
_a13:      .int 0
_a14:      .int 0
_a15:      .int 0
_raison:   .int 0
_startTOS: .int 0

    .align 4
    .section .entry.trap_support
    .global __TRAP__

    # The __TRAP__ routine must be called with a jump instruction.
    # On the stack, one 32 bit value contains register a2.
    # Register a2 contains the reason for this trap.
    # Registers are saved and control is passed back to the start program.

__TRAP__:
    addi a1, a1, -4     # Some space to save a2
    s32i a2, a1, 0
    movi a2, ._trap_support_data

    # Save all registers

    s32i a0, a2, 0      # save a0
    s32i a1, a2, 4      # save a1
    s32i a3, a2, 12     # save a3
    l32i a3, a1, 4      # load saved a2 in a3
    s32i a3, a2, 8      # save a2
    s32i a4, a2, 16     # save a4
    s32i a5, a2, 20     # save a5
    s32i a6, a2, 24     # save a6
    s32i a7, a2, 28     # save a7
    s32i a8, a2, 32     # save a8
    s32i a9, a2, 36     # save a9
    s32i a10, a2, 40    # save a10
    s32i a11, a2, 44    # save a11
    s32i a12, a2, 48    # save a12
    s32i a13, a2, 52    # save a13
    s32i a14, a2, 56    # save a14
    s32i a15, a2, 60    # save a15

    # Save trap reason
    
    l32i a3, a1, 0
    s32i a3, a2, 64

    # restart program

    j _init_start
.endif

.if math_support

    .align 4
    .section .text__float_support
    .global __fdiv32, __fsqrt32
    # f2 := f0 / f1
__fdiv32:
    div0.s    f3, f1
    nexp01.s  f4, f1
    const.s   f5, 1
    maddn.s   f5, f4, f3
    mov.s f6, f3
    mov.s f7, f1
    nexp01.s  f8, f0
    maddn.s   f6, f5, f3
    const.s   f5, 1
    const.s   f2, 0
    neg.s     f9, f8
    maddn.s   f5,f4,f6
    maddn.s   f2, f9, f3
    mkdadj.s  f7, f0
    maddn.s   f6,f5,f6
    maddn.s   f9,f4,f2
    const.s   f5, 1
    maddn.s   f5,f4,f6
    maddn.s   f2,f9,f6
    neg.s     f9, f8
    maddn.s   f6,f5,f6
    maddn.s   f9,f4,f2
    addexpm.s f2, f7
    addexp.s  f6, f7
    divn.s    f2, f9, f6
    ret

    .align 4
    # f1 := sqrt(f0)
__fsqrt32:
    sqrt0.s   f2, f0
    const.s   f5, 0
    maddn.s   f5, f2, f2
    nexp01.s  f3, f0
    const.s   f4, 3
    addexp.s  f3, f4
    maddn.s   f4, f5, f3
    nexp01.s  f5, f0
    neg.s     f6, f5
    maddn.s   f2, f4, f2
    const.s   f1, 0
    const.s   f4, 0
    const.s   f7, 0
    maddn.s   f1, f6, f2
    maddn.s   f4, f2, f3
    const.s   f6, 3
    maddn.s   f7, f6, f2
    maddn.s   f5, f1, f1
    maddn.s   f6, f4, f2
    neg.s     f3, f7
    maddn.s   f1, f5, f3
    maddn.s   f7, f6, f7
    mksadj.s  f2, f0
    nexp01.s  f5, f0
    maddn.s   f5, f1, f1
    neg.s     f3, f7
    addexpm.s f1, f2
    addexp.s  f3, f2
    divn.s    f1, f5, f3
    ret
.endif

    .align 4
    .section .stack
    .space 16384
