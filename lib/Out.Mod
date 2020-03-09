(* ESP32 UART0 Output Module *)

MODULE Out;
IMPORT SYSTEM;

CONST
  (* UART0 Registers *)
  Fifo      = 3FF40000H; (* UART0 fifo address *)
  ClkDiv    = 3FF40014H; (* UART0 clock divisor *)
  status    = 3FF4001CH; (* UART0 status register *)

  Baud115K*  = 80000000 DIV 115200;
  Baud76800* = 80000000 DIV 76800;
  Baud38400* = 80000000 DIV 38400;
  Baud19200* = 80000000 DIV 19200;
  Baud9600*  = 80000000 DIV 9600;
  
  CR        = 0DX;
  LF        = 0AX;

PROCEDURE FifoCount(): INTEGER;
VAR 
  c, r : INTEGER;
BEGIN
  SYSTEM.GET(status, r);
  c := ASR(r, 16) MOD 256;
  RETURN c
END FifoCount;

PROCEDURE Flush*;
BEGIN
  WHILE FifoCount() > 0 DO END
END Flush;

PROCEDURE Char*(ch: CHAR);
BEGIN
  WHILE FifoCount() > 120 DO END; (* Wait for some space in UART xmit FIFO *)
  SYSTEM.PUT(Fifo, ORD(ch))
END Char;

PROCEDURE String*(s: ARRAY OF CHAR);
VAR
  i: INTEGER;
BEGIN
  i := 0;  
  WHILE  (i < LEN(s)) & (s[i] # 0X) DO
    Char(s[i]);
    INC(i)
  END
END String;

PROCEDURE Int*(x, n: INTEGER);
VAR
  i, x0: INTEGER;
  a: ARRAY 10 OF CHAR;
BEGIN
  i := 0;
  IF x < 0 THEN
    x0 := -x; DEC(n) 
  ELSE
    x0 := x 
  END;
  REPEAT
    a[i] := CHR(x0 MOD 10 + 30H); 
    x0 := x0 DIV 10; 
    INC(i)
  UNTIL x0 = 0;
  WHILE n > i DO
    Char(" "); DEC(n) 
  END;
  IF x < 0 THEN 
    Char("-") 
  END;
  REPEAT DEC(i); Char(a[i]) UNTIL i = 0
END Int;

PROCEDURE Hex*(x, n: INTEGER);
VAR 
  i, y: INTEGER;
  a: ARRAY 10 OF CHAR;
BEGIN
  i := 0; 
  REPEAT 
    y := x MOD 10H;
    IF y < 10 THEN 
      a[i] := CHR(y + 30H) 
    ELSE 
      a[i] := CHR(y + 37H) 
    END;
    x := x DIV 10H;
    INC(i)
  UNTIL (i = 8);
  WHILE n > 8 DO
    Char(" "); DEC(n) 
  END;
  REPEAT DEC(i); Char(a[i]) UNTIL i = 0
END Hex;

PROCEDURE Ten(n: INTEGER): REAL;
VAR t, p: REAL;
BEGIN t := 1.0; p := 10.0;   (* compute 10^n *)
  WHILE n > 0 DO
    IF ODD(n) THEN t := p * t END;
    p := p*p; n := n DIV 2
  END ;
  RETURN t
END Ten;

PROCEDURE Real*(x: REAL; n,k: INTEGER);
VAR
  i, m: INTEGER; 
  neg: BOOLEAN;
  d: ARRAY 12 OF CHAR;
BEGIN
  IF x = 0.0 THEN String("  0")
  ELSE
    IF x < 0.0 THEN 
      x := -x; 
      neg := TRUE 
    ELSE 
      neg := FALSE 
    END ;
    IF k > 7 THEN k := 7 END;
    x := Ten(k) * x; 
    m := FLOOR(x + 0.5);
    i := 0;
    REPEAT 
      d[i] := CHR(m MOD 10 + 30H); 
      m := m DIV 10; INC(i) 
    UNTIL m = 0;
    Char(" ");
    WHILE n > i+3 DO  Char(" "); DEC(n) END ;
    IF neg THEN Char("-"); DEC(n) ELSE Char(" ") END;
    WHILE i > k DO DEC(i); Char(d[i]) END;
    Char(".");
    WHILE k > i DO DEC(k); Char("0") END;
    WHILE i > 0 DO DEC(i); Char(d[i]) END
  END
END Real;

PROCEDURE Ln*;
BEGIN 
  Char(CR); Char(LF)
END Ln;

PROCEDURE SetBaudRate*(baudRate: INTEGER);
BEGIN
  SYSTEM.PUT(ClkDiv, baudRate)
END SetBaudRate;

PROCEDURE Open*;
BEGIN
  SetBaudRate(Baud115K);
END Open;

BEGIN
  Open;
END Out.
