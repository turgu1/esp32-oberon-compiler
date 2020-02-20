MODULE Pattern4;
TYPE
  Ptr = POINTER TO Node;
  Node = RECORD 
    num: INTEGER;
    name: ARRAY 8 OF CHAR;
    next: Ptr
  END;
VAR 
  p, q: Ptr;
  r: Node;
    
BEGIN
  r.num := 10; 
  p.num := 6;
  p.name[7] := "0";
  p.next := q;
  p.next.next := NIL
END Pattern4.

(* 
    .section .bss_module_Pattern4
    .align 4

p:  space 4
q:  space 4
r:  space 16

    .section .init_module_Pattern4
    .align 4

_module_Pattern4_init:
    entry a1, 0
    retw

    .section .init_table_module_Pattern4
    .int _module_Pattern4_init 
*)