    .title "Module Pattern19, Key A5E3D3EE"
    .sbttl "Oberon ESP32 Compiler Version 0.1.0"

    .align 4
    .section .bss_Pattern19_A5E3D3EE
    .global _Pattern19_A5E3D3EE_s_bss
_Pattern19_A5E3D3EE_s_bss:
_Pattern19_s_bss:
    .space 12

# -->    1: MODULE Pattern19;
# -->    2: VAR
# -->    3:   i, j : INTEGER;
# -->    4:   b : BOOLEAN;
# -->    5: BEGIN


    .align 4
    .section .init_Pattern19_A5E3D3EE

_Pattern19_init:
    entry a1, 16
    movi a2, _Pattern19_s_bss
# -->    6:   ASSERT(3 < 5);
    movi a3, 3
    movi a4, 5
    blt a3, a4, 1$
    movi a6, 1794
    call4 _OberonSyscallHandler
1$:
# -->    7:   IF 3 < 5 THEN
    movi a3, 3
    movi a4, 5
    bge a3, a4, 2$
# -->    8:     ASSERT(b);
    l8ui a3, a2, 8
    bnez a3, 3$
    movi a6, 1794
    call4 _OberonSyscallHandler
3$:
# -->    9:   END;
2$:
# -->   10:   ASSERT(i = j);
    l32i a3, a2, 0
    l32i a4, a2, 4
    beq a3, a4, 4$
    movi a6, 1794
    call4 _OberonSyscallHandler
4$:
# -->   11:   ASSERT(i = 0);
    l32i a3, a2, 0
    movi a4, 0
    beq a3, a4, 5$
    movi a6, 1794
    call4 _OberonSyscallHandler
5$:
# -->   12:   ASSERT(b)
# -->   13: END Pattern19.
    l8ui a3, a2, 8
    bnez a3, 6$
    movi a6, 1794
    call4 _OberonSyscallHandler
6$:
    retw
    .size _Pattern19_init, .-_Pattern19_init


    .align 4
    .section .init_table_Pattern19_A5E3D3EE
    .int _Pattern19_init

