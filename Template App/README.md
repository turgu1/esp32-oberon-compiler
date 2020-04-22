# Trials Folder

This folder contains a template to use to instanciate a new application. Simply copy the hole folder to another location on the computer.

To build everything and upload to the ESP32 development board, do the following commands:

```sh
$ idf.py set-target esp32
$ idf.py build
$ idf.py -p PORT [-b BAUD] flash
```

It is expected that the ESP32 be connected through some port on the computer. For exemple, under the Linux OS, it could be /dev/ttyUSB0. In the last command above, replace `PORT` with the name of the device.
