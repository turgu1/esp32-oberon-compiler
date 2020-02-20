    .section .init._module_Test1

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
    j loop_1

    .align 4

TIMG0_T0CONFIG_REG:  .int 0x3FF5F000
TIMG0_T0LO_REG:      .int 0x3FF5F004
TIMG0_T0HI_REG:      .int 0x3FF5F008
TIMG0_T0UPDATE_REG:  .int 0x3FF5F00C
TIMG0_T0ALARMLO_REG: .int 0x3FF5F010
TIMG0_T0ALARMHI_REG: .int 0x3FF5F014
TIMG0_T0LOADLO_REG:  .int 0x3FF5F018
TIMG0_T0LOADHI_REG:  .int 0x3FF5F018
TIMG0_T0LOAD_REG:    .int 0x3FF5F020

# Bit 31: Enable counter        (1)
# Bit 30: incrementing counter  (1)
# Bits 28..13: Prescaler        (2)

TIMER_CONFIG:        .int 0xC0004000
 
_enable_timer:
    entry a1, 0
    l32r  a3, TIMG0_T0CONFIG_REG
    l32r  a4, TIMER_CONFIG
    s32i  a4, a3, 0
    movi  a4, 0
    s32i  a4, a3, 24
    s32i  a4, a3, 28
    s32i  a4, a3, 32
    retw


    .align 4

#wait_time: .int 0x989680  # 0.25 seconds tick count
wait_time: .int 0x2625A0  # 0.25 seconds tick count

_wait_a_quarter:
    entry a1, 0
    l32r  a3, TIMG0_T0CONFIG_REG
    l32r  a4, wait_time

    # Get current tick count

    movi  a5, 0
    s32i  a5, a3, 12       # [TIMG0_T0UPDATE_REG] := 0
    l32i  a5, a3, 4        # a5 := [TIMG0_T0LO_REG]
    l32i  a6, a3, 8        # a6 := [TIMG0_T0HI_REG]

    # Add wait time to tick count

    mov  a8, a6            # a8 = HI_REG
    add  a7, a4, a5        # a7 = LO_REG + wait_time
    bgeu a7, a5, conti_1
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

    .align 4

GPIO_ENABLE_W1TS: .int 0x3ff44024
GPIO_OUT_W1TS:    .int 0x3ff44008
GPIO_OUT_W1TC:    .int 0x3ff4400C

_setup_led:
    entry a1, 0
    l32r  a2, GPIO_ENABLE_W1TS
    movi  a3, 4   # LED 2
    s32i  a3, a2, 0
    retw

    .align 4
_led_on:
    entry a1, 0
    l32r  a2, GPIO_OUT_W1TS
    movi  a3, 4   # LED 2
    s32i  a3, a2, 0
    retw

    .align 4
_led_off:
    entry a1, 0
    l32r  a2, GPIO_OUT_W1TC
    movi  a3, 4   # LED 2
    s32i  a3, a2, 0
    retw

    .section .init_table._module_Test1
    .int _module_Test1_init 

