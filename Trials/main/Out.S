
    .title "Module Out, Key B72BE1A0"
    .sbttl "Oberon ESP32 Compiler Version 0.2.0"

    .align 4
    .section .rodata_strs_Out_B72BE1A0
_Out_data_strs:
    .byte 32,32,48,32,0,0,0,0,32,78,97,78,32,0,0,0
    .byte 32,32,48,0

    .align 4
    .section .bss_Out_B72BE1A0
    .global _Out_B72BE1A0_s_bss
_Out_B72BE1A0_s_bss:
_Out_s_bss:
    .space 4



    .align 4
    .section .text_Out_B72BE1A0
    .global _Out_B72BE1A0_s_text
_Out_B72BE1A0_s_text:
    .type _FifoCount, @function
_FifoCount:
    entry a1, 32
    movi a2, _Out_s_bss
    movi a3, 1072955420
    l32i a3, a3, 0
    s32i a3, a1, 4
    movi a3, 1072955492
    l32i a3, a3, 0
    s32i a3, a1, 8
    l32i a3, a1, 4
    srai a3, a3, 16
    movi a4, 255
    and a3, a3, a4
    l32i a4, a1, 8
    srai a4, a4, 3
    movi a5, 7
    and a4, a4, a5
    slli a4, a4, 8
    add a3, a3, a4
    s32i a3, a1, 0
    l32i a3, a1, 0
    retw
    .size _FifoCount, .-_FifoCount

    .align 4

    .global _Out_B72BE1A0_p_Flush
_Out_B72BE1A0_p_Flush:
    .type _Flush, @function
_Flush:
    entry a1, 16
    movi a2, _Out_s_bss
1$:
    call4 _FifoCount
    mov a3, a7
    movi a4, 0
    bge a4, a3, 2$
    j 1$
2$:
    retw
    .size _Flush, .-_Flush

    .align 4

    .global _Out_B72BE1A0_p_Char
_Out_B72BE1A0_p_Char:
    .type _Char, @function
_Char:
    entry a1, 32
    s32i a2, a1, 0
    movi a2, _Out_s_bss
1$:
    call4 _FifoCount
    mov a3, a7
    movi a4, 120
    bge a4, a3, 2$
    j 1$
2$:
    l8ui a3, a1, 0
    movi a4, 1072955392
    s32i a3, a4, 0
    retw
    .size _Char, .-_Char

    .align 4

    .global _Out_B72BE1A0_p_String
_Out_B72BE1A0_p_String:
    .type _String, @function
_String:
    entry a1, 32
    s32i a2, a1, 0
    s32i a3, a1, 4
    movi a2, _Out_s_bss
    movi a3, 0
    s32i a3, a1, 8
1$:
    l32i a3, a1, 4
    l32i a4, a1, 8
    bge a4, a3, 2$
    l32i a3, a1, 8
    l32i a4, a1, 0
    add a3, a4, a3
    l8ui a3, a3, 0
    movi a4, 0
    beq a3, a4, 2$
    l32i a6, a1, 8
    l32i a7, a1, 0
    add a6, a7, a6
    l8ui a6, a6, 0
    call4 _Char
    l32i a3, a1, 8
    addi a3, a3, 1
    s32i a3, a1, 8
    j 1$
2$:
    retw
    .size _String, .-_String

    .align 4

    .global _Out_B72BE1A0_p_Int
_Out_B72BE1A0_p_Int:
    .type _Int, @function
_Int:
    entry a1, 48
    s32i a2, a1, 0
    s32i a3, a1, 4
    movi a2, _Out_s_bss
    movi a3, 0
    s32i a3, a1, 8
    l32i a3, a1, 0
    movi a4, 0
    bge a3, a4, 1$
    l32i a3, a1, 0
    neg a3, a3
    s32i a3, a1, 12
    l32i a3, a1, 4
    addi a3, a3, -1
    s32i a3, a1, 4
    j 2$
