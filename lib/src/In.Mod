MODULE In;
  (* Still not ready*)
  IMPORT SYSTEM, Kernel, Out;

(* Input from the standard input stream
   Implements the basic library module from "The Oakwood Guidelines for Oberon-2 
   Compiler Developers". All read operations except Char and Line skips over 
   preceding whitespace. *)

  CONST
    (* UART0 Registers *)
    UART_FIFO      = 3FF40000H; (* UART0 fifo address *)
    UART_STATUS    = 3FF4001CH; (* UART0 status register *)
    UART_MEM_CNT   = 3FF40064H; (* UART0 mem count register *)

    CR         = 0DX;
    LF         = 0AX;
    BS         = 08X;
    SPACE      = 20X;
    DQUOTE     = 22X;

  VAR 
    Timeout: INTEGER;
    Done*: BOOLEAN; (* status of last operation *)
    Opened: BOOLEAN;
    Echo: BOOLEAN;

  PROCEDURE SetBaudRate*(baudRate: INTEGER);
  BEGIN
    Out.SetBaudRate(baudRate)
  END SetBaudRate;

  PROCEDURE SetTimeout*(seconds: INTEGER);
  BEGIN
    Timeout := seconds * Kernel.OneSecond;
  END SetTimeout;

  PROCEDURE SetEcho*(echo: BOOLEAN);
  BEGIN
    Echo := echo
  END SetEcho;

  PROCEDURE Open*;
  BEGIN
    IF ~Opened THEN
      Out.SetBaudRate(Out.Baud115K);
      SetTimeout(30);
      Echo := TRUE;
      Opened := TRUE
    END
  END Open;

  PROCEDURE FifoCount(): INTEGER;
  VAR 
    c, r1, r2 : INTEGER;
  BEGIN
    SYSTEM.GET(UART_STATUS, r1);
    SYSTEM.GET(UART_MEM_CNT, r2);
    c := AND(r1, 0FFH) + LSL(AND(r2, 07H), 8);
    RETURN c
  END FifoCount;

  PROCEDURE Flush*;
  VAR ch: CHAR;
  BEGIN
    WHILE FifoCount() > 0 DO SYSTEM.GET(UART_FIFO, ch) END;
  END Flush;

  PROCEDURE Char*(VAR ch: CHAR);
  VAR 
    startTime: Kernel.ClockTime;
    fifoCnt:   INTEGER;
  BEGIN
    Done := FALSE;
    Kernel.GetTime(startTime);
    REPEAT fifoCnt := FifoCount() UNTIL (fifoCnt > 0) OR (Kernel.GetElapseTime(startTime) > Timeout);
    IF fifoCnt > 0 THEN
      Done := TRUE;
      SYSTEM.GET(UART_FIFO, ch);
    END
  END Char;

  PROCEDURE String*(VAR str: ARRAY OF CHAR);
  VAR 
    i:  INTEGER;
    ch: CHAR;
  BEGIN
    Char(ch);
    WHILE Done & (ch # CR) & (ch # DQUOTE) DO 
      IF (ch = BS) THEN
        IF Echo THEN Out.Char(BS); Out.Char(SPACE); Out.Char(BS) END
      ELSIF Echo & (ch >= SPACE) THEN 
        Out.Char(ch)
      END;
      Char(ch);
    END;
    IF ch = DQUOTE THEN
      i := 0;
      Char(ch);
      WHILE Done & (ch # CR) & (ch # DQUOTE) & (i < LEN(str)) DO
        IF (ch = BS) & (i > 0) THEN
          IF Echo THEN Out.Char(BS); Out.Char(SPACE); Out.Char(BS) END;
          DEC(i);
        ELSIF ch >= SPACE THEN
          IF Echo THEN Out.Char(ch) END;
          str[i] := ch;
          INC(i)
        END;
        Char(ch)
      END
    END;
    IF Done & Echo THEN
       Out.Char(ch);
       IF ch = CR THEN Out.Char(LF) END
    END;
    IF i < LEN(str) THEN str[i] := 0X END
  END String;

  PROCEDURE Int*(VAR i: INTEGER);
  VAR
    j :  INTEGER;
    str: ARRAY 16 OF CHAR;
    ch:  CHAR;
    neg: BOOLEAN;
  BEGIN
    Char(ch);
    WHILE Done & (ch # CR) & (ch = SPACE) DO 
      IF (ch = BS) THEN
        IF Echo THEN Out.Char(BS); Out.Char(SPACE); Out.Char(BS) END
      ELSIF Echo & (ch >= SPACE) THEN 
        Out.Char(ch)
      END;
      Char(ch);
    END;
    i := 0; j := 0;
    WHILE Done & ((ch = BS) OR (ch = "-") OR ((ch >= "0") & (ch <= "9"))) & (j < LEN(str)) DO
    IF (ch = BS) & (j > 0) THEN
        IF Echo THEN Out.Char(BS); Out.Char(SPACE); Out.Char(BS) END;
        DEC(j);
      ELSIF ch > SPACE THEN
        IF Echo THEN Out.Char(ch) END;
        str[j] := ch;
        INC(j)
      END;
      Char(ch)
    END;
    IF Done & Echo THEN
      Out.Char(ch);
      IF ch = CR THEN Out.Char(LF) END
    END;
    IF j < LEN(str) THEN str[j] := 0X END;

    i := 0;
    IF Done THEN
      j := 0;
      neg := FALSE;
      WHILE (j < 16) & (str[j] # 0X) & (str[j] # "-") & ((str[j] < "0") OR (str[j] > "9")) DO INC(j) END;
      IF str[j] = "-" THEN neg := TRUE; INC(j) END;
      WHILE (j < 16) & (str[j] # 0X) & (str[j] >= "0") & (str[j] <= "9") DO 
        i := (i * 10) + (ORD(str[j]) - ORD("0"));
        INC(j) 
      END;
      IF neg THEN i := -i END;
    END
  END Int;

  (* PROCEDURE Real*(VAR x: REAL);
  BEGIN
  END Real;

  PROCEDURE Name*(VAR name: ARRAY OF CHAR);
  BEGIN
  END Name; *)

  PROCEDURE Line*(VAR line: ARRAY OF CHAR);
  VAR 
    i:  INTEGER;
    ch: CHAR;
  BEGIN
    Char(ch);
    i := 0;
    WHILE Done & (ch # CR) & (i < LEN(line)) DO
      IF (ch = BS) & (i > 0) THEN
        IF Echo THEN Out.Char(BS); Out.Char(SPACE); Out.Char(BS) END;
        DEC(i);
      ELSIF ch >= SPACE THEN
        IF Echo THEN Out.Char(ch) END;
        line[i] := ch;
        INC(i)
      END;
      Char(ch)
    END;
    IF Done & Echo & (ch = CR) THEN Out.Char(CR); Out.Char(LF) END;
    IF i < LEN(line) THEN line[i] := 0X END
  END Line;

BEGIN
  Open;
END In.