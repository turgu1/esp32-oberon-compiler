# Compiler changes

Here is the list of ongoing tasks to complete the effort of building the ESP32 Oberon Compiler.

- [x] Add INTEGER/BYTE/CHAR in CASE statements
- [x] User's assembly language
- [x] Add bit-wise AND/BOR/XOR/NOT for INTEGER/BYTE functions
- [x] Add MIN/MAX for INTEGER/BYTE/REAL Functions
- [x] Add SQRT function
- [x] Add WSR/RSR SYSTEM functions
- [ ] Revisit ORG.ChrToStr/ORG.StrToChr functions
- [x] Implement Const Char as a string parameter
- [x] Revisit Types descriptor
- [x] Implement Pointers management structure
- [x] Cleanup internal compiler debugging support
- [x] Revisit Logging module. No longer required.
- [x] ORG.{load,store} procedures optimization
- [x] Revisit Procedure calls (function parameters) optimization

# ESP-IDF Migration

- [x] Add CDECL Procedure calls support
- [x] Qio Interface Module (bridge module with ESP-IDF)
- [ ] Init code to be called from ESP-IDF
- [ ] Flash memory-based code execution -> ESP-IDF ld integration
- [ ] Kernel modification to use Qio
- [ ] Some Qio interaces
  + [ ] WatchDog
  + [ ] Memory allocation
  + [ ] WiFi and TCP/IP
  + [ ] GPIO / PWM / A2D
  + [ ] Flash memory
  + [ ] Deep Sleep
  + *and many more...*
- [ ] Oberon Lib as an ESP-IDF component
- [ ] CMake integration
- [ ] FreeRTOS behavior validation
- [ ] Interrupt procedure definition

# Compiler Support

- [x] Trap mechanism to use Break instructions/Interrupts. Abandonned. Uses call4 instruction.
- [x] Kernel Module (New, Garbage Collector, Timer)
- [ ] Complete Kernel module (WatchDog, Flash disk access)
- [ ] OTA capability
- [ ] PlatformIO integration
- [x] Makefile cleanup
- [ ] Standard Modules
  + [ ] Out -> Needs a better standard RealFix procedure.
  + [x] Strings
  + [x] Math
  + [x] Strings
  + [x] In
  + [ ] File
  + [ ] Texts (ASCII only version)
- [x] Library folder
- [ ] Interrupts management
- [ ] ESP32 hardware interfaces
  + [ ] ESP-IDF generic interfacing
  + *and many more...*

# Potential future activities

- [ ] Implement other Extended Oberon features
- [ ] Source code debug marking with GDB
- [ ] Optimize CASE statements when ranges are supplied as selectors
- [x] Add SHORTINT (16 bits) type
- [ ] Add DOUBLE type (and/or DoubleMath Module)
- [x] Add other transcendantal functions to Math.Mod
- [ ] In and Out modules to be compliant with Texts module
