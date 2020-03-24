    .title "Module In, Key 1F5D98E4"
    .sbttl "Oberon ESP32 Compiler Version 0.1.0"

    .align 4
    .section .bss_In_1F5D98E4
    .global _In_1F5D98E4_s_bss
_In_1F5D98E4_s_bss:
_In_s_bss:
    .space 8


    .align 4
    .section .text_In_1F5D98E4
    .global _In_1F5D98E4_s_text
_In_1F5D98E4_s_text:

    .global _In_1F5D98E4_p_SetBaudRate
    .type _In_1F5D98E4_p_SetBaudRate, @function
_In_1F5D98E4_p_SetBaudRate:
    .type _SetBaudRate, @function
_SetBaudRate:
    entry a1, 32
    s32i a2, a1, 0
    movi a2, _In_s_bss
    l32i a6, a1, 0
    call4 _Out_70D42FFB_p_SetBaudRate
    retw
    .size _SetBaudRate, .-_SetBaudRate

    .align 4
    .global _In_1F5D98E4_p_SetTimeout
    .type _In_1F5D98E4_p_SetTimeout, @function
_In_1F5D98E4_p_SetTimeout:
    .type _SetTimeout, @function
_SetTimeout:
    entry a1, 32
    s32i a2, a1, 0
    movi a2, _In_s_bss
    l32i a3, a1, 0
    movi a4, 1000000
    mull a3, a3, a4
    s32i a3, a2, 0
    retw
    .size _SetTimeout, .-_SetTimeout

    .align 4
    .global _In_1F5D98E4_p_SetEcho
    .type _In_1F5D98E4_p_SetEcho, @function
_In_1F5D98E4_p_SetEcho:
    .type _SetEcho, @function
_SetEcho:
    entry a1, 32
    s32i a2, a1, 0
    movi a2, _In_s_bss
    l8ui a3, a1, 0
    s8i a3, a2, 6
    retw
    .size _SetEcho, .-_SetEcho

    .align 4
    .global _In_1F5D98E4_p_Open
    .type _In_1F5D98E4_p_Open, @function
_In_1F5D98E4_p_Open:
    .type _Open, @function
_Open:
    entry a1, 16
    movi a2, _In_s_bss
    l8ui a3, a2, 5
    bnez a3, L1
    movi a6, 694
    call4 _Out_70D42FFB_p_SetBaudRate
    movi a6, 30
    call4 _SetTimeout
    movi a3, 1
    s8i a3, a2, 6
    movi a3, 1
    s8i a3, a2, 5
L1:
    retw
    .size _Open, .-_Open

    .align 4
    .type _FifoCount, @function
_FifoCount:
    entry a1, 32
    movi a2, _In_s_bss
    movi a3, 1072955420
    l32i a3, a3, 0
    s32i a3, a1, 4
    movi a3, 1072955492
    l32i a3, a3, 0
    s32i a3, a1, 8
    l32i a3, a1, 4
    movi a4, 255
    and a3, a3, a4
    l32i a4, a1, 8
    movi a5, 7
    and a4, a4, a5
    slli a4, a4, 8
    add a3, a3, a4
    s32i a3, a1, 0
    l32i a3, a1, 0
    retw
    .size _FifoCount, .-_FifoCount

    .align 4
    .global _In_1F5D98E4_p_Flush
    .type _In_1F5D98E4_p_Flush, @function
_In_1F5D98E4_p_Flush:
    .type _Flush, @function
_Flush:
    entry a1, 32
    movi a2, _In_s_bss
L2:
    call4 _FifoCount
    mov a3, a7
    movi a4, 0
    bge a4, a3, L3
    movi a3, 1072955392
    l8ui a3, a3, 0
    s8i a3, a1, 0
    j L2
L3:
    retw
    .size _Flush, .-_Flush

    .align 4
    .global _In_1F5D98E4_p_Char
    .type _In_1F5D98E4_p_Char, @function
_In_1F5D98E4_p_Char:
    .type _Char, @function
_Char:
    entry a1, 32
    s32i a2, a1, 0
    movi a2, _In_s_bss
    movi a3, 0
    s8i a3, a2, 4
    addi a6, a1, 4
    movi a7, _Kernel_551E92D7_s_data_types
    addi a7, a7, 1
    call4 _Kernel_551E92D7_p_GetTime
