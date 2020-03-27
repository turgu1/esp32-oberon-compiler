    .title "Module Pattern4, Key A8E2D4B5"
    .sbttl "Oberon ESP32 Compiler Version 0.1.0"

    .align 4
    .section .data_types_Pattern4_A8E2D4B5
    .global _Pattern4_A8E2D4B5_s_data_types
_Pattern4_A8E2D4B5_s_data_types:
_Pattern4_s_types:
    .int 32
    .int -1
    .int -1
    .int -1
    .int _Pattern4_s_types+12
    .int -1

    .align 4
    .section .bss_Pattern4_A8E2D4B5
    .global _Pattern4_A8E2D4B5_s_bss
_Pattern4_A8E2D4B5_s_bss:
_Pattern4_s_bss:
    .space 24

    .align 4
    .section .pointers_table_Pattern4_A8E2D4B5
    .int _Pattern4_s_bss + 0
    .int _Pattern4_s_bss + 4
    .int _Pattern4_s_bss + 20

# -->    1: MODULE Pattern4;
# -->    2: TYPE
# -->    3:   Ptr = POINTER TO Node;
# -->    4:   Node = RECORD 
# -->    5:     num: INTEGER;
# -->    6:     name: ARRAY 8 OF CHAR;
# -->    7:     next: Ptr
# -->    8:   END;
# -->    9: VAR 
# -->   10:   p, q: Ptr;
# -->   11:   r: Node;
# -->   12:     
# -->   13: BEGIN


    .align 4
    .section .init_Pattern4_A8E2D4B5

_Pattern4_init:
    entry a1, 16
    movi a2, _Pattern4_s_bss
# -->   14:   (* $D+ *)
# -->   15:   r.num := 10; 
    movi a3, 10
    s32i a3, a2, 8
# -->   16:   p.num := 6;
    l32i a3, a2, 0
    bnez a3, 1$
    movi a6, 1026
    call4 _OberonSyscallHandler
1$:
    movi a4, 6
    s32i a4, a3, 0
# -->   17:   (* $D- *)
# -->   18:   p.name[7] := "0";
    l32i a3, a2, 0
    bnez a3, 2$
    movi a6, 1026
    call4 _OberonSyscallHandler
2$:
    movi a4, 48
    s8i a4, a3, 11
# -->   19:   p.next := q;
    l32i a3, a2, 0
    bnez a3, 3$
    movi a6, 1026
    call4 _OberonSyscallHandler
3$:
    l32i a4, a2, 4
    s32i a4, a3, 12
# -->   20:   p.next.next := NIL
    l32i a3, a2, 0
    bnez a3, 4$
    movi a6, 1026
    call4 _OberonSyscallHandler
4$:
    l32i a3, a3, 12
    bnez a3, 5$
    movi a6, 1026
    call4 _OberonSyscallHandler
5$:
# -->   21: END Pattern4.
    movi a4, 0
    s32i a4, a3, 12
    retw
    .size _Pattern4_init, .-_Pattern4_init


    .align 4
    .section .init_table_Pattern4_A8E2D4B5
    .int _Pattern4_init

