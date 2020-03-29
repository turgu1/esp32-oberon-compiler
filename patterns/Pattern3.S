
    .title "Module Pattern3, Key A7E2D4B5"
    .sbttl "Oberon ESP32 Compiler Version 0.1.0"

    .align 4
    .section .bss_Pattern3_A7E2D4B5
    .global _Pattern3_A7E2D4B5_s_bss
_Pattern3_A7E2D4B5_s_bss:
_Pattern3_s_bss:
    .space 4456

# -->    1: MODULE Pattern3;
# -->    2: VAR
# -->    3:   i, j, k, n: INTEGER; 
# -->    4:   a: ARRAY 10 OF INTEGER;
# -->    5:   x: ARRAY 10, 10 OF INTEGER;
# -->    6:   y: ARRAY 10, 10, 10 OF INTEGER;
# -->    8: BEGIN 


    .align 4
    .section .init_Pattern3_A7E2D4B5
_Pattern3_init:
    entry a1, 16
    movi a2, _Pattern3_s_bss
# -->    9:   k := a[i]; 
    l32i a3, a2, 0
    movi a4, 10
    blt a3, a4, 1$
    movi a6, 258
    call4 _OberonSyscallHandler
1$:
    slli a3, a3, 2
    add a3, a2, a3
    l32i a3, a3, 16
    s32i a3, a2, 8
# -->   10:   n := a[5]; 
    l32i a3, a2, 36
    s32i a3, a2, 12
# -->   11:   x[i, j] := 2;
    l32i a3, a2, 0
    movi a4, 10
    blt a3, a4, 2$
    movi a6, 258
    call4 _OberonSyscallHandler
2$:
    movi a4, 40
    mull a3, a3, a4
    add a3, a2, a3
    l32i a4, a2, 4
    movi a5, 10
    blt a4, a5, 3$
    movi a6, 258
    call4 _OberonSyscallHandler
3$:
    slli a4, a4, 2
    add a3, a3, a4
    movi a4, 2
    s32i a4, a3, 56
# -->   12:   y[i, j, k] := 3;
    l32i a3, a2, 0
    movi a4, 10
    blt a3, a4, 4$
    movi a6, 258
    call4 _OberonSyscallHandler
4$:
    movi a4, 400
    mull a3, a3, a4
    add a3, a2, a3
    l32i a4, a2, 4
    movi a5, 10
    blt a4, a5, 5$
    movi a6, 258
    call4 _OberonSyscallHandler
5$:
    movi a5, 40
    mull a4, a4, a5
    add a3, a3, a4
    l32i a4, a2, 8
    movi a5, 10
    blt a4, a5, 6$
    movi a6, 258
    call4 _OberonSyscallHandler
6$:
    slli a4, a4, 2
    add a3, a3, a4
    movi a4, 3
    s32i a4, a3, 456
# -->   13:   y[3, 4, 5] := 6
# -->   14: END Pattern3.
    movi a3, 6
    addmi a4, a2, 1792
    s32i a3, a4, 44
    retw
    .size _Pattern3_init, .-_Pattern3_init



    .align 4
    .section .init_table_Pattern3_A7E2D4B5
    .int _Pattern3_init
