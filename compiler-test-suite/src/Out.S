    .title "Module Out, Key 70D42FFB"
    .sbttl "Oberon ESP32 Compiler Version 0.1.0"

    .align 4
    .section .data_strs_Out_70D42FFB
_Out_s_str:
    .byte 32,32,48,32,0,0,0,0,32,78,97,78,32,0,0,0
    .byte 32,32,48,0

    .align 4
    .section .bss_Out_70D42FFB
    .global _Out_70D42FFB_s_bss
_Out_70D42FFB_s_bss:
_Out_s_bss:
    .space 4


    .align 4
    .section .text_Out_70D42FFB
    .global _Out_70D42FFB_s_text
_Out_70D42FFB_s_text:

_FifoCount:
    entry a1, 32
    movi a2, _Out_s_bss
    movi a3, 1072955420
    l32i a3, a3, 0
    s32i a3, a1, 4
    l32i a3, a1, 4
    srai a3, a3, 16
    movi a4, 255
    and a3, a3, a4
    s32i a3, a1, 0
    l32i a3, a1, 0
    retw
    .size _FifoCount, .-_FifoCount

    .align 4
    .global _Out_70D42FFB_p_Flush
    .type _Out_70D42FFB_p_Flush, @function
_Out_70D42FFB_p_Flush:
_Flush:
    entry a1, 16
    movi a2, _Out_s_bss
L1:
    call4 _FifoCount
    mov a3, a7
    movi a4, 0
    bge a4, a3, L2
    j L1
L2:
    retw
    .size _Flush, .-_Flush

    .align 4
    .global _Out_70D42FFB_p_Char
    .type _Out_70D42FFB_p_Char, @function
_Out_70D42FFB_p_Char:
_Char:
    entry a1, 32
    s32i a2, a1, 0
    movi a2, _Out_s_bss
L3:
    call4 _FifoCount
    mov a3, a7
    movi a4, 120
    bge a4, a3, L4
    j L3
L4:
    l8ui a3, a1, 0
    movi a4, 1072955392
    s32i a3, a4, 0
    retw
    .size _Char, .-_Char

    .align 4
    .global _Out_70D42FFB_p_String
    .type _Out_70D42FFB_p_String, @function
_Out_70D42FFB_p_String:
_String:
    entry a1, 32
    s32i a2, a1, 0
    s32i a3, a1, 4
    movi a2, _Out_s_bss
    movi a3, 0
    s32i a3, a1, 8
L5:
    l32i a3, a1, 4
    l32i a4, a1, 8
    bge a4, a3, L6
    l32i a3, a1, 8
    l32i a4, a1, 0
    add a3, a4, a3
    l8ui a3, a3, 0
    movi a4, 0
    beq a3, a4, L6
L7:
    l32i a6, a1, 8
    l32i a7, a1, 0
    add a6, a7, a6
    l8ui a6, a6, 0
    call4 _Char
    l32i a3, a1, 8
    addi a3, a3, 1
    s32i a3, a1, 8
    j L5
L6:
    retw
    .size _String, .-_String

    .align 4
    .global _Out_70D42FFB_p_Int
    .type _Out_70D42FFB_p_Int, @function
_Out_70D42FFB_p_Int:
_Int:
    entry a1, 48
    s32i a2, a1, 0
    s32i a3, a1, 4
    movi a2, _Out_s_bss
    movi a3, 0
    s32i a3, a1, 8
    l32i a3, a1, 0
    movi a4, 0
    bge a3, a4, L8
    l32i a3, a1, 0
    neg a3, a3
    s32i a3, a1, 12
    l32i a3, a1, 4
    addi a3, a3, -1
    s32i a3, a1, 4
    j L9
L8:
    l32i a3, a1, 0
    s32i a3, a1, 12
L9:
L10:
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
    bne a3, a4, L10
L11:
    l32i a3, a1, 4
    l32i a4, a1, 8
    bge a4, a3, L12
    movi a6, 32
    call4 _Char
    l32i a3, a1, 4
    addi a3, a3, -1
    s32i a3, a1, 4
    j L11
L12:
    l32i a3, a1, 0
    movi a4, 0
    bge a3, a4, L13
    movi a6, 45
    call4 _Char
L13:
L14:
    l32i a3, a1, 8
    addi a3, a3, -1
    s32i a3, a1, 8
    l32i a6, a1, 8
    add a6, a1, a6
    l8ui a6, a6, 16
    call4 _Char
    l32i a3, a1, 8
    movi a4, 0
    bne a3, a4, L14
    retw
    .size _Int, .-_Int

    .align 4
    .global _Out_70D42FFB_p_Hex
    .type _Out_70D42FFB_p_Hex, @function
