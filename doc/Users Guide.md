#  ESP32 Oberon Compiler User's Guide

## Compiler parameters

The ESP32 Oberon Compiler is a single executable that can be launched as follows:

```sh
$ Oberon [-c][-o folder][-p path][-s][-v] filename
```

Where the parameters are:

- **-c** : Add code to do the following additional checks at runtime:

  + Array index boundary limits
  + NIL pointers dereference
  + Division by zero
  + Pointer types validation
  + Array copy overflow
  + Illegal procedure call

- **-o folder** : Output folder for the generated assembly language code. If not present, the module source code folder is being used.
- **-p path** : Search path for imported modules, as a list of folder names separated with character “:”. An imported module is first seached in the folder of the module being compiled, then in sequence in the folders part of the path.
- **-s** : Override Symbol file. The symbol file will be generated in the same folder as the module source code.
- **-v** : Output compiler version number.
- **filename** : Oberon source filename to be compiled

The compiler will produce an ESP32 assembly language source code (extension `.S`) and a symbol file (extension `.smb`) if it does not exist or the **-s** option is present.

## Runtime support files

An ESP32 Oberon program requires runtime support. The compiler is supplied with many files that you can find in the lib folder:

- An application startup function that is called by the ESP32 bootstrap once the application has been loaded in memory. It is located in `lib/init/init.S`. This file contains many include instructions to add the other pieces of code present in the same folder. These files supply support for interupts management and floating-point divide and square-root functions.

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

This module implements the [Oakwood Guidelines](http://www.edm2.com/index.php/The_Oakwood_Guidelines_for_Oberon-2_Compiler_Developers) `Out` Module definition with some added/removed procedures. The procedure is using the UART0 serial port to transmit data sent by the users's application. By default, the connexion baud rate is set to 115K in the Open procedure called by the module initialization. This module, for now, uses active loops to synchronise with the *first in first out* (Fifo) output buffer. The Oakwood's `LongReal` procedure is not available. The following procedures have been added:

- `PROCEDURE SetBaudRate*(baudRate: INTEGER);` Change baud rate according to the value passed as a parameter. The following usual baud rate are supplied as constants:

  + `Baud9600`
  + `Baud19200`
  + `Baud38400`
  + `Baud76800`
  + `Baud115K`

- `PROCEDURE Flush;` Active loop waiting for the Fifo output buffer to be empty.

- `PROCEDURE RealFix*(x: REAL; n, k: INTEGER)` Write the real x in n field positions in fixed point notation with f fraction digits.

```Modula-2
MODULE Out;
  CONST  (* INTEGER constants *)
    Baud115K*,
    Baud76800*,
    Baud38400*,
    Baud19200*,
    Baud9600*;

  PROCEDURE Open*;
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

### Module In

This module implements the [Oakwood Guidelines](http://www.edm2.com/index.php/The_Oakwood_Guidelines_for_Oberon-2_Compiler_Developers) `In` Module definition with some added/removed procedures. The procedure is using the UART0 serial port to receive data for the users's application. By default, the connexion baud rate is set to 115K in the Open procedure called by the module initialization. This module, for now, uses active loops to synchronise with the *first in first out* (Fifo) input buffer. The Oakwood's `LongReal` and `LongInt` procedures are not available. The following procedures have been added:

- `PROCEDURE SetBaudRate*(baudRate: INTEGER);` Changes baud rate according to the value passed as a parameter. The following usual baud rate are supplied as constants in the Out module:

  + `Out.Baud9600`
  + `Out.Baud19200`
  + `Out.Baud38400`
  + `Out.Baud76800`
  + `Out.Baud115K`

- `PROCEDURE SetTimeout*(seconds: INTEGER);` Specifies the timeout duration while receiving characters. Timeout is set to 30 seconds by default. It is reset after each character received. If timeout occurs, the variable `In.Done` will be `FALSE`.

- `PROCEDURE SetEcho*(echo: BOOLEAN);` If `TRUE` (default value), received characters will be echoed to the stream through the `Out.Char()` procedure.

- `PROCEDURE Flush;` Empty the input Fifo buffer.

When Echo is enabled, the backspace key on the keyboard can be used to erase characters at the end of line. A sequence of backspace-space-backspace will then be sent to the terminal through the Out.Char procedure.

```Modula-2
MODULE In;
  VAR 
    Done*: BOOLEAN;                           (* status of last operation *)
  PROCEDURE SetBaudRate*(baudRate: INTEGER);
  PROCEDURE SetTimeout*(seconds: INTEGER);
  PROCEDURE SetEcho*(echo: BOOLEAN);
  PROCEDURE Open*;
  PROCEDURE Flush*;                           (* Clear Fifo *)
  PROCEDURE Char*(VAR ch: CHAR);
  PROCEDURE String*(VAR str: ARRAY OF CHAR);
  PROCEDURE Int*(VAR i: INTEGER);
  PROCEDURE Real*(VAR x: REAL);               (* Not Yet Available *)
  PROCEDURE Name*(VAR name: ARRAY OF CHAR);   (* Not Yet Available *)
  PROCEDURE Line*(VAR line: ARRAY OF CHAR);
END In.
```

### Module Strings

The module Strings provides a set of operations on strings, i.e., on string constants and character arrays, both of which contain the character 0X as a terminator.  All positions in strings start at 0. This module is implementing the [Oakwood Guidelines](http://www.edm2.com/index.php/The_Oakwood_Guidelines_for_Oberon-2_Compiler_Developers) Strings Module definition with some added procedures.

```Modula-2
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

### Module Math

This module was retrieved from the Project Oberon source code. I've added some REAL constants that would be useful for mathematical functions usage. The sqrt procedure is using an assembly language optimized function, as for REAL division generated by the compiler. Those two functions can be found in file `lib/src/math_support.S`.

```Modula-2
MODULE Math;
  CONST
    E*         = 2.7182818285;
    PI*        = 3.1415926536;
    SQRT2*     = 1.4142135623;
    SQRT3*     = 1.7320508076;
    LOG10E*    = 0.4342944819;
    LN3OVER2*  = 0.5493061443;
    PIOVER2*   = 1.5707963268;
    PIOVER3*   = 1.0471975512;
    PIOVER4*   = 0.7853981634;
    PIOVER6*   = 0.5235987756;
    ONEOVERPI* = 0.3183098862;
    TWOOVERPI* = 0.6366197724;

  PROCEDURE sqrt*(x: REAL): REAL;
  PROCEDURE exp*(x: REAL): REAL;
  PROCEDURE ln*(x: REAL): REAL;
  PROCEDURE sin*(x: REAL): REAL;
  PROCEDURE cos*(x: REAL): REAL;
END Math.
```
