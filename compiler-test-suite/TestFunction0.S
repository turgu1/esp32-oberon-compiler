    .title "Module TestFunction0, Key 4652443E"
    .sbttl "Oberon ESP32 Compiler Version 0.1.0"

    .align 4
    .section .bss_TestFunction0_4652443E
    .global _TestFunction0_4652443E_s_bss
_TestFunction0_4652443E_s_bss:
_TestFunction0_s_bss:
    .space 4


    .align 4
    .section .text_TestFunction0_4652443E
    .global _TestFunction0_4652443E_s_text
_TestFunction0_4652443E_s_text:

_P2:
    entry a1, 32
    s32i a2, a1, 0
    s32i a3, a1, 4
    movi a2, _TestFunction0_s_bss
    l32i a3, a1, 4
    s32i a3, a1, 8
    l32i a3, a1, 8
    l32i a4, a1, 0
    add a3, a3, a4
    retw
    .size _P2, .-_P2

    .align 4
_P1:
    entry a1, 32
    s32i a2, a1, 0
    movi a2, _TestFunction0_s_bss
    l32i a6, a1, 0
    movi a7, 2
    call4 _P2
    mov a3, a7
    l32i a4, a1, 0
    add a3, a4, a3
    retw
    .size _P1, .-_P1


    .align 4
    .section .init_TestFunction0_4652443E

_TestFunction0_init:
    entry a1, 16
    movi a2, _TestFunction0_s_bss
    movi a6, 1
    call4 _P1
    mov a3, a7
    s32i a3, a2, 0
    l32i a6, a2, 0
    movi a7, 0
    call4 _Out_23908F94_p_Int
    retw
    .size _TestFunction0_init, .-_TestFunction0_init


    .align 4
    .section .init_table_TestFunction0_4652443E
    .int _TestFunction0_init

