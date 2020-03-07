# esp32-oberon-compiler

This is an ongoing effort to build an ESP32 Oberon Compiler, using the Oberon-07 Compiler from [Project Oberon](http://www.projectoberon.com) by Niklaus Wirth and Jürg Gutknecht and some code from project [Oberon Extended](https://github.com/andreaspirklbauer/Oberon-extended) by Mr. Andreas Pirklbauer. Test cases are being designed in part using the [OberonC](https://github.com/lboasso) effort by Luca Boasso.

The code is being ported to [OBNC](https://miasap.se/obnc/) and will generate ELF object code through ESP32 assembly language generation. I'm currently targetting a 'bear metal' version, supplying everything necessary for building applications, relying only on the assembler linker and loader provided with [ESP-IDF](https://docs.espressif.com/projects/esp-idf/en/latest/). GDB and OpenOCD are also used to allow remote debugging through JTAG. This is the intent. A large portion is in a workable condition at this point in time.

The folder `test-bearmetal` demonstrates the feasability of independant coding from ESP-IDF. It is a working piece of assembly code that I made that can be compiled and pushed to an ESP32. It gets a led blink every half a second and pushes some message on the serial port. This was the starting point to start modeling an executable architecture based on the ESP32 for Oberon.

In a Nutshell, the steps I'm taking to get a working compiler are the following:

1. Retrieve the ORB, ORG, ORS, ORP and Texts Source Modules from the Project Oberon source code
2. Add Logger.Mod and Oberon.Mod Modules
3. Cleanup all modules to be obnc compliant
4. Cleanup Texts.Mod to be ASCII based
5. Modify ORP.Compile* to be calleable from the Oberon module
6. Build an understanding of the code production compiler stage (from the documentation)
7. Build an understanding of the target architecture (ESP32 and ESP-IDF)
8. Generate machine code by hand for each pattern found in the Chapter 12 of [https://inf.ethz.ch/personal/wirth/ProjectOberon/PO.Applications.pdf], taking notes on the target formalisms required for code generation.
9. Refine target architecture
10. Cleanup ORG in preparation of machine code translation
11. Build the translation
12. Creates main support code (program statup, Module Out, garbage collector, serial port output)
13. Test the results. Build a test suite and make it run
14. Add language functionalities (mainly SYSTEM procedures) required in support of the ESP32 architecture
15. Create other Oakridge compliant Modules 
16. Build a PlatformIO Custom Development Platform
17. Develop modules for some of the ESP32 subsystems
18. Enjoy

I'm now doing a round robin between steps 8, 9, 10, 11 and 12

## Modifications

Some of the modifications to the Project Oberon compiler source code (up to step 5):

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

The Oberon.Log has been replaced with a new Logger Module. Very basic for now.

### Texts.Mod

Many procedures have been deleted, not usefull for the compiler execution.
All code related to fonts and graphics geometry deleted.

Some potential bugs corrected:

- Calls to T.notify without verifying if it is NIL.
- Read Procedure modified to properly manage eot.

### Other changes:

- The .smb file output has been modified to get exported variable offsets instead of an export sequence number. The code generator is relying on the ELF linker to resolve the location of data sections. The imported variables are accessed through their offset.

- The ESP32 doesn't supply a floating point division instruction. A function called by the generated code is added.

- The Module Static Base address (SB) is loaded in register a2 

- Call to functions in parameters preparation, like `P(F(3.0))` is not very efficient in term of stack and register usage. It is better to use temporary variables and prepare parameters before the main call (will be revisited once the compiler is working properly). For example:

```
     i := F(3.0); P(i)
```

- There is no Condition Codes in the ESP32, but a variety of branch instructions based on the content of register parameters. This, combined with the assembly language output of the compiler, requires sensible changes to the fixup algorithm and conditional instructions generation used in ORG. Using labels in the assembly language, fixups are no longer required.

- Trap is using a routine that you can find in the init.S startup code that save registers and reason for trap before restarting the program.

## Installation

### OBNC

The OBNC Oberon-07 version 0.16.1 is used to build this compiler. The author is using it on both Linux and MacOs platforms without any major issue. It must be built using the following commands and option (after having changed current directory to obnc):

```
$ ./build --c-real-type=float
$ ./install
```

(Both INTEGER and REAL must be set to 32bits.)

The OBNC Oberon-07 compiler is required with the extension libraries to parse command line arguments. It is available at the following location:

    [https://miasap.se/obnc/]
    
### ESP32 Oberon Compiler

There is a simple Makefile that will automate the creation of the Oberon executable. To build, simply use the command `make` to compile it. The result will be the executable file named `Oberon`.

Guy
