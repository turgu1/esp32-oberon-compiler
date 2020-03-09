# Changes to the Oberon-07 definition

This document explains the changes made to the ESP32 Oberon-07 compiler in regard of the Niklaus Wirth language definition and implementation in Project Oberon.

## Standard procedures

The following standard procedure have been added
in the SYSTEM module. They are using optimized ESP32 instructions and are useful in an IOT context:

- Bit-wise `NOT(x)`, `AND(x,y)`, `BOR(x,y)`, `XOR(x,y)` functions for INTEGER and BYTE arguments.
- `MIN(x,y)` and `MAX(x,y)` functions for INTEGER, BYTE and REAL arguments.
- `SQRT(x)` for real argument. Uses an optimized assembly language function.

The following standard SYSTEM procedures are not implemented. They are not relevant to the ESP32 context. A LED equivalent function will be available in a forecoming module:

```Oberon
LED LDPSR ADC SBC UML REG H COND
```

## Interrupt procedure

You can declare a procedure to be called when an interrupt occurs. To do so, you have to put into brackets the interrupt level number associated to the procedure like this:

```Oberon
PROCEDURE [12] P();
BEGIN
END P;
```

## CASE statement

The CASE statement is accepting INTEGER, BYTE or CHAR as CASE expression and constant case labels. This was not implemented in the Project Oberon version of the compiler but has been retrieved from the Extended Oberon project. When such statements are used, it is also possible to have an ELSE clause. For example:

```Oberon
CASE ch OF
  "a".."z" : i := 1
ELSE
  i := 2
END
```

## Procedure as a parameter

Passing a procedure as a parameter requires that the procedure be defined exported (with a '*' after the procedure name in the declaration) if it is going to be supplied to another module. This will ensure that the Static Base register will be properly initialized at the procedure entry point.

## User's Assembly language 

The ESP32 Oberon compiler allows for direct entry of assembly language code inside the code generation stream. Here is an exemple:

```Oberon
MODULE Example;
BEGIN
  i := 3;
  ASM
    # Hello!
    movi a4, 23      # This is a comment
    movi a5, 44
    add  a4, a4, a5
  END
END Example;
```

This introduce a new ASM keyword. Everyting up to a line that start with the keyword END will be added to the generated assembly language stream. No interpretation is done by the compiler. 

## Pragmas

### DBGON DBGOFF

The words DBGON and DBGOFF can be put anywhere in the application source code. This will allow to get a trace of the compiler code generator module (ORG) procedure calls during the compilation phase. This trace is to help resolve issues with the compiler.