_Out_70D42FFB_p_Hex:
_Hex:
    entry a1, 48
    s32i a2, a1, 0
    s32i a3, a1, 4
    movi a2, _Out_s_bss
    movi a3, 0
    s32i a3, a1, 8
L15:
    l32i a3, a1, 0
    movi a4, 15
    and a3, a3, a4
    s32i a3, a1, 12
    l32i a3, a1, 12
    movi a4, 10
    bge a3, a4, L16
    l32i a3, a1, 8
    add a3, a1, a3
    l32i a4, a1, 12
    addi a4, a4, 48
    s8i a4, a3, 16
    j L17
L16:
    l32i a3, a1, 8
    add a3, a1, a3
    l32i a4, a1, 12
    addi a4, a4, 55
    s8i a4, a3, 16
L17:
    l32i a3, a1, 0
    srai a3, a3, 4
    s32i a3, a1, 0
    l32i a3, a1, 8
    addi a3, a3, 1
    s32i a3, a1, 8
    l32i a3, a1, 8
    movi a4, 8
    bne a3, a4, L15
L18:
    l32i a3, a1, 4
    movi a4, 8
    bge a4, a3, L19
    movi a6, 32
    call4 _Char
    l32i a3, a1, 4
    addi a3, a3, -1
    s32i a3, a1, 4
    j L18
L19:
L20:
    l32i a3, a1, 8
    addi a3, a3, -1
    s32i a3, a1, 8
    l32i a6, a1, 8
    add a6, a1, a6
    l8ui a6, a6, 16
    call4 _Char
    l32i a3, a1, 8
    movi a4, 0
    bne a3, a4, L20
    retw
    .size _Hex, .-_Hex

    .align 4
_Ten:
    entry a1, 32
    s32i a2, a1, 0
    movi a2, _Out_s_bss
    movi a3, 1065353216
    s32i a3, a1, 4
    movi a3, 1092616192
    s32i a3, a1, 8
L21:
    l32i a3, a1, 0
    movi a4, 0
    bge a4, a3, L22
    l32i a3, a1, 0
    movi a4, 1
    and a3, a3, a4
    beqz a3, L23
    l32i a3, a1, 8
    l32i a4, a1, 4
    wfr f0, a3
    wfr f1, a4
    mul.s f2, f0, f1
    rfr a3, f2
    s32i a3, a1, 4
L23:
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
    j L21
L22:
    l32i a3, a1, 4
    retw
    .size _Ten, .-_Ten

    .align 4
    .global _Out_70D42FFB_p_Real
    .type _Out_70D42FFB_p_Real, @function
_Out_70D42FFB_p_Real:
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
    bne a3, a4, L24
    movi a6, _Out_s_str
    movi a7, 5
    call4 _String
L25:
    l32i a3, a1, 4
    movi a4, 3
    blt a3, a4, L26
    movi a6, 32
    call4 _Char
    l32i a3, a1, 4
    addi a3, a3, -1
    s32i a3, a1, 4
    j L25
L26:
    j L27
L24:
    l32i a3, a1, 8
    movi a4, 255
    bne a3, a4, L28
    movi a6, _Out_s_str
    addi a6, a6, 8
    movi a7, 6
    call4 _String
    j L27
L28:
    movi a6, 32
    call4 _Char
L29:
    l32i a3, a1, 4
    movi a4, 15
    blt a3, a4, L30
    l32i a3, a1, 4
    addi a3, a3, -1
    s32i a3, a1, 4
    movi a6, 32
    call4 _Char
    j L29
L30:
    l32i a3, a1, 0
    movi a4, 0
    bge a3, a4, L31
    movi a6, 45
    call4 _Char
    l32i a3, a1, 0
    wfr f0, a3
    neg.s f0, f0
    rfr a3, f0
    s32i a3, a1, 0
    j L32
L31:
    movi a6, 32
    call4 _Char
L32:
    l32i a3, a1, 8
    addi a3, a3, -127
    movi a4, 77
    mull a3, a3, a4
    srai a3, a3, 8
    addi a3, a3, -6
    s32i a3, a1, 8
    l32i a3, a1, 8
    movi a4, 0
    blt a3, a4, L33
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
    j L34
L33:
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
L34:
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
    blt a3, a4, L35
    l32i a3, a1, 8
    addi a3, a3, 1
    s32i a3, a1, 8
    l32i a3, a1, 20
    movi a4, 10
    quos a3, a3, a4
    s32i a3, a1, 20
L35:
    movi a3, 0
    s32i a3, a1, 12
    movi a3, 13
    l32i a4, a1, 4
    sub a3, a3, a4
    s32i a3, a1, 16
L36:
    l32i a3, a1, 12
    l32i a4, a1, 16
    bne a3, a4, L37
    l32i a3, a1, 20
    addi a3, a3, 5
    s32i a3, a1, 20