L4:
    call4 _FifoCount
    mov a3, a7
    s32i a3, a1, 12
    l32i a3, a1, 12
    movi a4, 0
    blt a4, a3, L5
    addi a6, a1, 4
    movi a7, _Kernel_551E92D7_s_data_types
    addi a7, a7, 1
    call4 _Kernel_551E92D7_p_GetElapseTime
    mov a3, a7
    l32i a4, a2, 0
    bge a4, a3, L4
L5:
    l32i a3, a1, 12
    movi a4, 0
    bge a4, a3, L7
    movi a3, 1
    s8i a3, a2, 4
    movi a3, 1072955392
    l8ui a3, a3, 0
    l32i a4, a1, 0
    s8i a3, a4, 0
L7:
    retw
    .size _Char, .-_Char

    .align 4
    .global _In_1F5D98E4_p_String
    .type _In_1F5D98E4_p_String, @function
_In_1F5D98E4_p_String:
    .type _String, @function
_String:
    entry a1, 32
    s32i a2, a1, 0
    s32i a3, a1, 4
    movi a2, _In_s_bss
    addi a6, a1, 12
    call4 _Char
L8:
    l8ui a3, a2, 4
    beqz a3, L9
    l8ui a3, a1, 12
    movi a4, 13
    beq a3, a4, L9
    l8ui a3, a1, 12
    movi a4, 34
    beq a3, a4, L9
L10:
    l8ui a3, a1, 12
    movi a4, 8
    bne a3, a4, L11
    l8ui a3, a2, 6
    beqz a3, L12
    movi a6, 8
    call4 _Out_70D42FFB_p_Char
    movi a6, 32
    call4 _Out_70D42FFB_p_Char
    movi a6, 8
    call4 _Out_70D42FFB_p_Char
L12:
    j L13
L11:
    l8ui a3, a2, 6
    beqz a3, L14
    l8ui a3, a1, 12
    movi a4, 32
    blt a3, a4, L14
L15:
    l8ui a6, a1, 12
    call4 _Out_70D42FFB_p_Char
L14:
L13:
    addi a6, a1, 12
    call4 _Char
    j L8
L9:
    l8ui a3, a1, 12
    movi a4, 34
    bne a3, a4, L16
    movi a3, 0
    s32i a3, a1, 8
    addi a6, a1, 12
    call4 _Char
L17:
    l8ui a3, a2, 4
    beqz a3, L18
    l8ui a3, a1, 12
    movi a4, 13
    beq a3, a4, L18
    l8ui a3, a1, 12
    movi a4, 34
    beq a3, a4, L18
    l32i a3, a1, 4
    l32i a4, a1, 8
    bge a4, a3, L18
L19:
    l8ui a3, a1, 12
    movi a4, 8
    bne a3, a4, L20
    l32i a3, a1, 8
    movi a4, 0
    bge a4, a3, L20
L21:
    l8ui a3, a2, 6
    beqz a3, L22
    movi a6, 8
    call4 _Out_70D42FFB_p_Char
    movi a6, 32
    call4 _Out_70D42FFB_p_Char
    movi a6, 8
    call4 _Out_70D42FFB_p_Char
L22:
    l32i a3, a1, 8
    addi a3, a3, -1
    s32i a3, a1, 8
    j L23
L20:
    l8ui a3, a1, 12
    movi a4, 32
    blt a3, a4, L24
    l8ui a3, a2, 6
    beqz a3, L25
    l8ui a6, a1, 12
    call4 _Out_70D42FFB_p_Char
L25:
    l32i a3, a1, 8
    l32i a4, a1, 0
    add a3, a4, a3
    l8ui a4, a1, 12
    s8i a4, a3, 0
    l32i a3, a1, 8
    addi a3, a3, 1
    s32i a3, a1, 8
L24:
L23:
    addi a6, a1, 12
    call4 _Char
    j L17
L18:
L16:
    l8ui a3, a2, 4
    beqz a3, L26
    l8ui a3, a2, 6
    beqz a3, L26
L27:
    l8ui a6, a1, 12
    call4 _Out_70D42FFB_p_Char
    l8ui a3, a1, 12
    movi a4, 13
    bne a3, a4, L28
    movi a6, 10
    call4 _Out_70D42FFB_p_Char
L28:
L26:
    l32i a3, a1, 4
    l32i a4, a1, 8
    bge a4, a3, L29
    l32i a3, a1, 8
    l32i a4, a1, 0
    add a3, a4, a3
    movi a4, 0
    s8i a4, a3, 0
L29:
    retw
    .size _String, .-_String

    .align 4
    .global _In_1F5D98E4_p_Int
    .type _In_1F5D98E4_p_Int, @function
_In_1F5D98E4_p_Int:
    .type _Int, @function
