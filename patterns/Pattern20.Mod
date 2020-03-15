MODULE Pattern20;
VAR
  b: BOOLEAN;
  i, j: INTEGER;
  p: PROCEDURE (a, b: INTEGER);
  s: SET;

  PROCEDURE q(a, b: INTEGER);
    VAR bb: BOOLEAN;
    PROCEDURE qa(a, b: BOOLEAN): BOOLEAN;
    BEGIN
      RETURN a & b
    END qa;

    PROCEDURE qb(a, b: BOOLEAN): BOOLEAN;
    BEGIN
      RETURN a OR b
    END qb;

  BEGIN
    i := 1;
    bb := qa(TRUE, FALSE);
    bb := qb(TRUE, FALSE);
  END q;

BEGIN
  INCL(s, 3);
  INCL(s, i);
  EXCL(s, 3);
  EXCL(s, i);
  b := i < j;
  b := TRUE;
  p := q;
  p(1, 2);
END Pattern20.

(*
    .title "Module Pattern20, Key A6E3D3E5"
    .sbttl "Oberon ESP32 Compiler Version 0.1.0"

    .align 4
    .section .bss_Pattern20_A6E3D3E5
    .global _Pattern20_A6E3D3E5_s_bss
_Pattern20_A6E3D3E5_s_bss:
_Pattern20_s_bss:
    .space 20


    .align 4
    .section .text_Pattern20_A6E3D3E5
    .global _Pattern20_A6E3D3E5_s_text
_Pattern20_A6E3D3E5_s_text:

_qa:
    entry a1, 32
    s32i a2, a1, 0
    s32i a3, a1, 4
    l8ui a2, a1, 0
    beqz a2, L1
    l8ui a2, a1, 4
    beqz a2, L3
    movi a2, 1
    j L4
L3:
    movi a2, 0
L4:
    retw
    .size _qa, .-_qa

    .align 4
_qb:
    entry a1, 32
    s32i a2, a1, 0
    s32i a3, a1, 4
    l8ui a2, a1, 0
    bnez a2, L5
    l8ui a2, a1, 4
    beqz a2, L7
    movi a2, 1
    j L8
L7:
    movi a2, 0
L8:
    retw
    .size _qb, .-_qb

    .align 4
_q:
    entry a1, 32
    s32i a2, a1, 0
    s32i a3, a1, 4
    movi a2, 1
    s32i a2, a15, 4
    movi a6, 1
    movi a7, 0
    call4 _qa
    mov a2, a6
    s8i a2, a1, 8
    movi a6, 1
    movi a7, 0
    call4 _qb
    mov a2, a6
    s8i a2, a1, 8
    retw
    .size _q, .-_q


    .align 4
    .section .init_Pattern20_A6E3D3E5

_Pattern20_init:
    entry a1, 16
    movi a15, _Pattern20_s_bss
    addi a2, a15, 16
    l32i a3, a2, 0
    movi a4, 1
    slli a4, a4, 3
    or a3, a3, a4
    s32i a3, a2, 0
    addi a2, a15, 16
    l32i a3, a2, 0
    movi a4, 1
    l32i a5, a15, 4
    ssl a5
    sll a4, a4
    or a3, a3, a4
    s32i a3, a2, 0
    addi a2, a15, 16
    l32i a3, a2, 0
    movi a4, 1
    slli a4, a4, 3
    movi a5, -1
    xor a4, a4, a5
    and a3, a3, a4
    s32i a3, a2, 0
    addi a2, a15, 16
    l32i a3, a2, 0
    movi a4, 1
    l32i a5, a15, 4
    ssl a5
    sll a4, a4
    movi a5, -1
    xor a4, a4, a5
    and a3, a3, a4
    s32i a3, a2, 0
    l32i a2, a15, 4
    l32i a3, a15, 8
    bge a2, a3, L9
    movi a2, 1
    j L10
L9:
    movi a2, 0
L10:
    s8i a2, a15, 0
    movi a2, 1
    s8i a2, a15, 0
    movi a2, _q
    s32i a2, a15, 12
    movi a6, 1
    movi a7, 2
    l32i a8, a15, 12
    callx4 a8
    movi a15, _Pattern20_s_bss
    retw
    .size _Pattern20_init, .-_Pattern20_init


    .align 4
    .section .init_table_Pattern20_A6E3D3E5
    .int _Pattern20_init

*)