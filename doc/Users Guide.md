## Modules Initialization Sequence

The startup code, once started, is calling initialization code of each Oberon module. The order of calls is important to understand as some module may rely on other modules to be initialized prior to their own initialization code can be initiated.

At link time, modules must be presented to the linker in the reverse order of initialization, with the init.o object code as the first file. The init.o object code file contains the program entry point called by the ESP32 ROM loader.

For example, imagine an application that uses 3 Oberon modules: Main.Mod, Module1.Mod and Module2.Mod. Main.Mod represents your principal portion of the program. As such, it is needed to be the last Oberon module to get it's module initialization code to be launched. If the module named Module1.Mod rely on Module2.Mod to be initialized before itself, Module2.Mod will then need to be put after Module1.Mod in the list. Here is the order of object files to be supplied to the linker:

```
init.o Main.o Module1.o Module2.o
```

# Standard Module

The ESP32 Oberon Compiler is supplied with a variaty of modules for use pas user's applications. This section present each of these modules and the specific aspects of their interface in relation with the targetted architecture.

## Module Out

This module is implementing the Oakridge's Out Module definition. The procedure is using the UART0 serial port to transmit data sent by the users's application. By default, the connexion baud rate is 115K. This module, for now, doesn't use interrupts. Active loops are used to synchronise with the first in first out output buffer. The following procedures have been added:

- `PROCEDURE SetBaudRate*(baudRate: INTEGER);` Change baud rate according to the value passed as a parameter. The following usual baud rate are supplied as constants:

  + Baud9600 
  + Baud19200
  + Baud38400
  + Baud76800
  + Baud115K baud

- `PROCEDURE Flush;` Active loop waiting for the fifo output buffer to be empty.

