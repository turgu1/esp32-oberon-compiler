# Test folder

This folder contains a suite of basic tests to be used on a ESP32 module to verify basic compiler generation capabilities. 

To build everything and upload to the ESP32 development board, do the following commands:

```sh
$ make
$ make flash
```

It is expected that the ESP32 be connected through a USB port. The PORT definition in the Makefile
may need to be updated. Also, it is expected that the ESP32 Oberon compiler be in the parent folder.
