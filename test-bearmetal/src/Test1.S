    .section .init_module_Test1

    .align 4

_module_Test1_init:
    entry a1, 0
    call4 _enable_timer
    call4 _setup_led

loop_1:
    call4 _led_on
    call4 _wait_a_quarter
    call4 _led_off
    call4 _wait_a_quarter
    movi  a6, msg
    call4 _put_string
    j loop_1

    .section .data
    .align 4
msg: .asciz "Hello!!\r\n"

    .section .text_module_Test1

    .align 4

    .equ TIMG0_T0CONFIG_REG,  0x3FF5F000
    .equ TIMG0_T0LO_REG,      0x3FF5F004
    .equ TIMG0_T0HI_REG,      0x3FF5F008
    .equ TIMG0_T0UPDATE_REG,  0x3FF5F00C
    .equ TIMG0_T0ALARMLO_REG, 0x3FF5F010
    .equ TIMG0_T0ALARMHI_REG, 0x3FF5F014
    .equ TIMG0_T0LOADLO_REG,  0x3FF5F018
    .equ TIMG0_T0LOADHI_REG,  0x3FF5F018
    .equ TIMG0_T0LOAD_REG,    0x3FF5F020

# Bit 31: Enable counter        (1)
# Bit 30: incrementing counter  (1)
# Bits 28..13: Prescaler        (2)

    .equ TIMER_CONFIG, 0xC0004000

_enable_timer:
    entry a1, 0
    movi  a3, TIMG0_T0CONFIG_REG
    movi  a4, TIMER_CONFIG
    s32i  a4, a3, 0
    movi  a4, 0
    s32i  a4, a3, 24
    s32i  a4, a3, 28
    s32i  a4, a3, 32
    retw

    .equ wait_time, 0x989680  # 0.25 second tick count
#   .equ wait_time, 0x2625A0  # 0.0625 second tick count

    .align 4

_wait_a_quarter:
    entry a1, 0
    movi  a3, TIMG0_T0CONFIG_REG
    movi  a4, wait_time

    # Get current tick count

    movi  a5, 0
    s32i  a5, a3, 12       # [TIMG0_T0UPDATE_REG] := 0
    l32i  a5, a3, 4        # a5 := [TIMG0_T0LO_REG]
    l32i  a6, a3, 8        # a6 := [TIMG0_T0HI_REG]

    # Add wait time to tick count

    mov  a8, a6            # a8 = HI_REG
    add  a7, a4, a5        # a7 = LO_REG + wait_time
    bgeu a7, a5, conti_1   # branch if no overflow on high part
    addi a8, a8, 1

    # wait until time a8:a7 reached

conti_1:
    movi  a5, 0
    s32i  a5, a3, 12       # [TIMG0_T0UPDATE_REG] := 0
    l32i  a5, a3, 4        # a5 := [TIMG0_T0LO_REG]
    l32i  a6, a3, 8        # a6 := [TIMG0_T0HI_REG]
    bltu  a6, a8, conti_1  # Branch if High portion of the timer is still too small
    bltu  a5, a7, conti_1  # Branch if Low portion of the timer is still too small
    retw

    .equ GPIO_ENABLE_W1TS, 0x3ff44024
    .equ GPIO_OUT_W1TS,    0x3ff44008
    .equ GPIO_OUT_W1TC,    0x3ff4400C
    .equ LED_2, 4

    .align 4

_setup_led:
    entry a1, 0
    movi  a2, GPIO_ENABLE_W1TS
    movi  a3, LED_2
    s32i  a3, a2, 0
    retw

    .align 4
_led_on:
    entry a1, 0
    movi  a2, GPIO_OUT_W1TS
    movi  a3, LED_2
    s32i  a3, a2, 0
    retw

    .align 4
_led_off:
    entry a1, 0
    movi  a2, GPIO_OUT_W1TC
    movi  a3, LED_2
    s32i  a3, a2, 0
    retw

    .section .init_table_module_Test1
    .int _module_Test1_init 

