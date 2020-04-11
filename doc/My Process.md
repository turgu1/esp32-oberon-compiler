# ESP32 Oberon Compiler development process

In a Nutshell, the steps I'm taking to get a working compiler are the following:

1. Retrieve the ORB, ORG, ORS, ORP and Texts Source Modules from the Project Oberon source code
2. Add Logger.Mod and Oberon.Mod Modules
3. Cleanup all modules to be obnc compliant
4. Cleanup Texts.Mod to be ASCII based
5. Modify ORP.Compile* to be calleable from the Oberon module
6. Build an understanding of the code production compiler stage (from the documentation)
7. Build an understanding of the target architecture (ESP32 and ESP-IDF)
8. Generate machine code by hand for each pattern found in the Chapter 12 of [PO.Applications](https://inf.ethz.ch/personal/wirth/ProjectOberon/PO.Applications.pdf), taking notes on the target formalisms required for code generation.
9. Refine target architecture
10. Cleanup ORG in preparation of machine code translation
11. Build the translation
12. Creates main support code (program statup, Module Out, garbage collector, serial port output)
13. Test the results. Build a test suite and make it run
14. Add language functionalities required in support of the ESP32 architecture and ESP-IDF Framework intergration
15. Create other Oakridge compliant Modules
16. Build a PlatformIO Custom Development Platform
17. Develop modules for some ESP32 subsystems
18. Enjoy

I'm now at step 13 and 14

The file named OBG.Mod is the main module generator of assembly language instructions. It has been almost completly rewritten, considering the assembly language approach taken instead of direct code generation. Using the assembler gives the following facilities:

- Automated management of literal creation for indirect addressing of far reached memory locations. The ESP32 instruction set doesn't supply full 32 bits addressing of memory. The assembler automates this aspect.

- Automated management of code fixing of forward branch instructions. This is accomplished through the use of local labels in the code.

- Allow for user's coded assembly language instruction. An ASM statement has been added to the language in support for inline assembly language inside procedures. See the User's Guide for more details.

## Modifications

Some modifications to the Project Oberon compiler source code (up to step 5):

Strict Oberon-07 definition (obnc):

- LONGINT translated to INTEGER
- LONGREAL translated to REAL
- Null statements (semicolon before END) inside RECORD removed

For OBNC Integration:

- Files.Read requires BYTE, not CHAR. Replace `Files.Read(f, ch)` with `Files.Read(f, byte)`
- Files.Write requires BYTE, not CHAR. Replace `Files.Write(f, ch)` with `Files.Write(f, ORD(ch))`
- Replace Files.WriteByte with Files.Write
- CR is now a line-feed character. Usual end of line code under Unix/Linux.

### Oberon.Mod

This module is expected to parse command line parameters and call the ORP.Compile procedure. New parameters to be added, beyond the -s option:

- Folder location path for standard modules and other project related folders

The Oberon.Log output has been replaced with the Out module procedures.

### Texts.Mod

Many procedures have been deleted, not usefull for the compiler execution.
All code related to fonts and graphics geometry deleted.

Some potential bugs corrected:

- Calls to T.notify without verifying if it is NIL.
- Read Procedure modified to better manage eot.

### Other changes

- The .smb file output has been modified to get exported variable offsets instead of an export sequence number. The code generator is relying on the ELF linker to resolve the location of data sections. The imported variables are accessed through their offset.

- The ESP32 doesn't supply a floating-point division instruction. A function called by the generated code is added.

- The Module Static Base address (SB) is loaded in register a2.

- Call to functions in parameters preparation, like `P(F(3.0))` is not very efficient in term of stack and register usage. It is better to use temporary variables and prepare parameters before the main call (will be revisited once the compiler is working properly). For example:

```Modula-2
     i := F(3.0); P(i)
```

- There is no Condition Codes in the ESP32, but a variety of branch instructions based on the content of register parameters. This, combined with the assembly language output of the compiler, requires sensible changes to the fix up algorithm and conditional instruction generation used in ORG. Using labels in the assembly language, fix ups are no longer required.

- TRAP is using a routine that is located in the Kernel module that (will) save registers (TBD) and reason for trap before restarting the program. It is also used to get the NEW function execution. See the Kernel.OberonSyscallHandler procedure. At first, I've tried to get it runs through the SYSCALL ESP32 instuction. Still not working so no interrupt function for now.
