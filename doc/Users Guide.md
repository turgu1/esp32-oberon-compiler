## Compiler parameters

The ESP32 Oberon Compiler accepts the following parameters:

- **-c**  Add code to do the following additional checks at runtime:

  + Array index boundary limits
  + NIL pointers dereference
  + Division by zero
  + Pointer types validation
  + Array copy overflow
  + Illegal procedure call

- **-o folder**  Output folder for the generated assembly language code. 
- **-p path**  Search path for imported modules, as a list of folder names separated with character ":".
- **-s**  Override Symbol file.
- **-v**  Output compiler version number.

## Runtime support files

An ESP32 Oberon program requires runtime support. The compiler is supplied with many files that you can find in the lib folder:

- An application startup function that is called by the ESP32 bootstrap once the application has been loaded in memory. It is located in `lib/init/init.S`. This file contains many include instructions to add the other pieces of code present in the same folder. These files supply support for interupts management and floating point divide and square-toot functions.

- A Linker Script file that supply memory mapping information to the linker. It is located in `lib/ld/esp32.ld`.

- Several Oberon modules that are located in the `lib/modules` folder. They are described in the following sections


## Modules Initialization Sequence

The application startup code is a piece of assembly language program that is called by the ESP32 bootstrap ROM. Once started, it is calling initialization code of each Oberon module in sequence. The order of these calls is important to understand as some module may rely on other modules to be initialized prior to their own initialization code can be initiated.

At link time, modules must be presented to the linker in the reverse order of initialization, with the application startup object code as the first file. 

For example, imagine an application that uses 3 Oberon modules: Main.Mod, Module1.Mod and Module2.Mod. Main.Mod represents your principal portion of the program. As such, it is needed to be the last Oberon module to get its module initialization code to be launched. If the module named Module1.Mod rely on Module2.Mod to be initialized before itself, Module2.Mod will then need to be put after Module1.Mod in the list. Here is the order of object files to be supplied to the linker:

```
init.o Main.o Module1.o Module2.o
```

## Standard Module

The ESP32 Oberon Compiler is supplied with a variaty of modules for use by applications. This section presents each of these modules and the specific aspects of their interface in relation with the targetted architecture.

### Module Kernel

Support for:

- Heap allocation through the New function.
- Garbage collection
- General timing functions
- Error trap support

This module is currently being developped.

### Module Out

This module implements the [Oakwood Guidelines](http://www.edm2.com/index.php/The_Oakwood_Guidelines_for_Oberon-2_Compiler_Developers) Out Module definition with some added/removed procedures. The procedure is using the UART0 serial port to transmit data sent by the users's application. By default, the connexion baud rate is set 115K in the Open procedure called by the module initialization. This module, for now, uses active loops to synchronise with the first in first out output buffer. The Oakwood's `LongReal` procedure is not available. The following procedures have been added:

- `PROCEDURE SetBaudRate*(baudRate: INTEGER);` Change baud rate according to the value passed as a parameter. The following usual baud rate are supplied as constants:

  + Baud9600 
  + Baud19200
  + Baud38400
  + Baud76800
  + Baud115K baud

- `PROCEDURE Flush;` Active loop waiting for the fifo output buffer to be empty.

- `PROCEDURE RealFix*(x: REAL; n, k: INTEGER)` Write the real x in n field positions in fixed point notation with f fraction digits.

```Oberon
MODULE Out;
  CONST  (* INTEGER constants *)
    Baud115K*,
    Baud76800*,
    Baud38400*,
    Baud19200*,
    Baud9600*;

  PROCEDURE Open*;
  PROCEDURE FifoCount(): INTEGER;
  PROCEDURE Flush*;
  PROCEDURE Char*(ch: CHAR);
  PROCEDURE String*(s: ARRAY OF CHAR);
  PROCEDURE Int*(x, n: INTEGER);
  PROCEDURE Hex*(x, n: INTEGER);
  PROCEDURE Real*(x: REAL; n: INTEGER);
  PROCEDURE RealFix*(x: REAL; n,k: INTEGER);
  PROCEDURE Ln*;
  PROCEDURE SetBaudRate*(baudRate: INTEGER);
END Out.
```

### Module Strings

The module Strings provides a set of operations on strings, i.e., on string constants and character arrays, both of which contain the character 0X as a terminator.  All positions in strings start at 0. This module is implementing the [Oakwood Guidelines](http://www.edm2.com/index.php/The_Oakwood_Guidelines_for_Oberon-2_Compiler_Developers) Strings Module definition with some added procedures.

```Oberon
MODULE Strings;
  PROCEDURE Length* (s: ARRAY OF CHAR): INTEGER;
  PROCEDURE Write* (src: ARRAY OF CHAR; VAR dest: ARRAY OF CHAR;
                    at: INTEGER): INTEGER;
  PROCEDURE Append* (extra: ARRAY OF CHAR; VAR dest: ARRAY OF CHAR);
  PROCEDURE WriteChar* (c: CHAR; VAR dest: ARRAY OF CHAR; at: INTEGER): INTEGER;
  PROCEDURE AppendChar* (c: CHAR; VAR dest: ARRAY OF CHAR);
  PROCEDURE WriteInt* (x, n: INTEGER; VAR dest: ARRAY OF CHAR;
                      at: INTEGER): INTEGER;
  PROCEDURE AppendInt* (x, n: INTEGER; VAR dest: ARRAY OF CHAR);
  PROCEDURE Copy* (src: ARRAY OF CHAR; VAR dest: ARRAY OF CHAR);
  PROCEDURE Insert* (source: ARRAY OF CHAR; pos: INTEGER;
                    VAR dest: ARRAY OF CHAR);
  PROCEDURE Delete* (VAR s: ARRAY OF CHAR; pos, n: INTEGER);
  PROCEDURE Replace* (source: ARRAY OF CHAR; pos: INTEGER;
                      VAR dest: ARRAY OF CHAR);
  PROCEDURE Extract* (source: ARRAY OF CHAR; pos, n: INTEGER;
  PROCEDURE Pos* (pattern, s: ARRAY OF CHAR; pos: INTEGER): INTEGER;
  PROCEDURE Cap* (VAR s: ARRAY OF CHAR);
  PROCEDURE Match* (string, pattern: ARRAY OF CHAR): BOOLEAN;
END Strings.
```