1$:
    l32i a3, a1, 0
    s32i a3, a1, 12
2$:
3$:
    l32i a3, a1, 8
    add a3, a1, a3
    l32i a4, a1, 12
    movi a5, 10
    rems a4, a4, a5
    addi a4, a4, 48
    s8i a4, a3, 16
    l32i a3, a1, 12
    movi a4, 10
    quos a3, a3, a4
    s32i a3, a1, 12
    l32i a3, a1, 8
    addi a3, a3, 1
    s32i a3, a1, 8
    l32i a3, a1, 12
    movi a4, 0
    bne a3, a4, 3$
4$:
    l32i a3, a1, 4
    l32i a4, a1, 8
    bge a4, a3, 5$
    movi a6, 32
    call4 _Char
    l32i a3, a1, 4
    addi a3, a3, -1
    s32i a3, a1, 4
    j 4$
5$:
    l32i a3, a1, 0
    movi a4, 0
    bge a3, a4, 6$
    movi a6, 45
    call4 _Char
6$:
7$:
    l32i a3, a1, 8
    addi a3, a3, -1
    s32i a3, a1, 8
    l32i a6, a1, 8
    add a6, a1, a6
    l8ui a6, a6, 16
    call4 _Char
    l32i a3, a1, 8
    movi a4, 0
    bne a3, a4, 7$
    retw
    .size _Int, .-_Int

    .align 4

    .global _Out_B72BE1A0_p_Hex
_Out_B72BE1A0_p_Hex:
    .type _Hex, @function
_Hex:
    entry a1, 48
    s32i a2, a1, 0
    s32i a3, a1, 4
    movi a2, _Out_s_bss
    movi a3, 0
    s32i a3, a1, 8
1$:
    l32i a3, a1, 0
    movi a4, 15
    and a3, a3, a4
    s32i a3, a1, 12
    l32i a3, a1, 12
    movi a4, 10
    bge a3, a4, 2$
    l32i a3, a1, 8
    add a3, a1, a3
    l32i a4, a1, 12
    addi a4, a4, 48
    s8i a4, a3, 16
    j 3$
2$:
    l32i a3, a1, 8
    add a3, a1, a3
    l32i a4, a1, 12
    addi a4, a4, 55
    s8i a4, a3, 16
3$:
    l32i a3, a1, 0
    srai a3, a3, 4
    s32i a3, a1, 0
    l32i a3, a1, 8
    addi a3, a3, 1
    s32i a3, a1, 8
    l32i a3, a1, 8
    movi a4, 8
    bne a3, a4, 1$
4$:
    l32i a3, a1, 4
    movi a4, 8
    bge a4, a3, 5$
    movi a6, 32
    call4 _Char
    l32i a3, a1, 4
    addi a3, a3, -1
    s32i a3, a1, 4
    j 4$
5$:
6$:
    l32i a3, a1, 8
    addi a3, a3, -1
    s32i a3, a1, 8
    l32i a6, a1, 8
    add a6, a1, a6
    l8ui a6, a6, 16
    call4 _Char
    l32i a3, a1, 8
    movi a4, 0
    bne a3, a4, 6$
    retw
    .size _Hex, .-_Hex

    .align 4
    .type _Ten, @function
_Ten:
    entry a1, 32
    s32i a2, a1, 0
    movi a2, _Out_s_bss
    movi a3, 1065353216
    s32i a3, a1, 4
    movi a3, 1092616192
    s32i a3, a1, 8
1$:
    l32i a3, a1, 0
    movi a4, 0
    bge a4, a3, 2$
    l32i a3, a1, 0
    movi a4, 1
    and a3, a3, a4
    beqz a3, 3$
    l32i a3, a1, 8
    l32i a4, a1, 4
    wfr f0, a3
    wfr f1, a4
    mul.s f2, f0, f1
    rfr a3, f2
    s32i a3, a1, 4
