    .title "Module Pattern16, Key A5E3D3EB"
    .sbttl "Oberon ESP32 Compiler Version 0.1.0"

    .align 4
    .section .data_strs_Pattern16_A5E3D3EB
_Pattern16_data_strs:
    .byte 48,49,50,51,52,53,54,55,56,57,0,0

    .align 4
    .section .bss_Pattern16_A5E3D3EB
    .global _Pattern16_A5E3D3EB_s_bss
_Pattern16_A5E3D3EB_s_bss:
_Pattern16_s_bss:
    .space 128

# -->    1: MODULE Pattern16;
# -->    2: VAR
# -->    3:   m, n: INTEGER;
# -->    4:   x: REAL;
# -->    5:   u: SET;
# -->    6:   a, b: ARRAY 10 OF INTEGER;
# -->    7:   s, t: ARRAY 16 OF CHAR;
# -->    8:   
# -->    9: BEGIN


    .align 4
    .section .init_Pattern16_A5E3D3EB

_Pattern16_init:
    entry a1, 16
    movi a2, _Pattern16_s_bss
# -->   10:   INC(m);
    mov a3, a2
    l32i a4, a3, 0
    addi a4, a4, 1
    s32i a4, a3, 0
# -->   11:   DEC(n, 10);
    addi a3, a2, 4
    l32i a4, a3, 0
    addi a4, a4, -10
    s32i a4, a3, 0
# -->   12:   INCL(u, 3);
    addi a3, a2, 12
    l32i a4, a3, 0
    movi a5, 1
    slli a5, a5, 3
    or a4, a4, a5
    s32i a4, a3, 0
# -->   13:   EXCL(u, 7);
    addi a3, a2, 12
    l32i a4, a3, 0
    movi a5, 1
    slli a5, a5, 7
    movi a6, -1
    xor a5, a5, a6
    and a4, a4, a5
    s32i a4, a3, 0
# -->   14:   ASSERT(m < n);
    l32i a3, a2, 0
    l32i a4, a2, 4
    blt a3, a4, 1$
    movi a6, 1794
    call4 _OberonSyscallHandler
1$:
# -->   15:   UNPK(x, n);
    l32i a3, a2, 8
    srai a4, a3, 23
    addi a4, a4, -127
    s32i a4, a2, 4
    slli a4, a4, 23
    sub a3, a3, a4
    s32i a3, a2, 8
# -->   16:   PACK(x, n);
    l32i a3, a2, 8
    l32i a4, a2, 4
    slli a4, a4, 23
    add a3, a3, a4
    s32i a3, a2, 8
# -->   17:   s := "0123456789";
    addi a3, a2, 96
    movi a4, _Pattern16_data_strs
    movi a5, 3
    loop a5, 2$
    l32i a6, a4, 0
    addi a4, a4, 4
    s32i a6, a3, 0
    addi a3, a3, 4
2$:
# -->   18:   IF s < t THEN
    addi a5, a2, 96
    addi a6, a2, 112
3$:
    l8ui a3, a5, 0
    addi a5, a5, 1
    l8ui a4, a6, 0
    addi a6, a6, 1
    bne a3, a4, 4$
    bnez a3, 3$
4$:
    bge a3, a4, 5$
# -->   19:     m := 1
# -->   20:   END
    movi a3, 1
    s32i a3, a2, 0
5$:
# -->   21: END Pattern16.
    retw
    .size _Pattern16_init, .-_Pattern16_init


    .align 4
    .section .init_table_Pattern16_A5E3D3EB
    .int _Pattern16_init