L37:
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
    bne a3, a4, L36
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
    bge a4, a3, L38
    movi a3, 0
    s32i a3, a1, 4
    j L39
L38:
    movi a3, 14
    l32i a4, a1, 4
    sub a3, a3, a4
    s32i a3, a1, 4
L39:
L40:
    l32i a3, a1, 12
    l32i a4, a1, 4
    bge a4, a3, L41
    l32i a3, a1, 12
    addi a3, a3, -1
    s32i a3, a1, 12
    l32i a6, a1, 12
    add a6, a1, a6
    l8ui a6, a6, 24
    call4 _Char
    j L40
L41:
    movi a6, 69
    call4 _Char
    l32i a3, a1, 8
    addi a3, a3, 6
    s32i a3, a1, 8
    l32i a3, a1, 8
    movi a4, 0
    bge a3, a4, L42
    movi a6, 45
    call4 _Char
    l32i a3, a1, 8
    neg a3, a3
    s32i a3, a1, 8
    j L43
L42:
    movi a6, 43
    call4 _Char
L43:
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
L27:
    retw
    .size _Real, .-_Real

    .align 4
    .global _Out_70D42FFB_p_RealFix
    .type _Out_70D42FFB_p_RealFix, @function
_Out_70D42FFB_p_RealFix:
_RealFix:
    entry a1, 64
    s32i a2, a1, 0
    s32i a3, a1, 4
    s32i a4, a1, 8
    movi a2, _Out_s_bss
    l32i a3, a1, 0
    movi a4, 0
    bne a3, a4, L44
    movi a6, _Out_s_str
    addi a6, a6, 16
    movi a7, 4
    call4 _String
    j L45
L44:
    l32i a3, a1, 0
    movi a4, 0
    bge a3, a4, L46
    l32i a3, a1, 0
    wfr f0, a3
    neg.s f0, f0
    rfr a3, f0
    s32i a3, a1, 0
    movi a3, 1
    s8i a3, a1, 20
    j L47
L46:
    movi a3, 0
    s8i a3, a1, 20
L47:
    l32i a3, a1, 8
    movi a4, 7
    bge a4, a3, L48
    movi a3, 7
    s32i a3, a1, 8
L48:
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
L49:
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
    bne a3, a4, L49
    movi a6, 32
    call4 _Char
L50:
    l32i a3, a1, 12
    addi a3, a3, 3
    l32i a4, a1, 4
    bge a4, a3, L51
    movi a6, 32
    call4 _Char
    l32i a3, a1, 4
    addi a3, a3, -1
    s32i a3, a1, 4
    j L50
L51:
    l8ui a3, a1, 20
    beqz a3, L52
    movi a6, 45
    call4 _Char
    l32i a3, a1, 4
    addi a3, a3, -1
    s32i a3, a1, 4
    j L53
L52:
    movi a6, 32
    call4 _Char
L53:
L54:
    l32i a3, a1, 12
    l32i a4, a1, 8
    bge a4, a3, L55
    l32i a3, a1, 12
    addi a3, a3, -1
    s32i a3, a1, 12
    l32i a6, a1, 12
    add a6, a1, a6
    l8ui a6, a6, 24
    call4 _Char
    j L54
L55:
    movi a6, 46
    call4 _Char
L56:
    l32i a3, a1, 8
    l32i a4, a1, 12
    bge a4, a3, L57
    l32i a3, a1, 8
    addi a3, a3, -1
    s32i a3, a1, 8
    movi a6, 48
    call4 _Char
    j L56
L57:
L58:
    l32i a3, a1, 12
    movi a4, 0
    bge a4, a3, L59
    l32i a3, a1, 12
    addi a3, a3, -1
    s32i a3, a1, 12
    l32i a6, a1, 12
    add a6, a1, a6
    l8ui a6, a6, 24
    call4 _Char
    j L58
L59:
L45:
    retw
    .size _RealFix, .-_RealFix

    .align 4
    .global _Out_70D42FFB_p_Ln
    .type _Out_70D42FFB_p_Ln, @function
_Out_70D42FFB_p_Ln:
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
    .global _Out_70D42FFB_p_SetBaudRate
    .type _Out_70D42FFB_p_SetBaudRate, @function
_Out_70D42FFB_p_SetBaudRate:
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
    .global _Out_70D42FFB_p_Open
    .type _Out_70D42FFB_p_Open, @function
_Out_70D42FFB_p_Open:
_Open:
    entry a1, 16
    movi a2, _Out_s_bss
    movi a6, 694
    call4 _SetBaudRate
    retw
    .size _Open, .-_Open


    .align 4
    .section .init_Out_70D42FFB

_Out_init:
    entry a1, 16
    movi a2, _Out_s_bss
    call4 _Open
    retw
    .size _Out_init, .-_Out_init


    .align 4
    .section .init_table_Out_70D42FFB
    .int _Out_init

