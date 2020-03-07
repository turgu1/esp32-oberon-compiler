    .title "Module Pattern17, Key A5E3D3EC"
    .sbttl "Oberon ESP32 Compiler Version 0.1.0"

    .align 4
    .section .bss_Pattern17_A5E3D3EC
    .global _Pattern17_A5E3D3EC_s_bss
_Pattern17_A5E3D3EC_s_bss:
_Pattern17_s_bss:
    .space 20



    .align 4
    .section .init_Pattern17_A5E3D3EC

_Pattern17_init:
    entry a1, 16
    movi a2, _Pattern17_s_bss
    l32i a3, a2, 0
    abs a3, a3
    s32i a3, a2, 4
    l32i a3, a2, 8
    slli a3, a3, 1
    srli a3, a3, 1
    s32i a3, a2, 12
    l32i a3, a2, 4
    movi a4, 1
    and a3, a3, a4
    s8i a3, a2, 16
    l8ui a3, a2, 17
    s32i a3, a2, 4
    l32i a3, a2, 8
    wfr f0, a3
    floor.s a3, f0, 0
    s32i a3, a2, 4
    l32i a3, a2, 0
    float.s f0, a3, 0
    rfr a3, f0
    s32i a3, a2, 12
    l32i a3, a2, 0
    slli a3, a3, 3
    s32i a3, a2, 4
    l32i a3, a2, 0
    srai a3, a3, 8
    s32i a3, a2, 4
    l32i a3, a2, 0
    l32i a4, a2, 4
    ssr a4
    mov a4, a3
    src a3, a3, a4
    s32i a3, a2, 0
    retw
    .size _Pattern17_init, .-_Pattern17_init


    .align 4
    .section .init_table_Pattern17_A5E3D3EC
    .int _Pattern17_init

