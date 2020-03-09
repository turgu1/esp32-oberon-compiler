MODULE Pattern13;
TYPE
  P0 = POINTER TO R0;
  P1 = POINTER TO R1;
  P2 = POINTER TO R2;
  
  R0 = RECORD
        x: INTEGER
      END;
  R1 = RECORD (R0)
        y: INTEGER
      END;
  R2 = RECORD (R1)
        z: INTEGER
      END;
      
VAR
  p0: P0;
  p1: P1;
  p2: P2;
DBGON  
BEGIN 
  p0(P1).y := 3;
END Pattern13.
DBGOFF
(* 
    .section .bss_module_Pattern13
    .align 4

p0: .space 4
p1: .space 4
p2: .space 4

    .section .init_module_Pattern13
    .align 4

_module_Pattern13_init:
    entry a1, 0
    retw

    .section .init_table_module_Pattern13
    .int _module_Pattern13_init 
*)
