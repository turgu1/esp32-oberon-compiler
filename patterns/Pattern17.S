
    .title "Module Pattern17, Key A5E3D3EC"
    .sbttl "Oberon ESP32 Compiler Version 0.1.0"

    .align 4
    .section .bss_Pattern17_A5E3D3EC
    .global _Pattern17_A5E3D3EC_s_bss
_Pattern17_A5E3D3EC_s_bss:
_Pattern17_s_bss:
    .space 20

# -->    1: MODULE Pattern17;
# -->    2: VAR
# -->    3:   m, n: INTEGER;
# -->    4:   x, y: REAL;
# -->    5:   b: BOOLEAN;
# -->    6:   ch: CHAR;
# -->    7:   
# -->    8: BEGIN


    .align 4
    .section .init_Pattern17_A5E3D3EC
_Pattern17_init:
    entry a1, 16
    movi a2, _Pattern17_s_bss
# -->    9:   n := ABS(m);
    l32i a3, a2, 0
    abs a3, a3
    s32i a3, a2, 4
# -->   10:   y := ABS(x);
    l32i a3, a2, 8
    slli a3, a3, 1
    srli a3, a3, 1
    s32i a3, a2, 12
# -->   11:   b := ODD(n);
    l32i a3, a2, 4
    movi a4, 1
    and a3, a3, a4
    s8i a3, a2, 16
# -->   12:   n := ORD(ch);
    l8ui a3, a2, 17
    s32i a3, a2, 4
# -->   13:   n := FLOOR(x);
    l32i a3, a2, 8    wfr f0, a3

    floor.s a3, f0, 0
    s32i a3, a2, 4
# -->   14:   y := FLT(m);
    l32i a3, a2, 0
    float.s f0, a3, 0
    rfr a3, f0
    s32i a3, a2, 12
# -->   15:   n := LSL(m, 3);
    l32i a3, a2, 0
    slli a3, a3, 3
    s32i a3, a2, 4
# -->   16:   n := ASR(m, 8);
    l32i a3, a2, 0
    srai a3, a3, 8
    s32i a3, a2, 4
# -->   17:   m := ROR(m, n);
    l32i a3, a2, 0
    l32i a4, a2, 4
    ssr a4
    mov a4, a3
    src a3, a3, a4
    s32i a3, a2, 0
# -->   18: END Pattern17.
    retw
    .size _Pattern17_init, .-_Pattern17_init



    .align 4
    .section .init_table_Pattern17_A5E3D3EC
    .int _Pattern17_init
