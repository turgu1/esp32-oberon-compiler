# ESP32 Oberon-07 Compiler

By lack of time, the development of the compiler is now stopped forever. If somebody wants to continue the development, please do.

------

This is an ongoing effort to build an ESP32 Oberon Compiler, using the Oberon-07 Compiler from [Project Oberon](http://www.projectoberon.com) by Niklaus Wirth and Jürg Gutknecht and some code from project [Oberon Extended](https://github.com/andreaspirklbauer/Oberon-extended) by Mr. Andreas Pirklbauer. Test cases are being designed in part using the [OberonC](https://github.com/lboasso) effort by Luca Boasso.

The code is being ported to [OBNC](https://miasap.se/obnc/) and produces ELF object code through ESP32 assembly language generation. 

Up to 2020.03.31, I was targeting a 'bare metal' version, supplying everything necessary for building applications, relying only on the assembler linker and loader provided with [ESP-IDF](https://docs.espressif.com/projects/esp-idf/en/latest/). 

I'm now migrating the compiler to supply the capability of interfacing with the ESP-IDF. Two main reasons for this are:

- Some aspects of the ESP32 architecture are being kept unaccessible to third parties developpers. This is the case for the WiFi subsystem that is a mandatory use, at least, for me...; and
- The richness of hardware interfaces available with the ESP32 would require a lot of recoding in the Oberon language. It is then beneficial to get access to components already available with the ESP-IDF framework.

My ToDo document has been modified to reflect this new orientation.

This is the intent. A large portion of the compiler is in a workable condition at this point in time.

The folder `test-baremetal` demonstrates the feasibility of independent coding from ESP-IDF. It is a working piece of assembly code that I made that can be compiled and pushed to an ESP32. It gets a led blink every half a second and pushes some message on the serial port. This was the starting point to start modeling an executable architecture based on the ESP32 for Oberon.

## Installation

### OBNC

The OBNC Oberon-07 version 0.16.1 is used to build this compiler. It is available from [this](https://miasap.se/obnc/) location. The author is using it on both Linux and MacOs platforms without any major issue (Except for the SYSTEM.VAL() that needed to be replaced and some support functions. See the `SYS.*` files in the `src` folder). It must be built using the following commands and option (after having extracted the source code to ~/Downloads/obnc-0.16.1). For example, on Linux Ubuntu:

```sh
$ cd ~/Downloads/obnc-0.16.1
$ sudo apt install libgc-dev libsdl1.2-dev
$ ./build --c-real-type=float
$ sudo ./install
```

On MaxOs, using homebrew:

```sh
$ cd ~/Downloads/obnc-0.16.1
$ brew install libgc sdl
$ ./build --c-real-type=float
$ sudo ./install
```

(Both INTEGER and REAL must be set to 32bits. The compiler is verifying this aspect on startup. The option "--c-real-type=float" will do it)

The OBNC extension libraries is also required to parse command line arguments. It is also available from [this](https://miasap.se/obnc/) location. Further instructions are included in the README file in the root directory of the package. The extension library can be built and installed using the following commands on Linux Ubuntu and MacOS (after having extracted the source code to ~/Downloads/obnc-libext-0.7.0):

```sh
$ cd ~/Downloads/obnc-libext-0.7.0
$ ./build
$ sudo ./install
```

### ESP-IDF

The ESP-IDF development framework must be present and setup in the user environment. Please follow the [receipe](https://docs.espressif.com/projects/esp-idf/en/latest/get-started/index.html#setting-up-development-environment), up to and including step 4.

### ESP32 Oberon Compiler and run-time

For now, there is a simple Makefile in the main folder that will automate the creation of the Oberon compiler and additional executables. To build, simply use the command `make` to compile them, then `make install` to install them. The result will be the executable files named `OberonESP32`, `OIOrderESP32` and `ORToolESP32` in the installation folder. By default, the files will be installed in folder /usr/local/bin. Information about the use of these application can be found in the [User's guide](./doc/Users Guide.md).

The runtime environment is located in the `lib/` sub-folder. It must also be built after the compiler. Simply change current folder to `lib/` and then use the command `make`. Again, to install, `make install`. By default, the library named liboberonesp32.a will be installed in folder /usr/local/lib/OberonESP32. Definition files (with extension `.smb`) for all oberon modules that are part of the library will also be copied to that folder.

You can then create your own program. The folder `Template`, `Test` and `Trial` contain programs with appropriate makefiles to automate the built and the transmission of the application to a connected ESP32 board through USB. The `Makefile` and `CMakeFiles.txt` present in these folders would give some lignts on how to organise your own program. (Some documentation remains to be supplied on the way to use the ESP-IDF framework)

As stated, this is still under eavy development and is regularly being updated (like several times a day). There is still some bugs presents and many modules to control the ESP32 hardware interfaces remains to be added.

Testing the compiler is done through the use of:

- modules in folder `patterns` that are compiled and checked by hand to verify that the generated code is correct, 
- the application located in folder `Test` that is compiled, linked and uploaded to a working ESP32 development board for execution, and
- a suite of compiled modules located in folder `compiler-test-suite/` that are used to verify the overall capability of the compiler.

Guy
