# ESP32 Oberon Compiler - Internals description

This document describes the internal structure of the ESP32 Oberon Compiler generated code.

## General information

- Assembly language instead of direct code generation
- Bare metal. For now, no code from ESP-IDF is being used
- ESP32 Windowing calls
  + Only call4 and call8 are used. Registers beyond A4 or A8 will be pushed on stack prior to the call4 or call8, if required

## Registers usage

- A0 : Procedure Return address
- A1 : Stack pointer
- A2 : Static Base Pointer (Module level variables)
- Registers used as a stack allocating registers for statements execution

  + for the called procedure, registers A2 and up receive parameters. They are saved on stack at procedure entry. A2 then receives the static base address. Returned value (functions) is placed in A3
  + caller must place parameters starting at A6 for call4 or A10 for a call8. Return value is in A7 for call4 and A11 for call8

## Sections

The generated code and data are put in different sections that will be placed at appropriate locations in memory by the linker (see file lib/ld/esp32.ld). Each section name contains the module name and symbol file checksum. This is to insure a minimal validation of proper module linkage. For example, assume that de module name is ModuleName and the symbol file checksum is 1234ABCD in hex, you will then get, as a suffix, `_ModuleName_1234ABCD`. Here is the list of sections with their name prefix:

- Module variables: `.bss`
- String constants: `.rodata_strs`
- Record Types descriptors: `.rodata_types`
- Module initialisation code: `.text_init`
- Procedure code: `.text`

The following sections define also an external entry point (a `.global` name) using the previously defined suffix as a prefix and with the following suffixes:

- Module variables: `_s_bss`
- Record Types descriptors: `_s_data_types`
- Procedure code: `_s_text`

For example, with the example above, the module variable section would be named `.bss_ModuleName_1234ABCD` and the globally defined name would be `_ModuleName_1234ABCD_s_bss`.

The other sections receive a locally defined name with the module name as a prefix and with the following suffixes:

- String constants: `_data_strs`
- Module initialisation code: `_init`

Interrupt procedures remains to be defined.

### Procedures

Procedure names are locally defined using the procedure name prefixed with `_`. For Example, a procedure named ProcName would then get the following local name: `_ProcName`. Exported procedures receives an external entry point as, for, example, `_ModuleName_1234ABCD_p_ProcName`.

### Module Initialisation and pointers table

The Module Initialisation code is not publicly available. It registers an entry to be put in the Module Initialization Table with a section with the following name prefix: `.init_table`. For example: `.init_table_ModuleName_1234ABCD`.

The pointers table section is using `.pointers_table` as prefix. For example: `.pointers_table_ModuleName_1234ABCD`.

Both Initialization and Pointer table sections are merged with other modules by the linker.

## Memory usage

Memory mapping is done by the linker, using a descriptor located in file `lib/ld/esp32.ld`. This file defines the location of each section as described above, but also identify the location of the stack and the heap. It is still a temporary solution as the complete code is currently put in RAM. The target is to have the code pushed in flash memory, using automated swapping mechanism to retrieve code into a RAM cache for execution.

(TBC)

## Interrupt mechanism

(TBC)

## Symbol File (`.smb`)

- Added Forms: ShortInt, LongInt, CProc, CRecord, CArray and CPointer: Many form identifiers have changed
- Added cdecl: If = 1, the whole module is a CDECL and no code has been generated, else = 0
- Added list of imported module ids (imodcnt {imodname})
- Versionkey: 2
  
```
Classes:
  Con = 1, Var = 2, Par = 3, Fld = 4; Typ = 5

Forms:
  Byte     =  1, Bool     =  2, Char    =   3, ShortInt =  4, Int      =  5,
  LongInt  =  6, Real     =  7, Set     =   8, Pointer  =  9, CPointer = 10,
  NilTyp   = 11, NoTyp   =  12, ProcTyp =  13, String   = 14, CProc    = 15,
  Array    = 16, CArray   = 17, Record  =  18, CRecord  = 19

Syntax:
  SymFile = null key name versionkey cdecl imodcnt {imodname} {object}.
  object = (
    CON name type (value | exno) |
    TYP name type [{fix} 0] |
    VAR name type expno).
  type = ref (
    PTR type |
    ARR type len |
    REC type {field} 0 |
    PRO type {param} 0).  (* PRO = Proc OR CProc *)
  field = FLD name type offset.
  param = (VAR | PAR) type.
```