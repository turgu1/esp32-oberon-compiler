    
    .section .bss._module_Test2
    .align 4
_module_Test2_data:
x:  .space 48
a:  .space 4

    .section .text._module_Test2
    .align 4
_module_Test2_data_addr:
    .int _module_Test2_data

    .section .init._module_Test2
    .align 4
_module_Test2_init:
    entry a1, 0
    l32r a2, _module_Test2_data_addr
    movi a3, 4
    s32i a3, a2, 0
    movi a3, 2
    s32i a3, a2, 4
    retw

    .section .init_table._module_Test2
    .int _module_Test2_init 