3$:
    l32i a3, a1, 8
    l32i a4, a1, 8
    wfr f0, a3
    wfr f1, a4
    mul.s f2, f0, f1
    rfr a3, f2
    s32i a3, a1, 8
    l32i a3, a1, 0
    srai a3, a3, 1
    s32i a3, a1, 0
    j 1$
2$:
    l32i a3, a1, 4
    retw
    .size _Ten, .-_Ten

    .align 4

    .global _Out_B72BE1A0_p_Real
_Out_B72BE1A0_p_Real:
    .type _Real, @function
_Real:
    entry a1, 64
    s32i a2, a1, 0
    s32i a3, a1, 4
    movi a2, _Out_s_bss
    l32i a3, a1, 0
    srai a3, a3, 23
    movi a4, 255
    and a3, a3, a4
    s32i a3, a1, 8
    l32i a3, a1, 8
    movi a4, 0
    bne a3, a4, 1$
    movi a6, _Out_data_strs
    movi a7, 5
    call4 _String
2$:
    l32i a3, a1, 4
    movi a4, 3
    blt a3, a4, 3$
    movi a6, 32
    call4 _Char
    l32i a3, a1, 4
    addi a3, a3, -1
    s32i a3, a1, 4
    j 2$
3$:
    j 4$
1$:
    l32i a3, a1, 8
    movi a4, 255
    bne a3, a4, 5$
    movi a6, _Out_data_strs
    addi a6, a6, 8
    movi a7, 6
    call4 _String
    j 4$
5$:
    movi a6, 32
    call4 _Char
6$:
    l32i a3, a1, 4
    movi a4, 15
    blt a3, a4, 7$
    l32i a3, a1, 4
    addi a3, a3, -1
    s32i a3, a1, 4
    movi a6, 32
    call4 _Char
    j 6$
7$:
    l32i a3, a1, 0
    movi a4, 0
    bge a3, a4, 8$
    movi a6, 45
    call4 _Char
    l32i a3, a1, 0
    wfr f0, a3
    neg.s f0, f0
    rfr a3, f0
    s32i a3, a1, 0
    j 9$
8$:
    movi a6, 32
    call4 _Char
9$:
    l32i a3, a1, 8
    addi a3, a3, -127
    movi a4, 77
    mull a3, a3, a4
    srai a3, a3, 8
    addi a3, a3, -6
    s32i a3, a1, 8
    l32i a3, a1, 8
    movi a4, 0
    blt a3, a4, 10$
    l32i a6, a1, 8
    call4 _Ten
    mov a3, a7
    l32i a4, a1, 0
    wfr f0, a4
    wfr f1, a3
    mov a5, a0
    call0 __fdiv32
    mov a0, a5
    rfr a3, f2
    s32i a3, a1, 0
    j 11$
10$:
    l32i a6, a1, 8
    neg a6, a6
    call4 _Ten
    mov a3, a7
    l32i a4, a1, 0
    wfr f0, a3
    wfr f1, a4
    mul.s f2, f0, f1
    rfr a3, f2
    s32i a3, a1, 0
11$:
    l32i a3, a1, 0
    movi a4, 1056964608
    wfr f0, a3
    wfr f1, a4
    add.s f2, f0, f1
    rfr a3, f2
    wfr f0, a3
    floor.s a3, f0, 0
    s32i a3, a1, 20
    l32i a3, a1, 20
    movi a4, 10000000
    blt a3, a4, 12$
    l32i a3, a1, 8
    addi a3, a3, 1
    s32i a3, a1, 8
    l32i a3, a1, 20
    movi a4, 10
    quos a3, a3, a4
    s32i a3, a1, 20
12$:
    movi a3, 0
    s32i a3, a1, 12
    movi a3, 13
    l32i a4, a1, 4
    sub a3, a3, a4
    s32i a3, a1, 16
