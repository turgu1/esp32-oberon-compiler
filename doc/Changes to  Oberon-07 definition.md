# Changes to the Oberon-07 definition

This document explains the changes made to the ESP32 Oberon-07 compiler in regard of the Niklaus Wirth language definition and implementation in Project Oberon.

## Standard procedures

The following standard procedure have been added
in the SYSTEM module:

(To be defined)

The following standard SYSTEM procedures are not implemented:

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

## Procedure as a parameter

Passing a procedure as a parameter requires that the procedure be defined exported (with a '*' after the procedure name in the declaration) if it is going to be supplied to another module. This will insure that the Static Base register will be properly initialized at the procedure entry point.

## Pragmas

### DBGON DBGOFF

The words DBGON and DBGOFF can be put anywhere in the application source code. This will allow to get a trace of the compiler code generator module (ORG) procedure calls during the compilation phase. This trace is an help to resolve issues with the compiler.
