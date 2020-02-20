# esp32-oberon-compiler

This is an ongoing effort to build an ESP32 Oberon Compiler, using the Oberon-07 Compiler from <http://www.projectoberon.com> by Niklaus Wirth and Jürg Gutknecht.

The code is being ported to obnc and will generate ELF compatible object code to be used with (or without) the ESP-IDF framework. I'm currently targetting a 'bearmetal' version, supplying everything necessary for building applications, relying only on the assembler and linker provided with ESP-IDF. At least, this is the intent. Nothing is in a workable condition at this point in time.

The folder `test-bearmetal` demonstrate the feasability. It is a working piece of assembly code thatI made that can be compiled and pushed to an ESP32. It will get a led blink every half a second.

In a Nutshell, the steps to get a working compiler are the following:

1. Retrieve the ORB, ORG, ORS, ORP and Texts Source Modules
2. Add Logger.Mod and Oberon.Mod Modules
3. Cleanup all modules to be obnc compliant
4. Cleanup Texts.Mod to be ASCII based
5. Modify ORP.Compile* to be calleable from the Oberon module
6. Use the compiler source code as a test case for checking if the new compiler is able to compile...
7. Build an understanding of the code production compiler stage (from the documentation)
8. Build an understanding of the target architecture (ESP32 and ESP-IDF)
9. Integrate an ELF compliant generator -> First version will produce assembly language instead. Many advantages here, specially in managing the complexity of loading registers with large (32 bits) values. The assembler is producing the ELF format...
10. Cleanup ORG in preparation of machine code translation
11. Build the translation
12. Test the results
13. Build a PlatformIO Custom Development Platform
13. Develop standard modules for ESP32
14. Enjoy

I'm now at step 8

## Modifications

Some of the modifications to the Project Oberon compiler source code (up to step 5):

Strict Oberon-07 definition (obnc):

- LONGINT translated to INTEGER
- LONGREAL translated to REAL
- Null statements (semicolon before END) inside RECORD removed

For OBNC Integration:

- Files.Read requires BYTE, not CHAR. Replace Files.Read(f, ch) with
    Files.Read(f, byte)
- Files.Write requires BYTE, not CHAR. Replace Files.Write(f, ch) with
    Files.Write(f, ORD(ch))
- Replace Files.WriteByte with Files.Write
- CR is now a line-feed character. Usual end of line code under Unix/Linux.

### Oberon.Mod

This module is expected to parse command line parameters and call the ORP.Compile procedure.

The Oberon.Log has been replaced with a new Logger Module. Very basic for now.

### Texts.Mod

Many procedures have been deleted, not usefull for the compiler execution.
All code related to fonts and graphics geometry deleted.

Some potential bugs corrected:

- Calls to T.notify without verifying if it is NIL.
- Read Procedure modified to properly manage eot.

## Installation

There is a simple Makefile that will automate the creation of the Oberon executable. To build, simply use the command `make` to compile it. The result will be the executable file named `Oberon`.

The OBNC Oberon-07 compiler is required with the extension libraries to parse command line arguments. It is available at the following location:

    <https://miasap.se/obnc/>

Guy
