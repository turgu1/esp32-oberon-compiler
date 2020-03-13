# ESP32 Oberon Compiler - Internals description

## General information

- Assembly language instead of direct code generation
- Bear metal
- Windowing calls 
- SYSCALL instruction for TRAP and NEW opérators

## Registers usage

- a0 : Procedure Return address 
- a1 : Stack pointer
- a2 : Static Base Pointer (Module level variables)
- Registers used as a stack of statements exécution

## Memory usage

## Name mangling

## Interrupt mechanism


