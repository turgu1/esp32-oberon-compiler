# Compiler changes

Here is the list of ongoing tasks to complete the effort of building the ESP32 Oberon Compiler.

- [x] Add INTEGER/BYTE/CHAR in CASE statements
- [x] User's assembly language
- [x] Add bit-wise AND/BOR/XOR/NOT for INTEGER/BYTE functions
- [x] Add MIN/MAX for INTEGER/BYTE/REAL Functions
- [x] Add SQRT function
- [x] Add WSR/RSR SYSTEM functions
- [ ] Revisit ORG.ChrToStr/ORG.StrToChr functions
- [ ] Implement Const Char as a string parameter
- [x] Revisit Types descriptor
- [x] Implement Pointers management structure
- [ ] Revisit Interrupt procedure definition
- [ ] Cleanup internal compiler debugging support
- [x] Revisit Logging module. No longer required.
- [ ] ORG.{load,store} procedures optimization
- [x] Revisit Procedure calls (function parameters) optimization
- [ ] Implement other Extended Oberon features
 
# Compiler Support

- [x] Trap mechanism to use Break instructions/Interrupts. Abandonned. Uses call4 instruction.
- [x] Kernel Module (New, Garbage Collector, Timer)
- [ ] Complete Kernel module (WatchDog, Flash disk access)
- [ ] OTA capability
- [ ] Flash memory-based code execution
- [ ] Source code debug marking with GDB
- [ ] PlatformIO integration
- [x] Makefile cleanup
- [ ] Standard Modules
  + [ ] Out -> Needs a standard Real procedure.
  + [x] Strings
  + [x] Math
  + [x] Strings
  + [ ] In
  + [ ] File
  + [ ] Texts (ASCII only version)
- [x] Library folder
- [ ] Interrupts management
- [ ] ESP32 hardware interfaces

# Potential future activities

- [ ] Optimize CASE statements when ranges are supplied as selectors
- [ ] Add SHORTINT (16 bits) type 
- [ ] Add DOUBLE type (and/or DoubleMath Module)
- [ ] Add other transcendantal functions to Math.Mod
- [ ] In and Out modules to be compliant with Texts module

 