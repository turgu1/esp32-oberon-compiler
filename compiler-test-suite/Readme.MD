# ESP32 Oberon Compiler (kind of) Test Suite

This folder contains 128 modules that are able to be compiled with the ESP32 Oberon Compiler.

At this point in time (2020.03.20), all modules are compiled without error message from the compiler. Some of them have been edited to put comments around code pattern that are not compatible with the compiler. Output statements has also been modified to use the Out module.

The vast majority of these modules are compiled, assembled and linked using the Makefile. The ones that can't be assembled and linked easily are on the side in the makefile (See Others and Others2 in Makefile).

I see it as a kind of chineese buffet with a variaty of tests. Not sure if this will give me enough confidence on the compiler's robustness, but, at least, it permits finding errors and resolve many compiler quirks.

I'm working on:

- Getting a mechanism to automate the “compile -> upload -> results retrieval -> compare” process, hoping to get a QEMU environment to test the compiler pretty soon. Well still no easy way to do that. As of 2020.04.01, I'm not pursuing anymore in this direction.

- Modifying each module in the test suite to give enough information to satisfy the needs of the compiler verification effort.

- Thinking on another approach. A more systematic approach would be better, but required a lot more thinking. Now, the folder named `../Test` contains modules that are compiled and linked together to be uploaded for trials on an ESP32.

Update (2020.04.01):

I'm still using this folder as a first cut of trials with the compiler to ensure compilation-assembly-linkage is at least producing executables.

Then I'm using the patterns folder to verify by close inspection the result of compilation.

As a third phase of tests, I'm using the Test program, uploaded to the ESP32, to get some runtime validation. This program is still under construction, adding modules to verify some language constructs.
