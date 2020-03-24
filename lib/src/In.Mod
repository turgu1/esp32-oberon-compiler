MODULE In;
  (* Still not ready*)
  IMPORT SYSTEM, Kernel, Out;

(* Input from the standard input stream
   Implements the basic library module from "The Oakwood Guidelines for Oberon-2 
   Compiler Developers". All read operations except Char and Line skips over 
   preceding whitespace. *)

  CONST
    (* UART0 Registers *)
    Fifo      = 3FF40000H; (* UART0 fifo address *)
    status    = 3FF4001CH; (* UART0 status register *)

    CR         = 0DX;
    LF         = 0AX;
    BS         = 08X;

  VAR 
    Done: BOOLEAN; (* status of last operation *)
    Opened: BOOLEAN;

  PROCEDURE SetBaudRate*(baudRate: INTEGER);
  BEGIN
    Out.SetBaudRate(baudRate)
  END SetBaudRate;

  PROCEDURE Open*;
  BEGIN
    IF ~Opened THEN
      Out.SetBaudRate(Baud115K);
      Opened := TRUE
    END
  END Open;

  PROCEDURE Char*(VAR ch: CHAR);
  BEGIN
  END Char;

  PROCEDURE Int*(VAR i: INTEGER);
  VAR
    ch: CHAR;
  BEGIN
    i := 0;
    Char(ch); WHILE Done & (ch = SPACE) & (ch = TAB) DO Char(ch) END;
    WHILE Done & (ch >= "0") & (ch <= "9") DO
      i := (i * 10) + (ORD(ch) - ORD("0"));
      Char(ch);
    END;
  END Int;

  PROCEDURE Real*(VAR x: REAL);
  BEGIN
  END Real;

  PROCEDURE String*(VAR str: ARRAY OF CHAR);
  BEGIN
  END String;

  PROCEDURE Name*(VAR name: ARRAY OF CHAR);
  BEGIN
  END Name;

  PROCEDURE Line*(VAR line: ARRAY OF CHAR);
  VAR 
    i: INTEGER;
    ch: CHAR;
  BEGIN
    Char(ch);
    WHILE Done & (ch # CR) & (i < LEN(line)) DO
      IF (ch = BS) & (i > 0) THEN
        Out.Char(BS); Out.Char(SPACE); Out.Char(BS);
        DEC(i);
      ELSIF ch >= SPACE THEN
        line[i] := ch;
        INC(i)
      END;
      Char(ch)
    END;
    IF i < LEN(line) THEN line[i] := 0X END
  END Line;

BEGIN
  Open;
END In.