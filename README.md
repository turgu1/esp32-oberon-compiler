# esp32-oberon-compiler

This is an ongoing effort to build an ESP32 Oberon Compiler, using the Oberon-07 Compiler from http://www.projectoberon.com by Niklaus Wirth and Jürg Gutknecht. 

The code is being ported to obnc and will generate ELF compatible object code to be used with the ESP-IDF framework.

At least, this is the intent. Nothing is in a workable condition at this point in time.

Some of the modifications:

Strict Oberon-07 definition:

- LONGINT translated to INTEGER
- LONGREAL translated to REAL
- Null statements (semicolon before END) removed

For OBNC Integration:

- Files.Read requires BYTE, not CHAR. Replace Files.Read(f, ch) with
    Files.Read(f, byte)
- Files.Write requires BYTE, not CHAR. Replace Files.Write(f, ch) with
    Files.Write(f, ORD(ch))
- CR is now a line-feed character. Usual end of line code under Unix/Linux.

## Oberon.Mod

This module is expected to parse command line parameters and call the ORP.Compile procedure.

The Oberon.Log has been replaced with a new Logger Module. Very basic for now.

## Texts.Mod

Many procedures have been deleted, not usefull for the compiler execution.
All code related to fonts and graphics geometry deleted. 

Some potential bugs corrected:

- Calls to T.notify without verifying if it is NIL.
- Read Procedure modified to properly manage eot.

Guy
