MODULE BitFunc;
  IMPORT Out, T := Test;
  
  VAR x: ARRAY 18 OF BYTE;
      result: ARRAY 7 OF INTEGER;
      i, j: INTEGER;
      ch: INTEGER;

  PROCEDURE next(in: ARRAY OF BYTE; VAR i: INTEGER): INTEGER;
    VAR 
      x, size, b1, b2, b3: INTEGER;
      ch: INTEGER;
  BEGIN
    ch := 0;
    size := LEN(in);
    IF i < size THEN
      b1 := in[i];
      x := ASR(b1, 4);
      CASE x OF
          0..7: (* 1 bytes format: 0xxxxxxx *)
            ch := b1; INC(i)
        | 12,13: (* 2 bytes format: 110xxxxx 10xxxxxx *)
            IF i + 1 < size THEN
              INC(i);
              b2 := in[i];
              IF AND(b2, 0C0H) = 80H THEN
                ch := BOR(LSL(AND(b1, 1FH), 6), AND(b2, 3FH))
              END;
              INC(i)
            END
        | 14:  (* 3 bytes format: 1110xxxx 10xxxxxx 10xxxxxx *)
            IF i + 2 < size THEN
              INC(i);
              b2 := in[i];
              INC(i);
              b3 := in[i];
              IF (AND(b2, 0C0H) = 80H) & (AND(b3, 0C0H) = 80H) THEN
                ch := BOR(LSL(AND(b1, 0FH), 12),
                          BOR(LSL(AND(b2, 3FH), 6), AND(b3, 3FH)));
              END;
              INC(i)
            END
        | 8..11, 15: (* ERROR + 4 bytes format: 11110xxx 10xxxxxx 10xxxxxx 10xxxxxx *)
            ch := 0
      END
    END
    RETURN ch
  END next;

  PROCEDURE Run;
  BEGIN
    Out.String("Bit Functions: "); Out.Flush;

    T.First("A"); 

    x[0]  := 041H; (* One byte *)
    x[1]  := 0D0H; (* Two bytes 110xxxxx 10xxxxxx *)
    x[2]  := 094H;
    x[3]  := 0D0H; (* Two bytes 110xxxxx 10xxxxxx *)
    x[4]  := 0B0H;
    x[5]  := 0E2H; (* Three bytes 1110xxxx 10xxxxxx 10xxxxxx *)
    x[6]  := 082H;
    x[7]  := 0ACH;
    x[8]  := 0E4H; (* Three bytes 1110xxxx 10xxxxxx 10xxxxxx *)
    x[9]  := 0B8H;
    x[10] := 096H;
    x[11] := 0E7H; (* Three bytes 1110xxxx 10xxxxxx 10xxxxxx *)
    x[12] := 095H;
    x[13] := 08CH;
    x[14] := 0F0H; (* Four bytes *)
    x[15] := 000H;
    x[16] := 000H;
    x[17] := 000H;

    result[0] := 00041H;
    result[1] := 00414H;
    result[2] := 00430H;
    result[3] := 020ACH;
    result[4] := 04E16H;
    result[5] := 0754CH;
    result[6] := 0;

    i := NOT(-1); (* 0 *)
    j := 0;
    ch := next(x, i);
    WHILE ch # 0 DO
      T.Assert(result[j] = ch, "Problem: ");
      IF result[j] # ch THEN 
        Out.String("Expected: "); Out.Hex(ORD(result[i]), 0); 
        Out.String(" Got: "    ); Out.Hex(ORD(ch), 0); 
        Out.Ln 
      END;
      ch := next(x, i);
      INC(j)
    END;

    T.End; Out.String(" End"); Out.Ln;
  END Run;

BEGIN
  T.Register(Run)    
END BitFunc.