_Int:
    entry a1, 48
    s32i a2, a1, 0
    movi a2, _In_s_bss
    addi a6, a1, 24
    call4 _Char
L30:
    l8ui a3, a2, 4
    beqz a3, L31
    l8ui a3, a1, 24
    movi a4, 13
    beq a3, a4, L31
    l8ui a3, a1, 24
    movi a4, 32
    bne a3, a4, L31
L32:
    l8ui a3, a1, 24
    movi a4, 8
    bne a3, a4, L33
    l8ui a3, a2, 6
    beqz a3, L34
    movi a6, 8
    call4 _Out_70D42FFB_p_Char
    movi a6, 32
    call4 _Out_70D42FFB_p_Char
    movi a6, 8
    call4 _Out_70D42FFB_p_Char
L34:
    j L35
L33:
    l8ui a3, a2, 6
    beqz a3, L36
    l8ui a3, a1, 24
    movi a4, 32
    blt a3, a4, L36
L37:
    l8ui a6, a1, 24
    call4 _Out_70D42FFB_p_Char
L36:
L35:
    addi a6, a1, 24
    call4 _Char
    j L30
L31:
    movi a3, 0
    l32i a4, a1, 0
    s32i a3, a4, 0
    movi a3, 0
    s32i a3, a1, 4
L38:
    l8ui a3, a2, 4
    beqz a3, L39
    l8ui a3, a1, 24
    movi a4, 8
    beq a3, a4, L40
    l8ui a3, a1, 24
    movi a4, 45
    beq a3, a4, L40
    l8ui a3, a1, 24
    movi a4, 48
    blt a3, a4, L41
    l8ui a3, a1, 24
    movi a4, 57
    blt a4, a3, L39
    l32i a3, a1, 4
    movi a4, 16
    bge a3, a4, L39
L40:
    l8ui a3, a1, 24
    movi a4, 8
    bne a3, a4, L43
    l32i a3, a1, 4
    movi a4, 0
    bge a4, a3, L43
L44:
    l8ui a3, a2, 6
    beqz a3, L45
    movi a6, 8
    call4 _Out_70D42FFB_p_Char
    movi a6, 32
    call4 _Out_70D42FFB_p_Char
    movi a6, 8
    call4 _Out_70D42FFB_p_Char
L45:
    l32i a3, a1, 4
    addi a3, a3, -1
    s32i a3, a1, 4
    j L46
L43:
    l8ui a3, a1, 24
    movi a4, 32
    bge a4, a3, L47
    l8ui a3, a2, 6
    beqz a3, L48
    l8ui a6, a1, 24
    call4 _Out_70D42FFB_p_Char
L48:
    l32i a3, a1, 4
    add a3, a1, a3
    l8ui a4, a1, 24
    s8i a4, a3, 8
    l32i a3, a1, 4
    addi a3, a3, 1
    s32i a3, a1, 4
L47:
L46:
    addi a6, a1, 24
    call4 _Char
    j L38
L39:
    l8ui a3, a2, 4
    beqz a3, L49
    l8ui a3, a2, 6
    beqz a3, L49
L50:
    l8ui a6, a1, 24
    call4 _Out_70D42FFB_p_Char
    l8ui a3, a1, 24
    movi a4, 13
    bne a3, a4, L51
    movi a6, 10
    call4 _Out_70D42FFB_p_Char
L51:
L49:
    l32i a3, a1, 4
    movi a4, 16
    bge a3, a4, L52
    l32i a3, a1, 4
    add a3, a1, a3
    movi a4, 0
    s8i a4, a3, 8
L52:
    movi a3, 0
    l32i a4, a1, 0
    s32i a3, a4, 0
    l8ui a3, a2, 4
    beqz a3, L53
    movi a3, 0
    s32i a3, a1, 4
    movi a3, 0
    s8i a3, a1, 25
L54:
    l32i a3, a1, 4
    movi a4, 16
    bge a3, a4, L55
    l32i a3, a1, 4
    add a3, a1, a3
    l8ui a3, a3, 8
    movi a4, 0
    beq a3, a4, L55
    l32i a3, a1, 4
    add a3, a1, a3
    l8ui a3, a3, 8
    movi a4, 45
    beq a3, a4, L55
    l32i a3, a1, 4
    add a3, a1, a3
    l8ui a3, a3, 8
    movi a4, 48
    blt a3, a4, L56
    l32i a3, a1, 4
    add a3, a1, a3
    l8ui a3, a3, 8
    movi a4, 57
    bge a4, a3, L55
