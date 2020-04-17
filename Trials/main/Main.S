
    .title "Module Main, Key 6FDDD89C"
    .sbttl "Oberon ESP32 Compiler Version 0.2.0"

    .align 4
    .section .rodata_strs_Main_6FDDD89C
_Main_data_strs:
    .byte 72,101,108,108,111,32,119,111,114,108,100,33,0,0,0,0

    .align 4
    .section .bss_Main_6FDDD89C
    .global _Main_6FDDD89C_s_bss
_Main_6FDDD89C_s_bss:
_Main_s_bss:
    .space 4



    .align 4
    .section .text_init_Main_6FDDD89C

    .global _Main_6FDDD89C_p__init
_Main_6FDDD89C_p__init:
_Main_init:
    entry a1, 16
    movi a2, _Main_s_bss
    call4 _Out_B72BE1A0_p_Ln
    movi a6, _Main_data_strs
    movi a7, 13
    call4 _Out_B72BE1A0_p_String
    call4 _Out_B72BE1A0_p_Ln
    retw
    .size _Main_init, .-_Main_init
