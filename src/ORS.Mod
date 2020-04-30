MODULE ORS; (* NW 19.9.93 / 15.3.2017  Scanner in Oberon-07*)
  IMPORT SYSTEM, SYS, Out, Texts;

(* Oberon Scanner does lexical analysis. Input is Oberon-Text, output is
  sequence of symbols, i.e identifiers, numbers, strings, and special symbols.
  Recognises all Oberon keywords and skips comments. The keywords are
  recorded in a table.
  Get(sym) delivers next symbol from input text with Reader R.
  Mark(msg) records error and delivers error message with Writer W.
  If Get delivers ident, then the identifier (a string) is in variable id, if int or char
  in ival, if real in rval, and if string in str (and slen) *)
  
  (* GT 14.02.2020 
     Added GetCh() to maintain current line and column number. This to get addditional
     information on the location of an error. Used when displaying error messages. Works fine
     with the lexical analyser, but is off almost all the time with the parser. 
     
     ToDo: Implement a new procedure that will produce an error message using line/column
     previously saved by the parser. Sort of...
   *)

  CONST 
    IdLen*        =  64;
    NKW           =  37;  (*nof keywords*)
    maxExp        =  38; 
    stringBufSize = 256;
  
    LF    = 0AX;
    CR    = 0DX;
    TAB   = 07X;
    SPACE = 20X;

    (*lexical symbols*)
    null    =  0; times*     =  1; rdiv*      =  2; div*    =  3; mod*    =  4;
    and*    =  5; plus*      =  6; minus*     =  7; or*     =  8; eql*    =  9;
    neq*    = 10; lss*       = 11; leq*       = 12; gtr*    = 13; geq*    = 14;
    in*     = 15; is*        = 16; arrow*     = 17; period* = 18; long*   = 19;
    char*   = 20; int*       = 21; real*      = 22; false*  = 23; true*   = 24;
    nil*    = 25; string*    = 26; not*       = 27; lparen* = 28; lbrak*  = 29;
    lbrace* = 30; ident*     = 31; if*        = 32;               while*  = 34;
    repeat* = 35; case*      = 36; for*       = 37; asm*    = 38;
    comma*  = 40; colon*     = 41; becomes*   = 42; upto*   = 43; rparen* = 44;
    rbrak*  = 45; rbrace*    = 46; then*      = 47; of*     = 48; do*     = 49;
    to*     = 50; by*        = 51; semicolon* = 52; end*    = 53; bar*    = 54;
    else*   = 55; elsif*     = 56; until*     = 57; return* = 58;
    array*  = 60; record*    = 61; pointer*   = 62; const*  = 63; type*   = 64;
    var*    = 65; procedure* = 66; begin*     = 67; import* = 68; module* = 69; 
    eot     = 70;

  TYPE 
    Ident* = ARRAY IdLen OF CHAR;
    LineConsumer = PROCEDURE (lineNbr: INTEGER; line: ARRAY OF CHAR);

  VAR 
    ival*, ival1*, slen*: INTEGER;  (*results of Get*)
    rval*: REAL;
    id*:   Ident;  (*for identifiers*)
    str*:  ARRAY stringBufSize OF CHAR;
    errcnt*: INTEGER;

    line: ARRAY 1024 OF CHAR;
    eof:  BOOLEAN; (* End Of File *) 
    ch:   CHAR;    (*last character read*)
    lineNbr, columnNbr: INTEGER;

    R: Texts.Reader;
    W: Texts.Writer;
    k: INTEGER;
    KWX: ARRAY 10 OF INTEGER;
    keyTab: ARRAY NKW OF
        RECORD sym: INTEGER; id: ARRAY 12 OF CHAR END ;

    debugging*: BOOLEAN;

    (* Allow another module to connect a consumer of lines to ORS without 
       requesting an import statement *)
    lineConsumer: LineConsumer;
    
  PROCEDURE SetLineConsumer*(consumer: LineConsumer);
  BEGIN
    lineConsumer := consumer;
  END SetLineConsumer;

  PROCEDURE CopyId*(VAR ident: Ident);
  BEGIN ident := id
  END CopyId;

  PROCEDURE GetLine;
    VAR 
      i: INTEGER;
      ch: CHAR;
  BEGIN
    line[0] := 0X;
    IF ~eof THEN
      IF R.eot THEN 
        eof := TRUE
      ELSE
        i := 0;
        REPEAT
          Texts.Read(R, ch);
          IF ch = LF THEN INC(lineNbr) END
        UNTIL (ch >= SPACE) OR (ch = TAB) OR R.eot;
        IF ~R.eot THEN
          line[i] := ch; INC(i);
          WHILE ((ch >= SPACE) OR (ch = TAB)) & (i < 1023) & ~R.eot DO
            Texts.Read(R, ch);
            line[i] := ch; INC(i) (* First character after the end of line will be kept *)
          END
        END ;
        line[i] := 0X;
        INC(lineNbr);
        columnNbr := 0;
        IF lineConsumer # NIL THEN lineConsumer(lineNbr, line) END ;
      END
    END
  END GetLine;

  PROCEDURE GetCh;
  BEGIN
    WHILE (line[columnNbr] = 0X) & ~eof DO GetLine END ;
    IF eof THEN
      ch := 0FFX
    ELSE
      ch := line[columnNbr];
      INC(columnNbr)
    END
  END GetCh;

  PROCEDURE Mark2*(msg1, msg2: ARRAY OF CHAR);
  BEGIN
    IF (errcnt < 25) THEN
      Out.Ln; 
      Out.String("[line ");
      Out.Int(lineNbr, 1);
      Out.Char(":");
      Out.Int(columnNbr, 1);
      Out.String("] ");
      Out.String(msg1);
      Out.String(msg2)
    END ;
    INC(errcnt)
  END Mark2;

  PROCEDURE Mark*(msg: ARRAY OF CHAR);
  BEGIN
    Mark2(msg, "")
  END Mark;

  PROCEDURE Identifier(VAR sym: INTEGER);
    VAR i, k: INTEGER;
  BEGIN i := 0;
    REPEAT
      IF i < IdLen - 1 THEN id[i] := ch; INC(i) END ;
      GetCh()
    UNTIL (ch < "0") OR 
          (ch > "9") & (ch < "A") OR 
          (ch > "Z") & (ch < "a") & (ch # "_") OR 
          (ch > "z");
    id[i] := 0X; 
    IF i < 10 THEN k := KWX[i - 1];  (* search for keyword *)
      WHILE (id # keyTab[k].id) & (k < KWX[i]) DO INC(k) END ;
      IF k < KWX[i] THEN sym := keyTab[k].sym ELSE sym := ident END
    ELSE sym := ident
    END
  END Identifier;

  PROCEDURE String;
    VAR i: INTEGER;
  BEGIN i := 0; GetCh();
    WHILE ~eof & (ch # 22X) DO (* 22X = " *)
      IF (ch >= SPACE) OR (ch = TAB) THEN
        IF i < stringBufSize - 1 THEN str[i] := ch; INC(i) ELSE Mark("string too long") END ;
      END ;
      GetCh()
    END ;
    str[i] := 0X; INC(i); GetCh(); slen := i
  END String;

  PROCEDURE HexString;
    VAR i, m, n: INTEGER;
  BEGIN i := 0; GetCh();
    WHILE ~eof & (ch # "$") DO
      WHILE ~eof & (ch <= SPACE) DO GetCh() END ;  (* skip *)
      IF    ("0" <= ch) & (ch <= "9") THEN m := ORD(ch) - 30H
      ELSIF ("A" <= ch) & (ch <= "F") THEN m := ORD(ch) - 37H
      ELSE m := 0; Mark("hexdig expected")
      END ;
      GetCh();
      IF    ("0" <= ch) & (ch <= "9") THEN n := ORD(ch) - 30H
      ELSIF ("A" <= ch) & (ch <= "F") THEN n := ORD(ch) - 37H
      ELSE n := 0; Mark("hexdig expected")
      END ;
      IF i < stringBufSize THEN str[i] := CHR(m * 10H + n); INC(i) 
      ELSE Mark("string too long") 
      END ;
      GetCh()
    END ;
    GetCh(); slen := i  (* no 0X appended! *)
  END HexString;

  PROCEDURE Ten(e: INTEGER): REAL;
    VAR x, t: REAL;
  BEGIN x := 1.0; t := 10.0;
    WHILE e > 0 DO
      IF ODD(e) THEN x := t * x END ;
      t := t * t; e := e DIV 2
    END ;
    RETURN x
  END Ten;
(*
  PROCEDURE Number(VAR sym: INTEGER);
    CONST max = 2147483647 (* 2^31 - 1 *);
    VAR 
      i, k, e, n, s, h: INTEGER; x: REAL;
      d: ARRAY 21 OF INTEGER;
      negE: BOOLEAN;
  BEGIN ival := 0; i := 0; n := 0; k := 0;
    REPEAT
      IF n < 20 THEN d[n] := ORD(ch) - 30H; INC(n) ELSE Mark("too many digits"); n := 0 END ;
      GetCh()
    UNTIL (ch < "0") OR (ch > "9") & (ch < "A") OR (ch > "F");
    IF (ch = "H") OR (ch = "R") OR (ch = "X") THEN  (* hex *)
      REPEAT h := d[i];
        IF h >= 10 THEN h := h - 7 END ;
        k := k * 10H + h; INC(i) (* no overflow check *)
      UNTIL i = n;
      IF ch = "X" THEN sym := char;
        IF k < 100H THEN ival := k ELSE Mark("illegal value"); ival := 0 END
      ELSIF ch = "R" THEN sym := real; rval := SYSTEM.VAL(REAL, k)
      ELSE sym := int; ival := k
      END ;
      GetCh()
    ELSIF ch = "." THEN
      GetCh();
      IF ch = "." THEN (* double dot *) ch := 7FX;  (* decimal integer *)
        REPEAT
          IF d[i] < 10 THEN
            IF k <= (max - d[i]) DIV 10 THEN k := k * 10 + d[i] ELSE Mark("too large"); k := 0 END
          ELSE Mark("bad integer")
          END ;
          INC(i)
        UNTIL i = n;
        sym := int; ival := k
      ELSE (* real number *) x := 0.0; e := 0;
        REPEAT  (* integer part *) x := x * 10.0 + FLT(d[i]); INC(i) UNTIL i = n;
        WHILE (ch >= "0") & (ch <= "9") DO  (* fraction *)
          x := x * 10.0 + FLT(ORD(ch) - 30H); DEC(e); GetCh()
        END ;
        IF (ch = "E") OR (ch = "D") THEN  (* scale factor *)
          GetCh(); s := 0; 
          IF ch = "-" THEN negE := TRUE; GetCh()
          ELSE negE := FALSE;
            IF ch = "+" THEN GetCh() END
          END ;
          IF (ch >= "0") & (ch <= "9") THEN
            REPEAT s := s * 10 + ORD(ch) - 30H; GetCh()
            UNTIL (ch < "0") OR (ch >"9");
            IF negE THEN e := e - s ELSE e := e + s END
          ELSE Mark("digit expected")
          END
        END ;
        IF e < 0 THEN
          IF e >= -maxExp THEN x := x / Ten(-e) ELSE x := 0.0 END
        ELSIF e > 0 THEN
          IF e <= maxExp THEN x := Ten(e) * x ELSE x := 0.0; Mark("too large") END
        END ;
        sym := real; rval := x
      END
    ELSE  (* decimal integer *)
      REPEAT
        IF d[i] < 10 THEN
          IF k <= (max - d[i]) DIV 10 THEN k := k * 10 + d[i] ELSE Mark("too large"); k := 0 END
        ELSE Mark("bad integer")
        END ;
        INC(i)
      UNTIL i = n;
      sym := int; ival := k
    END
  END Number;
*)
  PROCEDURE Number(VAR sym: INTEGER);
    VAR 
      i, k, e, n, s, h: INTEGER; x: REAL;
      d: ARRAY 22 OF CHAR;
      negE: BOOLEAN;
  BEGIN ival := 0; i := 0; n := 0; k := 0;
    REPEAT
      IF n < 21 THEN d[n] := ch; INC(n) ELSE Mark("too many digits"); n := 0 END ;
      GetCh()
    UNTIL (ch < "0") OR (ch > "9") & (ch < "A") OR (ch > "F");
    d[n] := 0X;
    IF (ch = "H") OR (ch = "R") OR (ch = "X") THEN  (* hex *)
      IF ~SYS.StrToInt64(16, d, ival, ival1) THEN Mark("bad number") END ;
      IF ch = "X" THEN sym := char;
        IF ival >= 100H THEN Mark("illegal value"); ival := 0 END ; ival1 := 0
      ELSIF ch = "R" THEN sym := real; rval := SYSTEM.VAL(REAL, ival); ival := 0; ival1 := 0
      ELSIF ival1 # 0 THEN sym := long ELSE sym := int
      END ;
      GetCh()
    ELSIF ch = "." THEN
      GetCh();
      IF ch = "." THEN (* double dot *) ch := 7FX;  (* decimal integer *)
        IF ~SYS.StrToInt64(10, d, ival, ival1) THEN Mark("bad number")
        ELSIF (ival1 = 0) & (ival < 0) THEN Mark("number too large"); ival := 0 END ;
        IF ival1 # 0 THEN sym := long ELSE sym := int END
      ELSE (* real number *) x := 0.0; e := 0;
        REPEAT  (* integer part *) x := x * 10.0 + FLT(ORD(d[i]) - 30H); INC(i) UNTIL i = n;
        WHILE (ch >= "0") & (ch <= "9") DO  (* fraction *)
          x := x * 10.0 + FLT(ORD(ch) - 30H); DEC(e); GetCh()
        END ;
        IF (ch = "E") OR (ch = "D") THEN  (* scale factor *)
          GetCh(); s := 0; 
          IF ch = "-" THEN negE := TRUE; GetCh()
          ELSE negE := FALSE;
            IF ch = "+" THEN GetCh() END
          END ;
          IF (ch >= "0") & (ch <= "9") THEN
            REPEAT s := s * 10 + ORD(ch) - 30H; GetCh()
            UNTIL (ch < "0") OR (ch >"9");
            IF negE THEN e := e - s ELSE e := e + s END
          ELSE Mark("digit expected")
          END
        END ;
        IF e < 0 THEN
          IF e >= -maxExp THEN x := x / Ten(-e) ELSE x := 0.0 END
        ELSIF e > 0 THEN
          IF e <= maxExp THEN x := Ten(e) * x ELSE x := 0.0; Mark("too large") END
        END ;
        sym := real; rval := x
      END
    ELSE  (* decimal integer *)
      IF ~SYS.StrToInt64(10, d, ival, ival1) THEN Mark("bad number")
      ELSIF (ival1 = 0) & (ival < 0) THEN Mark("number too large"); ival := 0 END ;
      IF ival1 # 0 THEN sym := long ELSE sym := int END
    END
  END Number;

  PROCEDURE comment;
  BEGIN 
    GetCh();
    REPEAT
      WHILE ~eof & (ch # "*") DO
        IF ch = "(" THEN 
          GetCh();
          IF ch = "*" THEN comment END
        ELSIF ch = "$" THEN 
          GetCh();
          IF (ch = "D") THEN 
            GetCh();
            IF ch = "+" THEN 
              debugging := TRUE; GetCh();
              Out.Ln; Out.String("Debugging is ON");
            ELSIF ch = "-" THEN
              IF debugging THEN Out.Ln; Out.String("Debugging is OFF"); Out.Ln END ;
              debugging := FALSE; GetCh();
            END
          END
        ELSE GetCh()
        END
      END ;
      WHILE ch = "*" DO GetCh() END
    UNTIL (ch = ")") OR eof;
    IF ~eof THEN GetCh() ELSE Mark("unterminated comment") END
  END comment;

  PROCEDURE GetAssemblerLine*(VAR theLine: ARRAY OF CHAR): BOOLEAN;
  VAR
    i, j : INTEGER;
    theEnd : BOOLEAN;
  BEGIN 
    IF eof THEN
      theEnd := TRUE
    ELSE
      GetLine();
      i := 0;
      WHILE (line[i] # 0X) & ((line[i] = SPACE) OR (line[i] = TAB)) DO INC(i) END ;
      IF (line[i] = "E") & (line[i + 1] = "N") & (line[i + 2] = "D") THEN
        columnNbr := i + 3;
        theEnd := TRUE;
      ELSE
        i := 0; j := 0;
        WHILE (line[i] # 0X) & (j < (LEN(theLine) - 1)) DO
          IF (line[i] >= SPACE) OR (line[i] = TAB) THEN
            theLine[j] := line[i]; INC(j);
          END ;
          INC(i) 
        END ;
        IF j < (LEN(theLine) - 1) THEN theLine[j] := 0X END ;
        theEnd := FALSE;
      END ;
    END
    RETURN ~theEnd
  END GetAssemblerLine;

  PROCEDURE Get*(VAR sym: INTEGER);
  BEGIN
    REPEAT
      WHILE ~eof & (ch <= SPACE) DO GetCh() END ;
      IF ch < "A" THEN
        IF ch < "0" THEN
          IF ch = 22X THEN String; sym := string
          ELSIF ch = "#" THEN GetCh(); sym := neq
          ELSIF ch = "$" THEN HexString; sym := string
          ELSIF ch = "&" THEN GetCh(); sym := and
          ELSIF ch = "(" THEN GetCh(); 
            IF ch = "*" THEN sym := null; comment ELSE sym := lparen END
          ELSIF ch = ")" THEN GetCh(); sym := rparen
          ELSIF ch = "*" THEN GetCh(); sym := times
          ELSIF ch = "+" THEN GetCh(); sym := plus
          ELSIF ch = "," THEN GetCh(); sym := comma
          ELSIF ch = "-" THEN GetCh(); sym := minus
          ELSIF ch = "." THEN GetCh();
            IF ch = "." THEN GetCh(); sym := upto ELSE sym := period END
          ELSIF ch = "/" THEN GetCh(); sym := rdiv
          ELSE GetCh(); (* ! % ' *) sym := null
          END
        ELSIF ch < ":" THEN Number(sym)
        ELSIF ch = ":" THEN GetCh();
          IF ch = "=" THEN GetCh(); sym := becomes ELSE sym := colon END 
        ELSIF ch = ";" THEN GetCh(); sym := semicolon
        ELSIF ch = "<" THEN  GetCh();
          IF ch = "=" THEN GetCh(); sym := leq ELSE sym := lss END
        ELSIF ch = "=" THEN GetCh(); sym := eql
        ELSIF ch = ">" THEN GetCh();
          IF ch = "=" THEN GetCh(); sym := geq ELSE sym := gtr END
        ELSE (* ? @ *) GetCh(); sym := null
        END
      ELSIF ch < "[" THEN Identifier(sym)
      ELSIF ch < "a" THEN
        IF ch = "[" THEN sym := lbrak
        ELSIF ch = "]" THEN  sym := rbrak
        ELSIF ch = "^" THEN sym := arrow
        ELSE (* _ ` *) sym := null
        END ;
        GetCh()
      ELSIF ch < "{" THEN Identifier(sym) 
      ELSE
        IF ch = "{" THEN sym := lbrace
        ELSIF ch = "}" THEN sym := rbrace
        ELSIF ch = "|" THEN sym := bar
        ELSIF ch = "~" THEN  sym := not
        ELSIF ch = 7FX THEN  sym := upto 
        ELSIF ch = 0FFX THEN sym := eot
        ELSE sym := null
        END ;
        GetCh()
      END
    UNTIL sym # null
  END Get;

  PROCEDURE Init*(T: Texts.Text; pos: INTEGER);
  BEGIN 
    Texts.OpenReader(R, T, pos); 
    errcnt    := 0; 
    lineNbr   := 0;
    columnNbr := 0;
    eof       := FALSE;
    GetLine();
    GetCh();
  END Init;

  PROCEDURE EnterKW(sym: INTEGER; name: ARRAY OF CHAR);
  BEGIN keyTab[k].id := name; keyTab[k].sym := sym; INC(k)
  END EnterKW;

BEGIN 
  Texts.OpenWriter(W); 
  
  k := 0; KWX[0] := 0; KWX[1] := 0;

  EnterKW(if, "IF");
  EnterKW(do, "DO");
  EnterKW(of, "OF");
  EnterKW(or, "OR");
  EnterKW(to, "TO");
  EnterKW(in, "IN");
  EnterKW(is, "IS");
  EnterKW(by, "BY");
  KWX[2] := k;
  EnterKW(end, "END");
  EnterKW(nil, "NIL");
  EnterKW(var, "VAR");
  EnterKW(div, "DIV");
  EnterKW(mod, "MOD");
  EnterKW(for, "FOR");
  EnterKW(asm, "ASM"); (* ASM *)
  KWX[3] := k;
  EnterKW(else, "ELSE");
  EnterKW(then, "THEN");
  EnterKW(true, "TRUE");
  EnterKW(type, "TYPE");
  EnterKW(case, "CASE");
  KWX[4] := k;
  EnterKW(elsif, "ELSIF");
  EnterKW(false, "FALSE");
  EnterKW(array, "ARRAY");
  EnterKW(begin, "BEGIN");
  EnterKW(const, "CONST");
  EnterKW(until, "UNTIL");
  EnterKW(while, "WHILE");
  KWX[5] := k;
  EnterKW(record, "RECORD");
  EnterKW(repeat, "REPEAT");
  EnterKW(return, "RETURN");
  EnterKW(import, "IMPORT");
  EnterKW(module, "MODULE");
  KWX[6] := k;
  EnterKW(pointer, "POINTER");
  KWX[7] := k; KWX[8] := k;
  EnterKW(procedure, "PROCEDURE");
  KWX[9] := k;

  debugging := FALSE;
  lineConsumer := NIL;
END ORS.
