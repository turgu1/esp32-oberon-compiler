
    .title "Module Pattern13, Key A5E3D3E8"
    .sbttl "Oberon ESP32 Compiler Version 0.1.0"


    .align 4
    .section .data_types_Pattern13_A5E3D3E8
    .global _Pattern13_A5E3D3E8_s_data_types
_Pattern13_A5E3D3E8_s_data_types:_Pattern13_s_types:
    .int 32
    .int -1
    .int -1
    .int -1
    .int -1
    .int 32
    .int _Pattern13_s_types+20
    .int -1
    .int -1
    .int -1
    .int 32
    .int _Pattern13_s_types+20
    .int _Pattern13_s_types+40
    .int -1
    .int -1

    .align 4
    .section .bss_Pattern13_A5E3D3E8
    .global _Pattern13_A5E3D3E8_s_bss
_Pattern13_A5E3D3E8_s_bss:
_Pattern13_s_bss:
    .space 12

    .align 4
    .section .pointers_table_Pattern13_A5E3D3E8
    .int _Pattern13_s_bss + 0
    .int _Pattern13_s_bss + 4
    .int _Pattern13_s_bss + 8

# -->    1: MODULE Pattern13;
# -->    2: TYPE
# -->    3:   P0 = POINTER TO R0;
# -->    4:   P1 = POINTER TO R1;
# -->    5:   P2 = POINTER TO R2;
# -->    6:   
# -->    7:   R0 = RECORD
# -->    8:         x: INTEGER
# -->    9:       END;
# -->   10:   R1 = RECORD (R0)
# -->   11:         y: INTEGER
# -->   12:       END;
# -->   13:   R2 = RECORD (R1)
# -->   14:         z: INTEGER
# -->   15:       END;
# -->   16:       
# -->   17: VAR
# -->   18:   p0: P0;
# -->   19:   p1: P1;
# -->   20:   p2: P2;
# -->   22: BEGIN 


    .align 4
    .section .init_Pattern13_A5E3D3E8
_Pattern13_init:
    entry a1, 16
    movi a2, _Pattern13_s_bss
# -->   23:   p0.x := 0;
    l32i a3, a2, 0
    bnez a3, 1$
    movi a6, 1026
    call4 _OberonSyscallHandler
1$:
    movi a4, 0
    s32i a4, a3, 0
# -->   24:   p1.y := 1;
    l32i a3, a2, 4
    bnez a3, 2$
    movi a6, 1026
    call4 _OberonSyscallHandler
2$:
    movi a4, 1
    s32i a4, a3, 4
# -->   25:   p0(P1).y := 3;
    l32i a3, a2, 0
    movi a4, 0
    beqz a3, 3$
    addi a3, a3, -8
    l32i a3, a3, 0
    l32i a3, a3, 4
    movi a4, _Pattern13_s_types
    addi a4, a4, 20
3$:
    beq a3, a4, 4$
    movi a6, 514
    call4 _OberonSyscallHandler
4$:
    movi a4, 3
    s32i a4, a3, 4
# -->   26:   p0(P2).z := 5;
    l32i a3, a2, 0
    movi a4, 0
    beqz a3, 5$
    addi a3, a3, -8
    l32i a3, a3, 0
    l32i a3, a3, 8
    movi a4, _Pattern13_s_types
    addi a4, a4, 40
5$:
    beq a3, a4, 6$
    movi a6, 514
    call4 _OberonSyscallHandler
6$:
    movi a4, 5
    s32i a4, a3, 8
# -->   27:   IF p1 IS P2 THEN
    l32i a3, a2, 4
    movi a4, 0
    beqz a3, 7$
    addi a3, a3, -8
    l32i a3, a3, 0
    l32i a3, a3, 8
    movi a4, _Pattern13_s_types
    addi a4, a4, 40
7$:
    bne a3, a4, 8$
# -->   28:     p0 := p2
# -->   29:   END
    l32i a3, a2, 8
    s32i a3, a2, 0
8$:
# -->   30: END Pattern13.
    retw
    .size _Pattern13_init, .-_Pattern13_init



    .align 4
    .section .init_table_Pattern13_A5E3D3E8
    .int _Pattern13_init
