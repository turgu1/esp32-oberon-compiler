    .title "Module Pattern10, Key A5E3D3E5"
    .sbttl "Oberon ESP32 Compiler Version 0.1.0"

    .align 4
    .section .bss_Pattern10_A5E3D3E5
    .global _Pattern10_A5E3D3E5_s_bss
_Pattern10_A5E3D3E5_s_bss:
_Pattern10_s_bss:
    .space 48

# -->    1: MODULE Pattern10;
# -->    2: VAR
# -->    3:   a: ARRAY 12 OF INTEGER;
# -->    4:   
# -->    5:   (* VAR must be there to allow edition of the array, the opposite 
# -->    6:      of the description in the PO.Application.pdf document *)
# -->    7:      
# -->    8:   PROCEDURE P(VAR x: ARRAY OF INTEGER);
# -->    9:   VAR
# -->   10:     i, n: INTEGER;
# -->   11:   BEGIN

    .align 4
    .section .text_Pattern10_A5E3D3E5
    .global _Pattern10_A5E3D3E5_s_text
_Pattern10_A5E3D3E5_s_text:

    .type _P, @function
_P:
    entry a1, 32
    s32i a2, a1, 0
    s32i a3, a1, 4
    movi a2, _Pattern10_s_bss
# -->   12:     n := x[i];
    l32i a3, a1, 8
    l32i a4, a1, 4
    blt a3, a4, 1$
    movi a6, 258
    call4 _OberonSyscallHandler
1$:
    slli a3, a3, 2
    l32i a4, a1, 0
    add a3, a4, a3
    l32i a3, a3, 0
    s32i a3, a1, 12
# -->   13:     x[i + 1] := n + 5
    l32i a3, a1, 8
    addi a3, a3, 1
    l32i a4, a1, 4
    blt a3, a4, 2$
    movi a6, 258
    call4 _OberonSyscallHandler
2$:
    slli a3, a3, 2
    l32i a4, a1, 0
    add a3, a4, a3
# -->   14:   END P;
    l32i a4, a1, 12
    addi a4, a4, 5
    s32i a4, a3, 0
    retw
    .size _P, .-_P
# -->   15:   
# -->   16: BEGIN


    .align 4
    .section .init_Pattern10_A5E3D3E5

_Pattern10_init:
    entry a1, 16
    movi a2, _Pattern10_s_bss
# -->   17:   P(a);
    mov a6, a2
    movi a7, 12
    call4 _P
# -->   18: END Pattern10.
    retw
    .size _Pattern10_init, .-_Pattern10_init


    .align 4
    .section .init_table_Pattern10_A5E3D3E5
    .int _Pattern10_init

