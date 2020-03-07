    .title "Module Pattern9, Key ADE2D4B5"
    .sbttl "Oberon ESP32 Compiler Version 0.1.0"

    .align 4
    .section .bss_Pattern9_ADE2D4B5
    .global _Pattern9_ADE2D4B5_s_bss
_Pattern9_ADE2D4B5_s_bss:
_Pattern9_s_bss:
    .space 4


    .align 4
    .section .text_Pattern9_ADE2D4B5
    .global _Pattern9_ADE2D4B5_s_text
_Pattern9_ADE2D4B5_s_text:

_F:
    entry a1, 32
    s32i a2, a1, 0
    movi a2, _Pattern9_s_bss
    l32i a3, a1, 0
    movi a4, 1065353216
    blt a3, a4, 1f
    l32i a10, a1, 0
    call8 _F
    mov a6, a10
    call4 _F
    mov a3, a6
    s32i a3, a1, 0
1:
    l32i a3, a1, 0
    retw
    .size _F, .-_F


    .align 4
    .section .init_Pattern9_ADE2D4B5

_Pattern9_init:
    entry a1, 16
    movi a2, _Pattern9_s_bss
    retw
    .size _Pattern9_init, .-_Pattern9_init


    .align 4
    .section .init_table_Pattern9_ADE2D4B5
    .int _Pattern9_init