L56:
    l32i a3, a1, 4
    addi a3, a3, 1
    s32i a3, a1, 4
    j L54
L55:
    l32i a3, a1, 4
    add a3, a1, a3
    l8ui a3, a3, 8
    movi a4, 45
    bne a3, a4, L58
    movi a3, 1
    s8i a3, a1, 25
    l32i a3, a1, 4
    addi a3, a3, 1
    s32i a3, a1, 4
L58:
L59:
    l32i a3, a1, 4
    movi a4, 16
    bge a3, a4, L60
    l32i a3, a1, 4
    add a3, a1, a3
    l8ui a3, a3, 8
    movi a4, 0
    beq a3, a4, L60
    l32i a3, a1, 4
    add a3, a1, a3
    l8ui a3, a3, 8
    movi a4, 48
    blt a3, a4, L60
    l32i a3, a1, 4
    add a3, a1, a3
    l8ui a3, a3, 8
    movi a4, 57
    blt a4, a3, L60
L61:
    l32i a3, a1, 0
    l32i a3, a3, 0
    movi a4, 10
    mull a3, a3, a4
    l32i a4, a1, 4
    add a4, a1, a4
    l8ui a4, a4, 8
    addi a4, a4, -48
    add a3, a3, a4
    l32i a4, a1, 0
    s32i a3, a4, 0
    l32i a3, a1, 4
    addi a3, a3, 1
    s32i a3, a1, 4
    j L59
L60:
    l8ui a3, a1, 25
    beqz a3, L62
    l32i a3, a1, 0
    l32i a3, a3, 0
    neg a3, a3
    l32i a4, a1, 0
    s32i a3, a4, 0
L62:
L53:
    retw
    .size _Int, .-_Int

    .align 4
    .global _In_1F5D98E4_p_Line
    .type _In_1F5D98E4_p_Line, @function
_In_1F5D98E4_p_Line:
    .type _Line, @function
_Line:
    entry a1, 32
    s32i a2, a1, 0
    s32i a3, a1, 4
    movi a2, _In_s_bss
    addi a6, a1, 12
    call4 _Char
    movi a3, 0
    s32i a3, a1, 8
L63:
    l8ui a3, a2, 4
    beqz a3, L64
    l8ui a3, a1, 12
    movi a4, 13
    beq a3, a4, L64
    l32i a3, a1, 4
    l32i a4, a1, 8
    bge a4, a3, L64
L65:
    l8ui a3, a1, 12
    movi a4, 8
    bne a3, a4, L66
    l32i a3, a1, 8
    movi a4, 0
    bge a4, a3, L66
L67:
    l8ui a3, a2, 6
    beqz a3, L68
    movi a6, 8
    call4 _Out_70D42FFB_p_Char
    movi a6, 32
    call4 _Out_70D42FFB_p_Char
    movi a6, 8
    call4 _Out_70D42FFB_p_Char
L68:
    l32i a3, a1, 8
    addi a3, a3, -1
    s32i a3, a1, 8
    j L69
L66:
    l8ui a3, a1, 12
    movi a4, 32
    blt a3, a4, L70
    l8ui a3, a2, 6
    beqz a3, L71
    l8ui a6, a1, 12
    call4 _Out_70D42FFB_p_Char
L71:
    l32i a3, a1, 8
    l32i a4, a1, 0
    add a3, a4, a3
    l8ui a4, a1, 12
    s8i a4, a3, 0
    l32i a3, a1, 8
    addi a3, a3, 1
    s32i a3, a1, 8
L70:
L69:
    addi a6, a1, 12
    call4 _Char
    j L63
L64:
    l8ui a3, a2, 4
    beqz a3, L72
    l8ui a3, a2, 6
    beqz a3, L72
    l8ui a3, a1, 12
    movi a4, 13
    bne a3, a4, L72
L73:
    movi a6, 13
    call4 _Out_70D42FFB_p_Char
    movi a6, 10
    call4 _Out_70D42FFB_p_Char
L72:
    l32i a3, a1, 4
    l32i a4, a1, 8
    bge a4, a3, L74
    l32i a3, a1, 8
    l32i a4, a1, 0
    add a3, a4, a3
    movi a4, 0
    s8i a4, a3, 0
L74:
    retw
    .size _Line, .-_Line


    .align 4
    .section .init_In_1F5D98E4

_In_init:
    entry a1, 16
    movi a2, _In_s_bss
    call4 _Open
    retw
    .size _In_init, .-_In_init


    .align 4
    .section .init_table_In_1F5D98E4
    .int _In_init

