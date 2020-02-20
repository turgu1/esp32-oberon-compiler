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
   .section .bss._module_Pattern1
    .align 4
_module_Pattern1_bss:
ch: .space 1                  # ch: CHAR;
    .align 4                     
k:  .space 4                  # k: INTEGER
x:  .space 4                  # x: REAL
s:  .space 4                  # s: SET

    .section .data._module_Pattern1
    .align 4
_module_Pattern1_data:
    .int 0x3F800000           # 1.0

    .section .text._module_Pattern1
    .align 4
_module_Pattern1_data_addr: .int _module_Pattern1_data
_module_Pattern1_bss_addr:  .int _module_Pattern1_bss

    .section .init._module_Pattern1
    .align 4
_module_Pattern1_init:
    entry a1, 0
    l32r a2, _module_Pattern1_bss_addr
    movi a3, 0x30          # ch := "0"  
    s8i  a3, a2, 0
    movi a3, 10            # k := 10
    s32i a3, a2, 4
    l32r a4, _module_Pattern1_data_addr  x := 1.0
    l32r a3, a4, 0
    s32i a3, a2, 8
    movi a3, 0x111         # s := {0, 4, 8}
    s32i a3, a2, 12
    retw

    .section .init_table._module_Pattern1
    .int _module_Pattern1_init 
*)