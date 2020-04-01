MODULE Math;   (* Standard functions;  NW 12.10.2013 *)

  CONST
    E*          = 2.7182818285;
    PI*         = 3.1415926536;
    SQRT2*      = 1.4142135623;
    SQRT3*      = 1.7320508076;
    LOG10E*     = 0.4342944819;
    LN3OVER2*   = 0.5493061443;
    PIOVER2*    = 1.5707963268;
    PIOVER3*    = 1.0471975512;
    PIOVER4*    = 0.7853981634;
    PIOVER6*    = 0.5235987756;
    ONEOVERPI*  = 0.3183098862;
    TWOOVERPI*  = 0.6366197724;
    SQRTMAXPOW2 = 4096.0 * SQRT2;

    EPS = 0.00017263349; (* 1 / SQRTMAXPOW2 *)

    DMAXEXP =  128;
    DMINEXP = -127;

  PROCEDURE sqrt*(x: REAL): REAL;
  BEGIN 
    ASSERT(x >= 0.0);
    RETURN SQRT(x)
  END sqrt;

  PROCEDURE exp*(x: REAL): REAL;
    CONST
      c1 = 1.4426951;  (* 1/ln(2) *)
      p0 = 1.513864173E3;
      p1= 2.020170000E1;
      p2 = 2.309432127E-2;
      q0 = 4.368088670E3;
      q1 = 2.331782320E2;
    VAR n: INTEGER; p, y, yy: REAL;
  BEGIN 
    y := c1 * x;
    n := FLOOR(y + 0.5); y := y - FLT(n);
    yy := y * y;
    p := ((p2 * yy + p1) * yy + p0) * y;
    p := p / ((yy + q1) * yy + q0 - p) + 0.5;
    PACK(p, n + 1); RETURN p
  END exp;

  PROCEDURE ln*(x: REAL): REAL;
    CONST 
      c1 =  0.70710680;     (* 1/sqrt(2) *)
      c2 =  0.69314720;     (* ln(2) *)
      p0 = -9.01746917E1;
      p1 =  9.34639006E1;
      p2 = -1.83278704E1;
      q0 = -4.50873458E1;
      q1 =  6.76106560E1;
      q2 = -2.07334879E1;
    VAR 
      e: INTEGER; 
      xx, y: REAL;
  BEGIN ASSERT(x > 0.0); UNPK(x, e);
    IF x < c1 THEN x := x * 2.0; e := e - 1 END ;
    x := (x - 1.0) / (x + 1.0);
    xx := x;
    y := c2 * FLT(e) + x * ((p2 * xx + p1) * xx + p0) / (((xx + q2) * xx + q1) * xx + q0);
    RETURN y
  END ln;

  PROCEDURE sin*(x: REAL): REAL;
    CONST
      c1 =  6.3661977E-1; (*2/pi*)
      p0 =  7.8539816E-1;
      p1 = -8.0745512E-2;
      p2 =  2.4903946E-3;
      p3 = -3.6576204E-5;
      p4 =  3.1336162E-7;
      p5 = -1.7571493E-9;
      p6 =  6.8771004E-12;
      q0 =  9.9999999E-1;
      q1 = -3.0842514E-1;
      q2 =  1.5854344E-2;
      q3 = -3.2599189E-4;
      q4 =  3.5908591E-6;
      q5 = -2.4609457E-8;
      q6 =  1.1363813E-10;
    VAR 
      n: INTEGER; 
      y, yy, f: REAL;
  BEGIN 
    y := c1 * x;
    IF y >= 0.0 THEN 
      n := FLOOR(y + 0.5) 
    ELSE 
      n := FLOOR(y - 0.5) 
    END;
    y := (y - FLT(n)) * 2.0; yy := y * y;
    IF ODD(n) THEN 
      f := (((((q6 * yy + q5) * yy + q4) * yy + q3) * yy + q2) * yy + q1) * yy + q0
    ELSE 
      f := ((((((p6 * yy + p5) * yy + p4) * yy + p3) * yy + p2) * yy + p1) * yy + p0) * y
    END ;
    IF ODD(n DIV 2) THEN f := -f END ;
    RETURN f
  END sin;

  PROCEDURE cos*(x: REAL): REAL;
    CONST
      c1 =  6.3661977E-1; (* 2 / pi *)
      p0 =  7.8539816E-1;
      p1 = -8.0745512E-2;
      p2 =  2.4903946E-3;
      p3 = -3.6576204E-5;
      p4 =  3.1336162E-7;
      p5 = -1.7571493E-9;
      p6 = 6.8771004E-12;

      q0 =  9.9999999E-1;
      q1 = -3.0842514E-1;
      q2 =  1.5854344E-2;
      q3 = -3.2599189E-4;
      q4 =  3.5908591E-6;
      q5 = -2.4609457E-8;
      q6 =  1.1363813E-10;
    VAR 
      n: INTEGER; 
      y, yy, f: REAL;
  BEGIN 
    y := c1 * x;
    IF y >= 0.0 THEN n := FLOOR(y + 0.5) ELSE n := FLOOR(y - 0.5) END ;
    y := (y - FLT(n)) * 2.0; yy := y*y;
    IF ODD(n) THEN 
      f := ((((((p6 * yy + p5) * yy + p4) * yy + p3) * yy + p2) * yy + p1) * yy + p0) * y
    ELSE 
      f := (((((q6 * yy + q5) * yy + q4) * yy + q3) * yy + q2) * yy + q1) * yy + q0
    END ;
    IF ODD((n + 1) DIV 2) THEN f := -f END ;
    RETURN f
  END cos;

  PROCEDURE tan*(x: REAL): REAL;
    CONST 
      C1 =  1.57080078125;
      C2 = -4.45445510338E-6;

      p0 = -0.133383500E+0;
      p1 =  0.342488782E-2;
      p2 = -0.178617073E-4;

      q0 =  0.100000000E+1;
      q1 = -0.466716833E+0;
      q2 =  0.256638323E-1;
      q3 = -0.311815319E-3;
      q4 =  0.498194340E-6;
    VAR
      y, xn, f, g, xnum, xden, result: REAL;
      n: INTEGER;
  BEGIN
    y := ABS(x);
    ASSERT(y <= (SQRTMAXPOW2 * PIOVER2));
    n  := FLOOR(x * TWOOVERPI + 0.5);
    xn := FLT(n);
    f  := (x - xn * C1) - xn * C2;
    IF ABS(f) < EPS THEN
      xnum := f;
      xden := 1.0;
    ELSE
      g := f * f;
      xnum := ((p2 * g + p1) * g + p0) * g * f + f;
      xden := (((q4 * g + q3) * g + q2) * g + q1) * g + q0;
    END;
    IF ODD(n) THEN
      result := -xden / xnum;
    ELSE
      result := xnum / xden;
    END
    RETURN result
  END tan;

  PROCEDURE arcsincos(x: REAL; acos: BOOLEAN): REAL;
    CONST
      p0 = -0.273684945E2;
      p1 =  0.572082279E2;
      p2 = -0.396888630E2;
      p3 =  0.101525222E2;
      p4 = -0.696745734E0;

      q0 = -0.164210967E3;
      q1 =  0.417144302E3;
      q2 = -0.381863034E3;
      q3 =  0.150952708E3;
      q4 = -0.238238592E2;
      q5 =  0.100000000E1;
    VAR
      a, b, y, r, g, result: REAL;
      i: INTEGER;
      poly: BOOLEAN;
  BEGIN
    y := ABS(x);
    ASSERT(y <= 1.0);
    poly := FALSE;
    IF y > 0.5 THEN
      IF acos THEN 
        a := 0.0; b := PIOVER2
      ELSE 
        a := PIOVER4; b := PIOVER4 
      END;
      g := (1.0 - y) / 2.0;     (* g = (1-y)/2		*)
      y := -2.0 * SQRT(g);      (* y = -2 * g ** .5	*)
      poly := TRUE
    ELSE
      IF acos THEN 
        a := PIOVER4; b := PIOVER4 
      ELSE 
        a := 0.0; b := PIOVER2
      END;
      IF y < EPS THEN
        result := y
      ELSE
       	g := y * y;
        poly := TRUE
      END
    END;
    IF poly THEN
      r := (g * ((((p4 * g + p3) * g + p2) * g + p1) * g + p0)) / 
           (((((q5 * g + q4) * g + q3) * g + q2) * g + q1) * g + q0);
      result := y + y * r;
    END;
    IF acos THEN    (* arccos(x) *)
      IF x < 0.0 THEN
        result := result + b + b
      ELSE
        result := a - result + a
      END
    ELSE                (* arcsin(x) *)
      result := result + a + a;
      IF x < 0.0 THEN result := -result END
    END
    RETURN result
  END arcsincos;
  
  PROCEDURE arcsin*(x: REAL) : REAL;
  BEGIN
    RETURN arcsincos(x, FALSE)
  END arcsin;
  
  PROCEDURE arccos*(x: REAL) : REAL;
  BEGIN
    RETURN arcsincos(x, TRUE)
  END arccos;

  PROCEDURE arctan2*(x, y: REAL): REAL;
    CONST
      p0 = -0.136887689E2;
      p1 = -0.205058552E2;
      p2 = -0.849462404E1;
      p3 = -0.837582994E0;

      q0 =  0.410663067E2;
      q1 =  0.861573496E2;
      q2 =  0.595784361E2;
      q3 =  0.150240012E2;
      q4 =  0.100000000E1;

      TWOMINUSSQRT3	= 0.267949192;
    VAR
      expX, expY, n: INTEGER;
      result, g, f, a, tmp: REAL;
      negate: BOOLEAN;
  BEGIN  
    IF y = 0.0 THEN
    	ASSERT(x # 0.0);
      result := PIOVER2
    ELSE
      tmp := ABS(x); UNPK(tmp, expX);
      tmp := ABS(y); UNPK(tmp, expY);
      IF (expX - expY) >= (DMAXEXP - 3) THEN		(* then overflow on V/U	*)
        result := PIOVER2
      ELSE
        IF (expX - expY) <= (DMINEXP + 3) THEN	(* then underflow on V/U *)
          result := 0.0
        ELSE
          f := ABS(x / y);
          IF f > 1.0 THEN
            f := 1.0 / f;
            IF f > TWOMINUSSQRT3 THEN a := PIOVER3 ELSE a := PIOVER2 END;
            negate := TRUE
          ELSE
            IF f > TWOMINUSSQRT3 THEN a := PIOVER6 ELSE a := 0.0 END;
            negate := FALSE
          END;
          IF f > TWOMINUSSQRT3 THEN
            tmp := (SQRT3 - 1.0) * f - 0.5;
            tmp := tmp - 0.5;
            f   := (tmp + f) / (SQRT3 + f)
          END;
          IF ABS(f) < EPS THEN
            result := f
          ELSE
            g := f * f;
            result := (g * (((p3 * g + p2) * g + p1) * g + p0)) /
                      ((((q4 * g + q3) * g + q2) * g + q1) * g + q0);
            result := f + f * result
          END;
          IF negate THEN result := -result END;
          result := result + a
        END;
        IF y < 0.0 THEN result := PI - result END
      END
    END;
    IF x < 0.0 THEN result := -result END
    RETURN result
  END arctan2;

  PROCEDURE arctan*(x: REAL): REAL;
  BEGIN
    RETURN arctan2(x, 1.0)
  END arctan;
  
END Math.
