MODULE [CDECL] Pattern22;

  CONST C1* = 21X; C2* = "HELLO!";

  TYPE 
    R*  = RECORD i, j: INTEGER END ;
    A*  = ARRAY 20 OF R;
    P*  = POINTER TO R;
    PI* = POINTER TO INTEGER;
    PR1* = PROCEDURE (a: A): INTEGER;
    PR2* = PROCEDURE (a: ARRAY OF CHAR);

  PROCEDURE test*(r: R): INTEGER;

END Pattern22.