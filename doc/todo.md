# Compiler changes

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
- [ ] Revisit Logging module
- [ ] ORG.{load,store} procedures optimization
- [x] Revisit Procedure calls (function parameters) optimization
 
# Compiler Support

- [x] Trap mechanism to use Break instructions/Interrupts. Abandonned. Uses call4 instruction.
- [x] Kernel Module (New, Garbage Collector, Timer)
- [ ] Source code debug marking with GDB
- [ ] PlatformIO integration
- [x] Makefile cleanup
- [ ] Standard Modules
  + [ ] Out -> Needs a standard Real procedure.
  + [x] Strings
  + [x] Math
  + [x] Strings
- [x] Library
