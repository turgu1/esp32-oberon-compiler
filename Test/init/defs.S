    
    .equ init_data, 0        # ESP32 loader is doing it
    .equ trap_support, 1

    # Special registers

    .equ WINDOWBASE,  72
    .equ EPC_1,      177    # Exception program counter
    .equ DEPC,       192    # Double exception program counter
    .equ EXCSAVE,    208
    .equ EXCSAVE_1,  209
    .equ EXCSAVE_2,  210
    .equ EXCSAVE_3,  211
    .equ EXCSAVE_4,  212
    .equ EXCSAVE_5,  213
    .equ EXCSAVE_6,  214
    .equ EXCSAVE_7,  215
    .equ PS_WOE,     230
    .equ VECBASE,    231    # Vector base
    .equ EXCCAUSE,   232    # Exception cause
    .equ EXCVADDR,   238

    .equ PS_UM,            0x00000020
    .equ PS_INTLEVEL_MASK, 0x0000000F
    
    # EXCCAUSE definitions
    .equ CAUSE_ILLEGAL_INST,     0
    .equ CAUSE_SYSCALL,          1
    .equ CAUSE_INST_FETCH_ERROR, 2
    .equ CAUSE_LOAD_STORE_ERROR, 3
    .equ CAUSE_LEVEL_1_INT,      4
    .equ CAUSE_ALLOCA,           5
    .equ CAUSE_DIVIDE_BY_0,      6

    .equ XCHAL_PS_OWB_SHIFT,     8
    .equ XCHAL_PS_OWB_BITS,      4
    .equ XCHAL_EXCM_LEVEL,       3

    .equ DEFAULT,                1

#define PS_INTLEVEL(n)		((n)&PS_INTLEVEL_MASK)    
#define STRUCT_BEGIN            .pushsection .text; .struct 0
#define STRUCT_FIELD(ctype,size,asname,name)    asname: .space  size
#define STRUCT_AFIELD(ctype,size,asname,name,n) asname: .space  (size)*(n)
#define STRUCT_END(sname)       sname##Size:; .popsection

#define ALIGNUP(n, val) (((val) + (n)-1) & -(n))

STRUCT_BEGIN
STRUCT_FIELD (long, 4, XT_STK_EXIT,     exit) /* exit point for dispatch */
STRUCT_FIELD (long, 4, XT_STK_PC,       pc)   /* return PC */
STRUCT_FIELD (long, 4, XT_STK_PS,       ps)   /* return PS */
STRUCT_FIELD (long, 4, XT_STK_A0,       a0)
STRUCT_FIELD (long, 4, XT_STK_A1,       a1)   /* stack pointer before interrupt */
STRUCT_FIELD (long, 4, XT_STK_A2,       a2)
STRUCT_FIELD (long, 4, XT_STK_A3,       a3)
STRUCT_FIELD (long, 4, XT_STK_A4,       a4)
STRUCT_FIELD (long, 4, XT_STK_A5,       a5)
STRUCT_FIELD (long, 4, XT_STK_A6,       a6)
STRUCT_FIELD (long, 4, XT_STK_A7,       a7)
STRUCT_FIELD (long, 4, XT_STK_A8,       a8)
STRUCT_FIELD (long, 4, XT_STK_A9,       a9)
STRUCT_FIELD (long, 4, XT_STK_A10,      a10)
STRUCT_FIELD (long, 4, XT_STK_A11,      a11)
STRUCT_FIELD (long, 4, XT_STK_A12,      a12)
STRUCT_FIELD (long, 4, XT_STK_A13,      a13)
STRUCT_FIELD (long, 4, XT_STK_A14,      a14)
STRUCT_FIELD (long, 4, XT_STK_A15,      a15)
STRUCT_FIELD (long, 4, XT_STK_SAR,      sar)
STRUCT_FIELD (long, 4, XT_STK_EXCCAUSE, exccause)
STRUCT_FIELD (long, 4, XT_STK_EXCVADDR, excvaddr)
STRUCT_FIELD (long, 4, XT_STK_LBEG,   lbeg)
STRUCT_FIELD (long, 4, XT_STK_LEND,   lend)
STRUCT_FIELD (long, 4, XT_STK_LCOUNT, lcount)
STRUCT_FIELD (long, 4, XT_STK_TMP0,   tmp0)
STRUCT_FIELD (long, 4, XT_STK_TMP1,   tmp1)
STRUCT_FIELD (long, 4, XT_STK_TMP2,   tmp2)
STRUCT_END(XtExcFrame)

#define XT_STK_NEXT1      XtExcFrameSize
#define XT_STK_NEXT2      XT_STK_NEXT1   

.if 0
# To be revisited (GTur)
/* Allocate extra storage if needed */
#if XCHAL_EXTRA_SA_SIZE != 0

#if XCHAL_EXTRA_SA_ALIGN <= 16
#define XT_STK_EXTRA            ALIGNUP(XCHAL_EXTRA_SA_ALIGN, XT_STK_NEXT1)
#else
/* If need more alignment than stack, add space for dynamic alignment */
#define XT_STK_EXTRA            (ALIGNUP(XCHAL_EXTRA_SA_ALIGN, XT_STK_NEXT1) + XCHAL_EXTRA_SA_ALIGN)
#endif
#define XT_STK_NEXT2            (XT_STK_EXTRA + XCHAL_EXTRA_SA_SIZE)

#else

#define XT_STK_NEXT2            XT_STK_NEXT1   

#endif
.endif

#define XT_STK_FRMSZ            (ALIGNUP(0x10, XT_STK_NEXT2) + 0x20)


/* ---- macro interrupt_vector ---- */

.macro interrupt_vector name handler level
      .begin      literal_prefix .\name
      .section    .\name\().text, "ax"
      .global     _\name
      .type       _\name, @function
      .global     \handler
      .align      4
  _\name\():
      wsr     a0, EXCSAVE_\level  
      call0   \handler  /* never return */
      .end    literal_prefix
      .literal_position
.endm

/* ---- macro function ---- */

.macro function name
      .type _\name, @function
      .align 4
      .literal_position
      .align 4
  _\name\():
.endm

/* ---- macro iram_function ---- */

.macro iram_function name
      .section .iram1, "ax"
      function \name
.endm

/* ---- macro window_handler ---- */

.macro window_handler name location
      .org    \location
      .global _\name
  _\name\():
.endm

/* ---- macro interrupt_handler ---- */

.macro interrupt_handler name weak=0
    .if \weak
      .weak \name
    .endif
      .set \name, _\name
      .section .iram1, "ax"
      .type _\name, @function
      .align 4
      .literal_position
      .align 4
  _\name\():
.endm

.macro end_interrupt_handler name level
      .align 4
  _\name\()_exit:
      rsr a0, EXCSAVE_\level
      rfi \level
.endm

/* ---- macro redirector_xt_to ---- */

.macro redirector from to
      .align 4
      .literal_position
  \from\():
      call0 \to
.endm

/* ---- macro SPILL_ALL_WINDOWS ---- */

.macro SPILL_ALL_WINDOWS
    and a12, a12, a12
    rotw 3
    and a12, a12, a12
    rotw 3
    and a12, a12, a12
    rotw 3
    and a12, a12, a12
    rotw 3
    and a12, a12, a12
    rotw 4
.endm
