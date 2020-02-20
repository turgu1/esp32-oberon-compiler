    
    .section .bss_module_Test2
    .align 4

x:  .space 48
a:  .space 4

    .section .init_module_Test2
    .align 4

_module_Test2_init:
    entry a1, 0
    movi a2, .bss_module_Test2
    movi a3, 4
    s32i a3, a2, 0
    movi a3, 2
    s32i a3, a2, 4
    retw

    .section .init_table_module_Test2
    .int _module_Test2_init 
