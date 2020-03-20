MODULE TestOOP;
  IMPORT Out;

  CONST PI = 3.13;

  PROCEDURE oopType0;
    TYPE
      Shape = POINTER TO ShapeDesc;
      Rectangle = POINTER TO RectangleDesc;
      Circle = POINTER TO CircleDesc;
      ShapeDesc = RECORD
                    name : CHAR;
                    area : PROCEDURE (s : Shape) : REAL;
                  END;
      RectangleDesc = RECORD (ShapeDesc) l, w : REAL END;
      CircleDesc = RECORD (ShapeDesc) r : REAL END;  
    VAR
      shape : Shape;
    
    PROCEDURE RectArea(s : Shape) : REAL;
      VAR area : REAL;
    BEGIN
      CASE s OF Rectangle:
        area := s.l * s.w;
      END;
      RETURN area
    END RectArea;

    PROCEDURE CircleArea(s : Shape) : REAL;
      RETURN s(Circle).r * s(Circle).r * PI
    END CircleArea;

    PROCEDURE newRect() : Rectangle;
      VAR rect : Rectangle;
    BEGIN
      NEW(rect); rect.name := "R";
      rect.l := 10.0; rect.w := 2.2;
      rect.area := RectArea;
      RETURN rect
    END newRect;

    PROCEDURE newCircle() : Circle;
      VAR circ : Circle;
    BEGIN
      NEW(circ); circ.name := "C";
      circ.r := 8.4; circ.area := CircleArea;
      RETURN circ
    END newCircle;
  BEGIN
    shape := newRect();
    Out.Char(shape.name);
    Out.Char(" ");
    Out.Real(shape.area(shape), 10);
    Out.Ln;
    shape := newCircle();
    Out.Char(shape.name);
    Out.Char(" ");
    Out.Real(shape.area(shape))
  END oopType0;  

  PROCEDURE oopType1;
    TYPE
      Shape1 = POINTER TO ShapeDesc1;
      Rectangle1 = POINTER TO RectangleDesc1;
      Circle1 = POINTER TO CircleDesc1;
      Message = RECORD END;
      Handler = PROCEDURE (s: Shape1; VAR msg: Message);
      AreaMsg = RECORD (Message) area : REAL END ;
      ShapeDesc1 = RECORD
                    name : CHAR;
                    handle : Handler;
                  END;
      RectangleDesc1 = RECORD (ShapeDesc1) l, w : REAL END;
      CircleDesc1 = RECORD (ShapeDesc1) r : REAL END;
    VAR
      shape : Shape1;
      area : AreaMsg;
      
    PROCEDURE RectHandler(s : Shape1; VAR msg: Message);
      VAR r : Rectangle1;
    BEGIN
      r := s(Rectangle1);
      CASE msg OF AreaMsg:
        msg.area := r.l * r.w;
      END
    END RectHandler;
    
    PROCEDURE CircleHandler(s : Shape1; VAR msg: Message);
      VAR c : Circle1;
    BEGIN
      c := s(Circle1);
      IF msg IS AreaMsg THEN msg(AreaMsg).area := c.r * c.r * PI END
    END CircleHandler;
    
    PROCEDURE newRect1() : Rectangle1;
      VAR rect : Rectangle1;
    BEGIN
      NEW(rect); rect.name := "R";
      rect.l := 10.0; rect.w := 2.2;
      rect.handle := RectHandler;
      RETURN rect
    END newRect1;

    PROCEDURE newCircle1() : Circle1;
      VAR circ : Circle1;
    BEGIN
      NEW(circ); circ.name := "C";
      circ.r := 8.4; circ.handle := CircleHandler;
      RETURN circ
    END newCircle1;
    
  BEGIN
    shape := newRect1();
    Out.Char(shape.name);
    Out.Char(" ");
    shape.handle(shape, area);
    Out.Real(area.area);
    Out.Ln;
    shape := newCircle1();
    Out.Char(shape.name);
    Out.Char(" ");
    shape.handle(shape, area);
    Out.Real(area.area, 10)
  END oopType1;

  PROCEDURE oopType2;
    TYPE
      Shape2 = POINTER TO ShapeDesc2;
      Rectangle2 = POINTER TO RectangleDesc2;
      Circle2 = POINTER TO CircleDesc2;
      Method = POINTER TO MethodDesc;
      MethodDesc = RECORD
                     area: PROCEDURE (s : Shape2) : REAL;
                   END;
      ShapeDesc2 = RECORD
                    name : CHAR;
                    do : Method;
                   END;
      RectangleDesc2 = RECORD (ShapeDesc2) l, w : REAL END;
      CircleDesc2 = RECORD (ShapeDesc2) r : REAL END;
    VAR
      shape : Shape2;
      
    PROCEDURE RectArea2(s : Shape2) : REAL;
      VAR r : Rectangle2;
    BEGIN
      r := s(Rectangle2);
      RETURN r.l * r.w
    END RectArea2;
    
    PROCEDURE CircleArea2(s : Shape2) : REAL;
      VAR c : Circle2;
    BEGIN
      c := s(Circle2);
      RETURN c.r * c.r * PI
    END CircleArea2;
    
    PROCEDURE newRect2() : Rectangle2;
      VAR rect : Rectangle2;
    BEGIN
      NEW(rect); rect.name := "R";
      rect.l := 10.0; rect.w := 2.2;
      (* This should be initialized in the module body
         so the below 2 statements would be just
         rect.do := RectMethod, where RectMethod is the
         initialized global *)
      NEW(rect.do);
      rect.do.area := RectArea2;
      RETURN rect
    END newRect2;

    PROCEDURE newCircle2() : Circle2;
      VAR circ : Circle2;
    BEGIN
      NEW(circ); circ.name := "C";
      circ.r := 8.4;
      (* This should be initialized in the module body
         so the below 2 statements would be just
         circ.do := CircleMethod, where CircleMethod is the
         initialized global *)
      NEW(circ.do);
      circ.do.area := CircleArea2;
      RETURN circ
    END newCircle2;
    
  BEGIN
    shape := newRect2();
    Out.Char(shape.name);
    Out.Char(" ");
    Out.Real(shape.do.area(shape));
    Out.Ln;
    shape := newCircle2();
    Out.Char(shape.name);
    Out.Char(" ");
    Out.Real(shape.do.area(shape), 10);
  END oopType2;
  
BEGIN
  oopType0;
  Out.Ln;
  oopType1;
  Out.Ln;
  oopType2
END TestOOP.