# Changes to the Oberon-07 definition

This document explains the changes made to the ESP32 Oberon-07 compiler in regard of the Niklaus Wirth language definition and implementation in Project Oberon. Note that using any of these changes will brake the portability of your code with the Project Oberon system or other Oberon-07 compilers.

## Identifiers

The underscore character is allowed inside an identifier. The first character must be a letter (lower or upper case).

```
ident = letter {letter | digit | "_" }.
```

Identifiers are limited to 64 characters in length, instead of 32.

## Standard procedures

The following pre-defined functions have been added. They are using optimized ESP32 instructions and are useful in an IOT context:

- Bit-wise `NOT(x)`, `AND(x,y)`, `BOR(x,y)`, `XOR(x,y)` functions for INTEGER and BYTE arguments.
- `MIN(x,y)` and `MAX(x,y)` functions for INTEGER, BYTE and REAL arguments.
- `SQRT(x)` for real argument. Uses an optimized assembly language function.

The following standard procedure/function have been added
in the SYSTEM module. They are using specific ESP32 instructions:

- `SYSTEM.WSR(x,y)` Procedure. Write INTEGER value y into (constant value) special register x (0 <= x <= 255).
- `SYSTEM.RSR(x)` Function. Read INTEGER value from (constant value) special register x (0 <= x <= 255).

The following standard SYSTEM procedures are not implemented. They are not relevant to the ESP32 context. A LED equivalent function will be available in a forecoming module:

```Oberon
LED LDPSR ADC SBC UML REG H COND
```

## CONST declaration expression

Expressions with REAL operations are permitted in a CONST declaration expression. The Project Oberon CONST declaration permits only INTEGER/BYTE/SET constant expressions. 

The following standard functions can also be used in such an expression if parameters x and y are constants:

- Bit-wise `NOT(x)`, `AND(x,y)`, `BOR(x,y)` and `XOR(x,y)` functions
- Shift functions `LSL(x,y)`, `ASR(x,y)` and `ROR(x,y)`
- `FLOOR(x)`, `FLT(x)`, `ODD(x)` functions
- `ABS(x)`, `ORD(x)` and `CHR(x)` were already useable in a CONST declaration

## REAL NaN value

A REAL NaN value will be generated if a division by zero is done. The value will be equal to `SYSTEM.VAL(REAL, 07FFFFFFFH)`. You can define a constant that would get this value:

```Modula-2
CONST NaN = 0.0 / 0.0;
```

TBC: System interrupts behavior and Trap mechanism on compiler check (**-c**) generation

## Interrupt procedure

You can declare a procedure to be called when an interrupt occurs. To do so, you have to put into brackets the interrupt level number associated to the procedure like this:

```Modula-2
PROCEDURE [12] P();
BEGIN
END P;
```

(Not working. Still, a work in progress)

## BYTE vs INTEGER

The ESP32 Compiler allow for BYTE value to be the return answer to an INTEGER value function:

```Modula-2
MODULE Example;

VAR b : BYTE;

PROCEDURE F() : INTEGER;
BEGIN
  RETURN b
END F;

END Example.
```

## CHAR vs ARRAY OF CHAR

The ESP32 Compiler allow char constants to be assignement compatible with strings. The example below shows 1) assignment of a CHAR constant to an ARRAY OF CHAR variable, parameter inside a procedure and when calling a procedure:

```Modula-2
MODULE Example;

  CONST c = "a";
  VAR 
    a : ARRAY 32 OF CHAR;

  PROCEDURE P(VAR aa: ARRAY OF CHAR; bb: ARRAY OF CHAR);
  VAR aaa: ARRAY 32 OF CHAR;
  BEGIN
    aa := c;
    aaa := 22X;
  END P;

BEGIN
  a := c;
  P(a, c);
END Example.

```

When assigning a CHAR constant to a variable or a parameter (ARRAY OF CHAR), it is then promoted to a constant null terminated ARRAY OF CHAR and then assigned to the variable or parameter. Note that when calling a procedure you cannot assign to a variable parameter.

## CASE statement

The CASE statement is accepting INTEGER, BYTE or CHAR as CASE expression and constant case labels. This was not implemented in the Project Oberon version of the compiler but has been retrieved from the Extended Oberon project and modified to produce ESP32 assembly language instructions. When such statements are used, it is also possible to have an ELSE clause. For example:

```Modula-2
CASE ch OF
  "a".."z" : i := 1
ELSE
  i := 2
END
```

Here is a documentation extract from [Extended Oberon](https://github.com/andreaspirklbauer/Oberon-extended/blob/master/Documentation/The-Revised-Oberon2-Programming-Language.pdf):

Case statements specify the selection and execution of a statement sequence according to the value of an expression. First the case expression is evaluated, then the statement sequence is executed whose case label list contains the obtained value.

```
CaseStatement = CASE expression OF case {"|" case} [ELSE StatementSequence] END. 
case = [CaseLabelList ":" StatementSequence].
CaseLabelList = LabelRange {"," LabelRange}.
LabelRange = label [".." label].
label = integer | string | qualident.
```

Numeric case statements

If the case expression is of type INTEGER or CHAR, all case labels must be integers or single- character strings, respectively.

The following rules and restrictions apply:

- Case labels of numeric case statements must have values between 0 and 255.
- Case variables of type case statements must be simple identifiers that cannot be followed by selectors, i.e. they cannot be elements of a structure (array elements or record fields).
- If the value of the case expression does not correspond to any case label in the source text, the statement sequence following the symbol ELSE is selected, if there is one, otherwise no action is taken (in the case of a type case statement) or the program is aborted (in the case of a numeric case statement).

The ELSE clause has been re-introduced even though it is not part of the Oberon-07 language definition. This was done mainly for backward compatibility reasons. In general, we recommend using the ELSE clause only in well-justified cases, for example if the index range far exceeds the label range. But even in that case, one should first try to find a representation using explicit case label ranges, as shown in the example below (which assumes an index range of 0..255).

## User's Assembly language 

The ESP32 Oberon compiler allows for direct entry of assembly language code inside the code generation stream. Here is an example:

```Modula-2
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

## Compiler debugging trace

### DBGON DBGOFF

The words DBGON and DBGOFF can be put anywhere in the application source code. This will allow to get a trace of the compiler code generator module (ORG) procedure calls during the compilation phase. This trace is to help resolve issues with the compiler.
