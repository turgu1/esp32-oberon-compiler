    
    .section .bss_module_Test2
    .align 4

x:  .space 48
a:  .space 4

    .section .init_module_Test2
    .align 4

_module_Test2_init:
    entry a1, 16
    movi a3, 80000000 / 115200  # Baud rate
    movi a2, 0x3FF40014         # UART0 CLKDIV register location
    s32i a3, a2, 0              # Set baud rate
    retw

    .align 4
    .global _put_string
_put_string:
    entry a1, 16
1:
    l8ui a6, a2, 0              # load next char (a6 will be a2 in _put_char)
    beqz a6, 2f                 # if 0, this is the end
    call4 _put_char             # output the character
    addi a2, a2, 1              # adjust index
    j 1b
2:
    retw

    .align 4
    .global _put_char
_put_char:
    entry  a1, 16
    movi   a3, 0x3FF40000         # UART0 FIFO registers location
    s8i    a2, a3, 0    
    retw

    .align 4
    .global _put_char2
_put_char2:
    entry  a1, 16
    movi   a2, 50
    movi   a3, 0x3FF40000         # UART0 FIFO registers location
    s8i    a2, a3, 0    
    retw

    .section .init_table_module_Test2
    .int _module_Test2_init 
