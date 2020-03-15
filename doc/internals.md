# ESP32 Oberon Compiler - Internals description

## General information

- Assembly language instead of direct code generation
- Bear metal
- Windowing calls 
  + Only call4 and call8 are used. Registers beyond A4 or A8 will be pushed on stack prior to the call4 or call8, if required
- SYSCALL instruction for TRAP and NEW operators

## Registers usage

- A0 : Procedure Return address 
- A1 : Stack pointer
- A2 : Static Base Pointer (Module level variables)
- Registers used as a stack of statements exécution

  + for the called procedure, registers A2 to An receive parameters. They are saved on stack at procedure entry. A2 then receives the static base address. Returned value (functions) is placed in A3
  + caller must place parameters starting at A6 for call4 or A10 for a call8. Return value is in A7 for call4 and A11 for call8

## Memory usage

## Name mangling

## Interrupt mechanism