13$:
    l32i a3, a1, 12
    l32i a4, a1, 16
    bne a3, a4, 14$
    l32i a3, a1, 20
    addi a3, a3, 5
    s32i a3, a1, 20
14$:
    l32i a3, a1, 12
    add a3, a1, a3
    l32i a4, a1, 20
    movi a5, 10
    rems a4, a4, a5
    addi a4, a4, 48
    s8i a4, a3, 24
    l32i a3, a1, 20
    movi a4, 10
    quos a3, a3, a4
    s32i a3, a1, 20
    l32i a3, a1, 12
    addi a3, a3, 1
    s32i a3, a1, 12
    l32i a3, a1, 20
    movi a4, 0
    bne a3, a4, 13$
    l32i a3, a1, 12
    addi a3, a3, -1
    s32i a3, a1, 12
    l32i a6, a1, 12
    add a6, a1, a6
    l8ui a6, a6, 24
    call4 _Char
    movi a6, 46
    call4 _Char
    l32i a3, a1, 4
    addi a3, a3, -7
    l32i a4, a1, 12
    bge a4, a3, 15$
    movi a3, 0
    s32i a3, a1, 4
    j 16$
15$:
    movi a3, 14
    l32i a4, a1, 4
    sub a3, a3, a4
    s32i a3, a1, 4
16$:
17$:
    l32i a3, a1, 12
    l32i a4, a1, 4
    bge a4, a3, 18$
    l32i a3, a1, 12
    addi a3, a3, -1
    s32i a3, a1, 12
    l32i a6, a1, 12
    add a6, a1, a6
    l8ui a6, a6, 24
    call4 _Char
    j 17$
18$:
    movi a6, 69
    call4 _Char
    l32i a3, a1, 8
    addi a3, a3, 6
    s32i a3, a1, 8
    l32i a3, a1, 8
    movi a4, 0
    bge a3, a4, 19$
    movi a6, 45
    call4 _Char
    l32i a3, a1, 8
    neg a3, a3
    s32i a3, a1, 8
    j 20$
19$:
    movi a6, 43
    call4 _Char
20$:
    l32i a6, a1, 8
    movi a7, 10
    quos a6, a6, a7
    addi a6, a6, 48
    call4 _Char
    l32i a6, a1, 8
    movi a7, 10
    rems a6, a6, a7
    addi a6, a6, 48
    call4 _Char
4$:
    retw
    .size _Real, .-_Real

    .align 4

    .global _Out_B72BE1A0_p_RealFix
_Out_B72BE1A0_p_RealFix:
    .type _RealFix, @function
_RealFix:
    entry a1, 64
    s32i a2, a1, 0
    s32i a3, a1, 4
    s32i a4, a1, 8
    movi a2, _Out_s_bss
    l32i a3, a1, 0
    movi a4, 0
    bne a3, a4, 1$
    movi a6, _Out_data_strs
    addi a6, a6, 16
    movi a7, 4
    call4 _String
    j 2$
1$:
    l32i a3, a1, 0
    movi a4, 0
    bge a3, a4, 3$
    l32i a3, a1, 0
    wfr f0, a3
    neg.s f0, f0
    rfr a3, f0
    s32i a3, a1, 0
    movi a3, 1
    s8i a3, a1, 20
    j 4$
3$:
    movi a3, 0
    s8i a3, a1, 20
4$:
    l32i a3, a1, 8
    movi a4, 7
    bge a4, a3, 5$
    movi a3, 7
    s32i a3, a1, 8
5$:
    l32i a6, a1, 8
    call4 _Ten
    mov a3, a7
    l32i a4, a1, 0
    wfr f0, a3
    wfr f1, a4
    mul.s f2, f0, f1
    rfr a3, f2
    s32i a3, a1, 0
    l32i a3, a1, 0
    movi a4, 1056964608
    wfr f0, a3
    wfr f1, a4
    add.s f2, f0, f1
    rfr a3, f2
    wfr f0, a3
    floor.s a3, f0, 0
    s32i a3, a1, 16
    movi a3, 0
    s32i a3, a1, 12
