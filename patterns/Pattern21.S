    .title "Module Pattern21, Key A6E3D3E6"
    .sbttl "Oberon ESP32 Compiler Version 0.1.0"

    .align 4
    .section .data_types_Pattern21_A6E3D3E6
    .global _Pattern21_A6E3D3E6_s_data_types
_Pattern21_A6E3D3E6_s_data_types:
_Pattern21_s_types:
    .int 32
    .int -1
    .int -1
    .int -1
    .int -1
    .int 32
    .int _Pattern21_s_types+20
    .int -1
    .int -1
    .int -1
    .int 32
    .int _Pattern21_s_types+40
    .int -1
    .int -1
    .int -1
    .int 32
    .int _Pattern21_s_types+60
    .int -1
    .int -1
    .int -1

    .align 4
    .section .bss_Pattern21_A6E3D3E6
    .global _Pattern21_A6E3D3E6_s_bss
_Pattern21_A6E3D3E6_s_bss:
_Pattern21_s_bss:
    .space 4

    .align 4
    .section .pointers_table_Pattern21_A6E3D3E6
    .int _Pattern21_s_bss + 0

# -->    1: MODULE Pattern21;
# -->    2: TYPE 
# -->    3:   R  = RECORD a: INTEGER END; 
# -->    4:   R0 = RECORD (R) b: INTEGER END;
# -->    5:   R1 = RECORD (R) b: REAL END;
# -->    6:   R2 = RECORD (R) b: SET END;
# -->    7:   P  = POINTER TO R; 
# -->    8:   P0 = POINTER TO R0;
# -->    9:   P1 = POINTER TO R1; 
# -->   10:   P2 = POINTER TO R2;
# -->   11: VAR 
# -->   12:   p: P;
# -->   13: BEGIN


    .align 4
    .section .init_Pattern21_A6E3D3E6

_Pattern21_init:
    entry a1, 16
    movi a2, _Pattern21_s_bss
# -->   14:   CASE p OF
# -->   15:     P0: p.b := 10  |
    l32i a3, a2, 0
    movi a4, 0
    beqz a3, 2$
    addi a3, a3, -8
    l32i a3, a3, 0
    l32i a3, a3, 4
    movi a4, _Pattern21_s_types
    addi a4, a4, 20
2$:
    bne a3, a4, 3$
    l32i a3, a2, 0
    bnez a3, 4$
    movi a6, 1026
    call4 _OberonSyscallHandler
4$:
    movi a4, 10
    s32i a4, a3, 4
    j 1$
# -->   16:     P1: p.b := 2.5 |
3$:
    l32i a3, a2, 0
    movi a4, 0
    beqz a3, 5$
    addi a3, a3, -8
    l32i a3, a3, 0
    l32i a3, a3, 4
    movi a4, _Pattern21_s_types
    addi a4, a4, 40
5$:
    bne a3, a4, 6$
    l32i a3, a2, 0
    bnez a3, 7$
    movi a6, 1026
    call4 _OberonSyscallHandler
7$:
    movi a4, 1075838976
    s32i a4, a3, 4
    j 1$
# -->   17:     P2: p.b := {0, 2} 
6$:
    l32i a3, a2, 0
    movi a4, 0
    beqz a3, 8$
    addi a3, a3, -8
    l32i a3, a3, 0
    l32i a3, a3, 4
    movi a4, _Pattern21_s_types
    addi a4, a4, 60
8$:
    bne a3, a4, 9$
    l32i a3, a2, 0
    bnez a3, 10$
    movi a6, 1026
    call4 _OberonSyscallHandler
10$:
# -->   18:   END
    movi a4, 5
    s32i a4, a3, 4
    j 1$
9$:
1$:
# -->   19: END Pattern21.
    retw
    .size _Pattern21_init, .-_Pattern21_init


    .align 4
    .section .init_table_Pattern21_A6E3D3E6
    .int _Pattern21_init

