# Changes to the Oberon-07 definition.

This document explains the changes made to the ESP32 Oberon-07 compiler in regard of the Niklaus Wirth language definition and implementation in  Project Oberon.

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