6$:
    l32i a3, a1, 12
    add a3, a1, a3
    l32i a4, a1, 16
    movi a5, 10
    rems a4, a4, a5
    addi a4, a4, 48
    s8i a4, a3, 24
    l32i a3, a1, 16
    movi a4, 10
    quos a3, a3, a4
    s32i a3, a1, 16
    l32i a3, a1, 12
    addi a3, a3, 1
    s32i a3, a1, 12
    l32i a3, a1, 16
    movi a4, 0
    bne a3, a4, 6$
    movi a6, 32
    call4 _Char
7$:
    l32i a3, a1, 12
    addi a3, a3, 3
    l32i a4, a1, 4
    bge a3, a4, 8$
    movi a6, 32
    call4 _Char
    l32i a3, a1, 4
    addi a3, a3, -1
    s32i a3, a1, 4
    j 7$
8$:
    l8ui a3, a1, 20
    beqz a3, 9$
    movi a6, 45
    call4 _Char
    l32i a3, a1, 4
    addi a3, a3, -1
    s32i a3, a1, 4
    j 10$
9$:
    movi a6, 32
    call4 _Char
10$:
11$:
    l32i a3, a1, 12
    l32i a4, a1, 8
    bge a4, a3, 12$
    l32i a3, a1, 12
    addi a3, a3, -1
    s32i a3, a1, 12
    l32i a6, a1, 12
    add a6, a1, a6
    l8ui a6, a6, 24
    call4 _Char
    j 11$
12$:
    movi a6, 46
    call4 _Char
13$:
    l32i a3, a1, 8
    l32i a4, a1, 12
    bge a4, a3, 14$
    l32i a3, a1, 8
    addi a3, a3, -1
    s32i a3, a1, 8
    movi a6, 48
    call4 _Char
    j 13$
14$:
15$:
    l32i a3, a1, 12
    movi a4, 0
    bge a4, a3, 16$
    l32i a3, a1, 12
    addi a3, a3, -1
    s32i a3, a1, 12
    l32i a6, a1, 12
    add a6, a1, a6
    l8ui a6, a6, 24
    call4 _Char
    j 15$
16$:
2$:
    retw
    .size _RealFix, .-_RealFix

    .align 4

    .global _Out_B72BE1A0_p_Ln
_Out_B72BE1A0_p_Ln:
    .type _Ln, @function
_Ln:
    entry a1, 16
    movi a2, _Out_s_bss
    movi a6, 13
    call4 _Char
    movi a6, 10
    call4 _Char
    retw
    .size _Ln, .-_Ln

    .align 4

    .global _Out_B72BE1A0_p_SetBaudRate
_Out_B72BE1A0_p_SetBaudRate:
    .type _SetBaudRate, @function
_SetBaudRate:
    entry a1, 32
    s32i a2, a1, 0
    movi a2, _Out_s_bss
    movi a3, 1072955412
    l32i a4, a1, 0
    s32i a4, a3, 0
    retw
    .size _SetBaudRate, .-_SetBaudRate

    .align 4

    .global _Out_B72BE1A0_p_Open
_Out_B72BE1A0_p_Open:
    .type _Open, @function
_Open:
    entry a1, 16
    movi a2, _Out_s_bss
    l8ui a3, a2, 0
    bnez a3, 1$
    movi a6, 694
    call4 _SetBaudRate
    movi a3, 1
    s8i a3, a2, 0
1$:
    retw
    .size _Open, .-_Open



    .align 4
    .section .text_init_Out_B72BE1A0

    .global _Out_B72BE1A0_p__init
_Out_B72BE1A0_p__init:
_Out_init:
    entry a1, 16
    movi a2, _Out_s_bss
    call4 _Open
    retw
    .size _Out_init, .-_Out_init
