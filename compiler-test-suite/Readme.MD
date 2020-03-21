# ESP32 Oberon Compiler Test Suite

This folder contains 128 modules that are able to be compiled with the ESP32 Oberon Compiler.

At this point in time (2020.03.20), all modules are compiled without error message from the compiler. Some of them have been edited to put comments around code pattern that are not compatible with the compiler.

I'm working on 

- Getting a mechanism to automate the “compile -> upload -> results retrieval -> compare” process, hoping to get a QEMU environment to test the compiler pretty soon.

- Modifying each module in the test suite to give enough information to satisfy the needs of the compiler verification effort