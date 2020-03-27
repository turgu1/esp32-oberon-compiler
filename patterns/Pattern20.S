    .title "Module Pattern20, Key A6E3D3E5"
    .sbttl "Oberon ESP32 Compiler Version 0.1.0"

    .align 4
    .section .bss_Pattern20_A6E3D3E5
    .global _Pattern20_A6E3D3E5_s_bss
_Pattern20_A6E3D3E5_s_bss:
_Pattern20_s_bss:
    .space 20

# -->    1: MODULE Pattern20;
# -->    2: VAR
# -->    3:   b: BOOLEAN;
# -->    4:   i, j: INTEGER;
# -->    5:   p: PROCEDURE (a, b: INTEGER);
# -->    6:   s: SET;
# -->    7:   PROCEDURE q(a, b: INTEGER);
# -->    8:     VAR bb: BOOLEAN;
# -->    9:     PROCEDURE qa(a, b: BOOLEAN): BOOLEAN;
# -->   10:     BEGIN

    .align 4
    .section .text_Pattern20_A6E3D3E5
    .global _Pattern20_A6E3D3E5_s_text
_Pattern20_A6E3D3E5_s_text:

    .type _qa, @function
_qa:
    entry a1, 32
    s32i a2, a1, 0
    s32i a3, a1, 4
    movi a2, _Pattern20_s_bss
# -->   11:       RETURN a & b
    l8ui a3, a1, 0
    beqz a3, 1$
# -->   12:     END qa;
    l8ui a3, a1, 4
    beqz a3, 1$
    movi a3, 1
    j 2$
1$:
    movi a3, 0
2$:
    retw
    .size _qa, .-_qa
# -->   13:     PROCEDURE qb(a, b: BOOLEAN): BOOLEAN;
# -->   14:     BEGIN

    .align 4
    .type _qb, @function
_qb:
    entry a1, 32
    s32i a2, a1, 0
    s32i a3, a1, 4
    movi a2, _Pattern20_s_bss
# -->   15:       RETURN a OR b
    l8ui a3, a1, 0
    bnez a3, 1$
# -->   16:     END qb;
    l8ui a3, a1, 4
    beqz a3, 2$
1$:
    movi a3, 1
    j 3$
2$:
    movi a3, 0
3$:
    retw
    .size _qb, .-_qb
# -->   17:   BEGIN

    .align 4
    .type _q, @function
_q:
    entry a1, 32
    s32i a2, a1, 0
    s32i a3, a1, 4
    movi a2, _Pattern20_s_bss
# -->   18:     i := 1;
    movi a3, 1
    s32i a3, a2, 4
# -->   19:     bb := qa(TRUE, FALSE);
    movi a6, 1
    movi a7, 0
    call4 _qa
    mov a3, a7
    s8i a3, a1, 8
# -->   20:     bb := qb(TRUE, FALSE);
    movi a6, 1
    movi a7, 0
    call4 _qb
    mov a3, a7
    s8i a3, a1, 8
# -->   21:   END q;
    retw
    .size _q, .-_q
# -->   22: BEGIN


    .align 4
    .section .init_Pattern20_A6E3D3E5

_Pattern20_init:
    entry a1, 16
    movi a2, _Pattern20_s_bss
# -->   23:   INCL(s, 3);
    addi a3, a2, 16
    l32i a4, a3, 0
    movi a5, 1
    slli a5, a5, 3
    or a4, a4, a5
    s32i a4, a3, 0
# -->   24:   INCL(s, i);
    addi a3, a2, 16
    l32i a4, a3, 0
    movi a5, 1
    l32i a6, a2, 4
    ssl a6
    sll a5, a5
    or a4, a4, a5
    s32i a4, a3, 0
# -->   25:   EXCL(s, 3);
    addi a3, a2, 16
    l32i a4, a3, 0
    movi a5, 1
    slli a5, a5, 3
    movi a6, -1
    xor a5, a5, a6
    and a4, a4, a5
    s32i a4, a3, 0
# -->   26:   EXCL(s, i);
    addi a3, a2, 16
    l32i a4, a3, 0
    movi a5, 1
    l32i a6, a2, 4
    ssl a6
    sll a5, a5
    movi a6, -1
    xor a5, a5, a6
    and a4, a4, a5
    s32i a4, a3, 0
# -->   27:   b := i < j;
    l32i a3, a2, 4
    l32i a4, a2, 8
    bge a3, a4, 1$
    movi a3, 1
    j 2$
1$:
    movi a3, 0
2$:
    s8i a3, a2, 0
# -->   28:   b := TRUE;
    movi a3, 1
    s8i a3, a2, 0
# -->   29:   p := q;
    movi a3, _q
    s32i a3, a2, 12
# -->   30:   p(1, 2);
    movi a6, 1
    movi a7, 2
    l32i a8, a2, 12
    bnez a7, 3$
    movi a6, 1282
    call4 _OberonSyscallHandler
3$:
    callx4 a8
# -->   31: END Pattern20.
    retw
    .size _Pattern20_init, .-_Pattern20_init


    .align 4
    .section .init_table_Pattern20_A6E3D3E5
    .int _Pattern20_init

