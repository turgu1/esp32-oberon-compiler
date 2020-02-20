MODULE Pattern1;
VAR
  ch: CHAR;
  k:  INTEGER;
  x:  REAL;
  s:  SET;
BEGIN 
  ch := "0";
  k  :=  10;
  x  := 1.0;
  s  := {0, 4, 8}
END Pattern1.

(* 
    .section .bss_module_Pattern1
    .align 4

ch: .space 1                  # ch: CHAR;
    .align 4                     
k:  .space 4                  # k: INTEGER
x:  .space 4                  # x: REAL
s:  .space 4                  # s: SET

    .section .init_module_Pattern1
    .align 4

_module_Pattern1_init:
    entry a1, 0
    movi a2, .bss_module_Pattern1
    movi a3, 0x30          # ch := "0"  
    s8i  a3, a2, 0
    movi a3, 10            # k := 10
    s32i a3, a2, 4
    movi a4, 0x3F800000    # x := 1.0
    s32i a3, a2, 8
    movi a3, 0x111         # s := {0, 4, 8}
    s32i a3, a2, 12
    retw

    .section .init_table_module_Pattern1
    .int _module_Pattern1_init 
*)