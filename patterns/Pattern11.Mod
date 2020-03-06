MODULE Pattern11;
VAR
  s: SET; 
  m, n: INTEGER;
  
BEGIN
  s := {m};
  s := {0 .. n};
  s := {m .. 31};
  s := {m .. n};
  IF n IN {2, 3, 5, 7, 11, 13} THEN
    m := 1
  END
END Pattern11.

(* 
    .title "Module Pattern11, Key A5E3D3E6"
    .sbttl "Oberon ESP32 Compiler Version 0.1.0"

    .align 4
    .section .bss_Pattern11_A5E3D3E6
    .global _Pattern11_A5E3D3E6_s_bss
_Pattern11_A5E3D3E6_s_bss:
_Pattern11_s_bss:
    .space 12


    .align 4
    .section .init_Pattern11_A5E3D3E6

_Pattern11_init:
    entry a1, 16
    movi 15, _Pattern11_s_bss
    l32i a2, 15, 4           # a2 := m
    movi a3, 1
    ssl a2
    sll a2, a3               # a2 := {m}
    s32i a2, 15, 0           # s := {m}
    movi a2, -1
    l32i a3, 15, 8           # a3 := n
    bgei a3, 31, 1f          # if a3 >= 31, done
    movi a4, -1
    addi a3, a3, 1
    ssl a3
    sll a3, a4
    xor a2, a2, a3           # a2 := {0..n}
1:
    s32i a2, 15, 0           # s := {0..n}
    l32i a2, 15, 4           # a2 := m
    movi a3, -1
    ssl a2
    sll a2, a3
    s32i a2, 15, 0           # s := {m..31}
    l32i a2, 15, 4           # a2 := m
    movi a3, -1
    ssl a2
    sll a2, a3
    l32i a3, 15, 8           # a3 := n
    bgei a3, 31, 2f
    movi a4, -1
    addi a3, a3, 1
    ssl a3
    sll a3, a4
    xor a2, a2, a3
2:
    s32i a2, 15, 0           # s := {m..n}
    movi a2, 10412           # a2 := {2, 3, 5, 7, 11, 13}
    l32i a3, 15, 8           # a3 := n
    bbc a2 a3, 3f            # branch if n not in set
    movi a2, 1
    s32i a2, 15, 4           # m := 1
3:
    retw
    .size _Pattern11_init, .-_Pattern11_init

    .align 4
    .section .init_table_Pattern11_A5E3D3E6
    .int _Pattern11_init

*)