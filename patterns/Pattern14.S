
    .title "Module Pattern14, Key A5E3D3E9"
    .sbttl "Oberon ESP32 Compiler Version 0.1.0"


    .align 4
    .section .data_types_Pattern14_A5E3D3E9
    .global _Pattern14_A5E3D3E9_s_data_types
_Pattern14_A5E3D3E9_s_data_types:_Pattern14_s_types:
    .int 32
    .int -1
    .int -1
    .int -1
    .int -1
    .int 32
    .int _Pattern14_s_types+20
    .int -1
    .int -1
    .int -1

    .align 4
    .section .bss_Pattern14_A5E3D3E9
    .global _Pattern14_A5E3D3E9_s_bss
_Pattern14_A5E3D3E9_s_bss:
_Pattern14_s_bss:
    .space 32

# -->    1: MODULE Pattern14;
# -->    2: TYPE
# -->    3:   R0 = RECORD
# -->    4:         a, b, c: INTEGER
# -->    5:       END;
# -->    6:   R1 = RECORD (R0)
# -->    7:         d, e: INTEGER
# -->    8:       END;
# -->    9:       
# -->   10: VAR
# -->   11:   r0: R0;
# -->   12:   r1: R1;
# -->   13:   
# -->   14:   PROCEDURE P(VAR r: R0);
# -->   15:   BEGIN


    .align 4
    .section .text_Pattern14_A5E3D3E9
    .global _Pattern14_A5E3D3E9_s_text
_Pattern14_A5E3D3E9_s_text:
    .type _P, @function
_P:
    entry a1, 32
    s32i a2, a1, 0
    s32i a3, a1, 4
    movi a2, _Pattern14_s_bss
# -->   16:     r.a := 1;
    movi a3, 1
    l32i a4, a1, 0
    s32i a3, a4, 0
# -->   17:     r(R1).d := 2
    l32i a3, a1, 4
    l32i a3, a3, 4
    movi a4, _Pattern14_s_types
    addi a4, a4, 20
    beq a3, a4, 1$
    movi a6, 514
    call4 _OberonSyscallHandler
1$:
# -->   18:   END P;
    movi a3, 2
    l32i a4, a1, 0
    s32i a3, a4, 12
    retw
    .size _P, .-_P

# -->   19:   
# -->   20: BEGIN


    .align 4
    .section .init_Pattern14_A5E3D3E9
_Pattern14_init:
    entry a1, 16
    movi a2, _Pattern14_s_bss
# -->   21:   P(r0);
    mov a6, a2
    movi a7, _Pattern14_s_types
    call4 _P
# -->   22:   P(r1)
    addi a6, a2, 12
    movi a7, _Pattern14_s_types
    addi a7, a7, 20
# -->   23: END Pattern14. 
    call4 _P
    retw
    .size _Pattern14_init, .-_Pattern14_init



    .align 4
    .section .init_table_Pattern14_A5E3D3E9
    .int _Pattern14_init
