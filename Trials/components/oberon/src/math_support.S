    .title Floating Point Support
    .sbttl Oberon ESP32 Compiler Version 0.1.0

.macro function name
      .type _\name, @function
      .align 4
      .literal_position
      .align 4
  _\name\():
.endm

.macro iram_function name
      .section .iram1, "ax"
      function \name
.endm

    .global __fdiv32, __fsqrt32

iram_function _fdiv32

    div0.s    f3, f1
    nexp01.s  f4, f1
    const.s   f5, 1
    maddn.s   f5, f4, f3
    mov.s f6, f3
    mov.s f7, f1
    nexp01.s  f8, f0
    maddn.s   f6, f5, f3
    const.s   f5, 1
    const.s   f2, 0
    neg.s     f9, f8
    maddn.s   f5,f4,f6
    maddn.s   f2, f9, f3
    mkdadj.s  f7, f0
    maddn.s   f6,f5,f6
    maddn.s   f9,f4,f2
    const.s   f5, 1
    maddn.s   f5,f4,f6
    maddn.s   f2,f9,f6
    neg.s     f9, f8
    maddn.s   f6,f5,f6
    maddn.s   f9,f4,f2
    addexpm.s f2, f7
    addexp.s  f6, f7
    divn.s    f2, f9, f6
    ret
    .size __fdiv32, .-__fdiv32

iram_function _fsqrt32   # f1 := sqrt(f0)

    sqrt0.s   f2, f0
    const.s   f5, 0
    maddn.s   f5, f2, f2
    nexp01.s  f3, f0
    const.s   f4, 3
    addexp.s  f3, f4
    maddn.s   f4, f5, f3
    nexp01.s  f5, f0
    neg.s     f6, f5
    maddn.s   f2, f4, f2
    const.s   f1, 0
    const.s   f4, 0
    const.s   f7, 0
    maddn.s   f1, f6, f2
    maddn.s   f4, f2, f3
    const.s   f6, 3
    maddn.s   f7, f6, f2
    maddn.s   f5, f1, f1
    maddn.s   f6, f4, f2
    neg.s     f3, f7
    maddn.s   f1, f5, f3
    maddn.s   f7, f6, f7
    mksadj.s  f2, f0
    nexp01.s  f5, f0
    maddn.s   f5, f1, f1
    neg.s     f3, f7
    addexpm.s f1, f2
    addexp.s  f3, f2
    divn.s    f1, f5, f3
    ret
    .size __fsqrt32, .-__fsqrt32
