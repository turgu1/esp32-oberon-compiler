 # ESP32 Oberon Compiler (kind of) Test Suite

This folder contains 128 modules that are able to be compiled with the ESP32 Oberon Compiler.

At this point in time (2020.03.20), all modules are compiled without error message from the compiler. Some of them have been edited to put comments around code pattern that are not compatible with the compiler. Output has also modified to use the Out module.

I see it as a kind of chineese buffet we a variaty of tests. Not sure if this will give me enough confidence on the compiler's robustness.

I'm working on 

- Getting a mechanism to automate the “compile -> upload -> results retrieval -> compare” process, hoping to get a QEMU environment to test the compiler pretty soon. Well still no easy way to do that...

- Modifying each module in the test suite to give enough information to satisfy the needs of the compiler verification effort.

- Thinking on another approach. A more systematic approach would be better, but required a lot more thinking.