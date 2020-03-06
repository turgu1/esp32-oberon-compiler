MODULE Pattern14;
TYPE
  R0 = RECORD
        a, b, c: INTEGER
      END;
  R1 = RECORD (R0)
        d, e: INTEGER
      END;
      
VAR
  r0: R0;
  r1: R1;
  
  PROCEDURE P(VAR r: R0);
  BEGIN
    r.a := 1;
    r(R1).d := 2
  END P;
  
BEGIN
  P(r0);
  P(r1)
END Pattern14. 

(* 
    .title "Module Pattern14, Key A5E3D3E9"
    .sbttl "Oberon ESP32 Compiler Version 0.1.0"

    .align 4
    .section .data_types_Pattern14_A5E3D3E9
    .global _Pattern14_A5E3D3E9_s_data_types
_Pattern14_A5E3D3E9_s_data_types:
_Pattern14_s_types:
    .int 32,-1,-1,-1,-1,32,81926,-1
    .int -1,-1

    .align 4
    .section .bss_Pattern14_A5E3D3E9
    .global _Pattern14_A5E3D3E9_s_bss
_Pattern14_A5E3D3E9_s_bss:
_Pattern14_s_bss:
    .space 72


    .align 4
    .section .text_Pattern14_A5E3D3E9
    .global _Pattern14_A5E3D3E9_s_text
_Pattern14_A5E3D3E9_s_text:

_P:
    entry a1, 32
    s32i a2, a1, 0
    s32i a3, a1, 4
    movi a2, 1
    l32i a3, a1, 0
    s32i a2, a3, 0
    l32i a2, a1, 4
    l32i a2, a2, 4
    addi a3, a15, 20
    movi a2, 2
    l32i a3, a1, 0
    s32i a2, a3, 12
    retw
    .size _P, .-_P


    .align 4
    .section .init_Pattern14_A5E3D3E9

_Pattern14_init:
    entry a1, 16
    movi a15, _Pattern14_s_bss
    addi a6, a15, 40
    mov a7, a15
    call4 _P
    addi a6, a15, 52
    addi a7, a15, 20
    call4 _P
    retw
    .size _Pattern14_init, .-_Pattern14_init


    .align 4
    .section .init_table_Pattern14_A5E3D3E9
    .int _Pattern14_init

*)