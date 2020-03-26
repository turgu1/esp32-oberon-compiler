    .title "Module Pattern2b, Key A6E3D417"
    .sbttl "Oberon ESP32 Compiler Version 0.1.0"

    .align 4
    .section .bss_Pattern2b_A6E3D417
    .global _Pattern2b_A6E3D417_s_bss
_Pattern2b_A6E3D417_s_bss:
_Pattern2b_s_bss:
    .space 24



    .align 4
    .section .init_Pattern2b_A6E3D417

_Pattern2b_init:
    entry a1, 16
    movi a2, _Pattern2b_s_bss
    movi a3, 1090519040
    s32i a3, a2, 8
    l32i a6, a2, 8
    movi a7, 10
    call4 _Out_70D42FFB_p_Real
    movi a3, 1088421888
    s32i a3, a2, 12
    movi a3, 1065353216
    l32i a4, a2, 12
    wfr f0, a3
    wfr f1, a4
    add.s f2, f0, f1
    rfr a3, f2
    s32i a3, a2, 8
    l32i a6, a2, 8
    movi a7, 10
    call4 _Out_70D42FFB_p_Real
    movi a3, 1091567616
    s32i a3, a2, 12
    l32i a3, a2, 12
    movi a4, 1065353216
    wfr f0, a3
    wfr f1, a4
    sub.s f2, f0, f1
    rfr a3, f2
    s32i a3, a2, 8
    l32i a6, a2, 8
    movi a7, 10
    call4 _Out_70D42FFB_p_Real
    movi a3, 1082130432
    s32i a3, a2, 12
    l32i a3, a2, 12
    movi a4, 1073741824
    wfr f0, a3
    wfr f1, a4
    mul.s f2, f0, f1
    rfr a3, f2
    s32i a3, a2, 8
    l32i a6, a2, 8
    movi a7, 10
    call4 _Out_70D42FFB_p_Real
    movi a3, 1098907648
    s32i a3, a2, 12
    l32i a3, a2, 12
    movi a4, 1073741824
    wfr f0, a3
    wfr f1, a4
    mov a5, a0
    call0 __fdiv32
    mov a0, a5
    rfr a3, f2
    s32i a3, a2, 8
    l32i a6, a2, 8
    movi a7, 10
    call4 _Out_70D42FFB_p_Real
    movi a3, -8
    s32i a3, a2, 0
    l32i a6, a2, 0
    movi a7, 10
    call4 _Out_70D42FFB_p_Int
    movi a3, 8
    s32i a3, a2, 4
    l32i a3, a2, 4
    neg a3, a3
    s32i a3, a2, 0
    l32i a6, a2, 0
    movi a7, 10
    call4 _Out_70D42FFB_p_Int
    movi a3, -1056964608
    s32i a3, a2, 8
    l32i a6, a2, 8
    movi a7, 10
    call4 _Out_70D42FFB_p_Real
    movi a3, 1090519040
    s32i a3, a2, 12
    l32i a3, a2, 12
    wfr f0, a3
    neg.s f0, f0
    rfr a3, f0
    s32i a3, a2, 8
    l32i a6, a2, 8
    movi a7, 10
    call4 _Out_70D42FFB_p_Real
    movi a3, 5
    s32i a3, a2, 16
    l32i a6, a2, 16
    movi a7, 10
    call4 _Out_70D42FFB_p_Int
    movi a3, -6
    s32i a3, a2, 20
    l32i a3, a2, 20
    mov a4, -1
    xor a3, a3, a4
    s32i a3, a2, 16
    l32i a6, a2, 16
    movi a7, 10
    call4 _Out_70D42FFB_p_Int
    retw
    .size _Pattern2b_init, .-_Pattern2b_init


    .align 4
    .section .init_table_Pattern2b_A6E3D417
    .int _Pattern2b_init

