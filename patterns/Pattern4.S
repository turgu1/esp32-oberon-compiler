    .title "Module Pattern4, Key A8E2D4B5"
    .sbttl "Oberon ESP32 Compiler Version 0.1.0"

    .section .bss_Pattern4_A8E2D4B5
    .global _Pattern4_A8E2D4B5_s_bss
_Pattern4_A8E2D4B5_s_bss:
_Pattern4_s_bss:
    .space 48


    .section .init_Pattern4_A8E2D4B5
    .global _Pattern4_A8E2D4B5_s_init
_Pattern4_A8E2D4B5_s_init:

_Pattern4_init:
    entry a1, 0
    movi a2, 10               # a2 := 10
    movi a3, _Pattern4_s_bss
    s32i a2, a3, 32           # r.num := 10
    movi a2, _Pattern4_s_bss 
    l32i a2, a2, 24           # a2 := p
    movi a3, 6                # a3 := 6
    s32i a3, a2, 0            # p.num := 6
    movi a2, _Pattern4_s_bss
    l32i a2, a2, 24           # a2 := p
    movi a3, 48               # a3 := "0"
    s8i a3, a2, 11            # p.name[7] := "0"
    movi a2, _Pattern4_s_bss
    l32i a2, a2, 24           # a2 := p
    movi a3, _Pattern4_s_bss
    l32i a3, a3, 28           # a3 := q
    s32i a3, a2, 12           # p.next := q
    movi a2, _Pattern4_s_bss
    l32i a2, a2, 24           # a2 := p
    l32i a2, a2, 12           # a2 := p.next
    movi a3, 0                # a3 := NIL
    s32i a3, a2, 12           # p.next.next := NIL
    retw

    .section .init_table_Pattern4_A8E2D4B5
    .global _Pattern4_A8E2D4B5_s_init_table
_Pattern4_A8E2D4B5_s_init_table:
    .int .init_Pattern4_A8E2D4B5

