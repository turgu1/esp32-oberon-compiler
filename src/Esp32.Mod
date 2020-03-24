(* ESP32 Definition *)

(* Please note that this file is *not* used by the compiler. It was a first cut on the
   ESP32 instruction set definition and is a kind of NutShell view of this architecture... *)

(* Xtensa Little Endian Architecture (Big Endian not available) *)

(* The following Xtensa LX6 instruction options are available on the ESP32: 

    - Core Architecture
    - Windowed Registers (64 registers)
    - 16-bits instructions
    - Boolean registers (16) and instructions
    - Zero-overhead Loops with buffer size of 256
    - NSA/NSAU Instructions
    - MIN/MAX Instructions
    - SEXT Instruction
    - MUL16S / MUL16U / MULL / MULUH / MULSH Instructions
    - QUOS / QUOU / REMS / REMU Instructions

    Not used options / Instructions
    - MAC16 DSP Instructions
    - CLAMPS Instruction
    - L32AI / S32RI / S32C1I Instructions
    - ADDX / SUBX Instructions
    - Processor ID
    - WER / RER Instructions
    - DEBUG Option
 *)

 (* 
    Registers usage: 
    
    A0 : Return Address
    A1 : Stack Pointer
    A2 : SB
  *)

MODULE Esp32;

CONST
  maxCode = 100000H;

  (* Core Architecture Op codes *)
  (* Load *)
  opL8UI  = 000002H; (* RRI8 8-bit unsigned load (8-bit offset)
                        L8UI at, as, 0..255 *)
  opL16SI = 009002H; (* RRI8 16-bit signed load (8-bit shifted offset)
                        L16SI at, as, 0..510 *)
  opL16UI = 001002H; (* RRI8 16-bit unsigned load (8-bit shifted offset)
                        L16UI at, as, 0..510 *)
  opL32I  = 002002H; (* RRI8 32-bit load (8-bit shifted offset)
                        L32I at, as, 0..1020 *)
  opL32R  = 000001H; (* RI16 32-bit load PC-relative (16-bit negative word offset)
                        L32R at, label *)

  (* Store *)
  opS8I  = 004002H; (* RRI8 8-bit store (8-bit offset) 
                       S8I at, as, 0..255 *)
  opS16I = 005002H; (* RRI8 16-bit store (8-bit shifted offset) 
                       S16I at, as, 0..510 *)
  opS32I = 006002H; (* RRI8 32-bit store (8-bit shifted offset) 
                       S32I at, as, 0..1020 *)

  (* Jump and Call *)
(*opCALL0  = 000005H;  * CALL4  Call subroutine, PC-relative  NOT USED
                         CALL0 label *)
(*opCALLX0 = 0000C0H;  * CALLX Call subroutine, address in register NOT USED
                         CALLX0 as *)
  opJ      = 000006H; (* CALL  Unconditional jump, PC-relative
                         J label *)
  opJX     = 0000A0H; (* CALLX Unconditional jump, address in register
                         JX as *)
(*opRET    = 000080H;  * CALLX Subroutine return—jump to return address. 
                         Used to return from a routine called by CALL0/CALLX0 NOT USED *)

  (* Conditional Branch *)
  opBEQZ  = 000016H; (* BRI12  Branch if equal to zero
                        BEQZ as, label *)
  opBNEZ  = 000056H; (* BRI12  Branch if not equal to zero
                        BNEZ as, label *)
  opBGEZ  = 0000D6H; (* BRI12  Branch if greater than or equal to zero
                        BGEZ as, label *)
  opBLTZ  = 000096H; (* BRI12  Branch if less than zero
                        BLTZ as, label *)
  opBEQI  = 000026H; (* BRI8   Branch if equal immediate
                        BEQI as, imm, label *)
  opBNEI  = 000066H; (* BRI8   Branch if not equal immediate
                        BNEI as, imm, label *)
  opBGEI  = 0000E6H; (* BRI8   Branch if greater than or equal immediate
                        BGEI as, imm, label *)
  opBLTI  = 0000A6H; (* BRI8   Branch if less than immediate
                        BLTI as, imm, label *)
  opBGEUI = 0000F6H; (* BRI8   Branch if greater than or equal unsigned immediate
                        BGEUI as, imm, label *)
  opBLTUI = 0000B6H; (* BRI8   Branch if less than unsigned immediate
                        BLTUI as, imm, label *)
  opBBCI  = 006007H; (* RRI8b  Branch if bit clear immediate
                        BBCI as, 0..31, label *)
  opBBSI  = 00E007H; (* RRI8b  Branch if bit set immediate
                        BBSI as, 0..31, label *)
  opBEQ   = 001007H; (* RRI8   Branch if equal
                        BEQ as, at, label *)
  opBNE   = 009007H; (* RRI8   Branch if not equal
                        BNE as, at, label *)
  opBGE   = 00A007H; (* RRI8   Branch if greater than or equal
                        BGE as, at, label *)
  opBLT   = 002007H; (* RRI8   Branch if less than
                        BLT as, at, label *)
  opBGEU  = 00B007H; (* RRI8   Branch if greater than or equal unsigned
                        BGEU as, at, label *)
  opBLTU  = 003007H; (* RRI8   Branch if less than Unsigned
                        BLTU as, at, label *)
  opBANY  = 008007H; (* RRI8   Branch if any of masked bits set
                        BANY as, at, label *)
  opBNONE = 000007H; (* RRI8   Branch if none of masked bits set (All Clear)
                        BNONE as, at, label *)
  opBALL  = 004007H; (* RRI8   Branch if all of masked bits set
                        BALL as, at, label *)
  opBNALL = 00C007H; (* RRI8   Branch if not all of masked bits set
                        BNALL as, at, label *)
  opBBC   = 005007H; (* RRI8   Branch if bit clear
                        BBC as, at, label *)
  opBBS   = 00D007H; (* RRI8   Branch if bit set
                        BBS as, at, label *)

  (* Move *)
  opMOVI   = 000A002H; (* RRI8 Load register with 12-bit signed constant
                          MOVI at, -2048..2047 *)
  opMOVEQZ = 0830000H; (* RRR  Conditional move if zero
                          MOVEQZ ar, as, at *)
  opMOVNEZ = 0930000H; (* RRR  Conditional move if non-zero
                          MOVNEZ ar, as, at *)
  opMOVLTZ = 0A30000H; (* RRR  Conditional move if less than zero
                          MOVLTZ ar, as, at *)
  opMOVGEZ = 0B30000H; (* RRR  Conditional move if greater than or equal to zero
                          MOVGEZ ar, as, at *)

  (* Arithmetic *)
  opADD   = 0800000H; (* RRR  Add two registers
                         ADD ar, as, at *)
  opADDX2 = 0900000H; (* RRR  Add register to register shifted by 1
                         ADDX2 ar, as, at *)
  opADDX4 = 0A00000H; (* RRR  Add register to register shifted by 2
                         ADDX4 ar, as, at *)
  opADDX8 = 0B00000H; (* RRR  Add register to register shifted by 3
                         ADDX8 ar, as, at *)
  opSUB   = 0C00000H; (* RRR  Subtract two registers
                         SUB ar, as, at *)
  opSUBX2 = 0D00000H; (* RRR  Subtract register from register shifted by 1
                         SUBX2 ar, as, at *)
  opSUBX4 = 0E00000H; (* RRR  Subtract register from register shifted by 2
                         SUBX4 ar, as, at *)
  opSUBX8 = 0F00000H; (* RRR  Subtract register from register shifted by 3
                         SUBX8 ar, as, at *)
  opNEG   = 0600000H; (* RRR  Negate
                         NEG ar, at *)
  opABS   = 0600100H; (* RRR  Absolute value
                         ABS ar, at *)
  opADDI  = 000C002H; (* RRI8 Add signed constant to register
                         ADDI at, as, -128..127 *)
  opADDMI = 000D002H; (* RRI8 Add signed constant shifted by 8 to register
                         ADDMI at, as, -32768..32512 *)

  (* Bitwise Logical *)
  opAND = 0100000H; (* RRR Bitwise logical AND
                       AND ar, as, at *)
  opOR  = 0200000H; (* RRR Bitwise logical OR
                       OR ar, as, at *)
  opXOR = 0300000H; (* RRR Bitwise logical exclusive OR
                       XOR ar, as, at *)

  (* Shift *)
  opEXTUI = 0040000H; (* RRRx Extract unsigned field immediate
                         EXTUI ar, at, shiftimm, maskimm *)
  opSLLI  = 0010000H; (* RRRll Shift left logical immediate by 1..31 bit positions
                         SLLI ar, as, 1..31 *)
  opSRLI  = 0410000H; (* RRR Shift right logical immediate by 0..15 bit positions
                         SRLI ar, at, 0..15 *)
  opSRAI  = 0210000H; (* RRRra Shift right arithmetic immediate by 0..31 bit positions
                         SRAI ar, at, 0..31 *)
  opSRC   = 0810000H; (* RRR Shift right combined (a funnel shift with shift amount from SAR)
                         SRC ar, as, at *)
  opSRA   = 0B10000H; (* RRR Shift right arithmetic (shift amount from SAR)
                         SRA ar, at *)
  opSLL   = 0A10000H; (* RRR Shift left logical
                         SLL ar, as *)
  opSRL   = 0910000H; (* RRR Shift right logical
                         SRL ar, at *)
(*opSSA8B = 0403000H;  * RRR Set shift amount register (SAR) for big-endian byte align NOT USED
                         SSA8B as *)
  opSSA8L = 0402000H; (* RRR Set shift amount register (SAR) for little-endian byte align
                         SSA8L as *)
  opSSR   = 0400000H; (* RRR Set shift amount register (SAR) for shift right logical
                         SSR as *)
  opSSL   = 0401000H; (* RRR Set shift amount register (SAR) for shift left logical
                         SSL as *)
  opSSAI  = 0404000H; (* RRR Set shift amount register (SAR) immediate
                         SSAI 0..31 *)

  (* Processor Control *)
  opRSR   = 0030000H; (* RSR Read Special Register
                         RSR at, 0..255 *)
  opWSR   = 0130000H; (* RSR Write Special Register
                         WSR at, 0..255 *)
  opXSR   = 0610000H; (* RSR Exchange Special Register
                         XSR at, 0..255 *)
  opISYNC = 0002000H; (* RRR Instruction fetch synchronize
                         ISYNC *)
  opRSYNC = 0002010H; (* RRR Instruction register synchronize
                         RSYNC *)
  opESYNC = 0002020H; (* RRR Register value synchronize
                         ESYNC *)
  opDSYNC = 0002030H; (* RRR Load/store synchronize
                         DSYNC *)
  opNOP   = 00020F0H; (* RRR No operation
                         NOP *)

  (* Zero Overhead Loop Option *)
  (* Special Registers for Zero Overhead Loop option *)
  srLBEG   = 0;  (* Loop begin *) 
  srLEND   = 1;  (* Loop end *)
  srLCOUNT = 2;  (* Loop count *)
  (* Instructions *)
  opLOOP    = 0008076H; (* BRI8 Loop
                           LOOP as, label *)
  opLOOPGTZ = 000A076H; (* BRI8 Loop if Greater Than Zero
                           LOOPGTZ as, label *)
  opLOOPNEZ = 0009076H; (* BRI8 Loop if Not-Equal Zero
                           LOOPNEZ as, label *)

  (* Code density instruction (16-bits wide) *)
  opADDn   = 0000AH; (* RRRN Add two registers
                        ADD.N ar, as, at *)
  opADDIn  = 0000BH; (* RRRN Add register and immediate (-1 and 1..15)
                        ADDI.N ar, as, imm *)
  opBEQZn  = 0008CH; (* RRI6 Branch if register is zero with a 6-bit unsigned offset (forward only)
                        BEQZ.N as, label *)
  opBNEZn  = 000CCH; (* RRI6 Branch if register is non-zero with a 6-bit unsigned offset (forward only)
                        BNEZ.N as, label *)
(*opBREAKn = 0F02DH;  * RRRN This instruction is the same as BREAK but with a 16-bit encoding
                        BREAK.N 0..15 *)
  opL32In  = 00008H; (* RRRNi4 Load 32 bits, 4-bit offset
                        L32I.N at, as, 0..60 *)
  opMOVn   = 0000DH; (* RRRN Narrow move
                        MOV.N at, as *)
  opMOVIn  = 0000CH; (* RRI7 Load register with immediate (-32..95)
                        MOVI.N as, -32..95 *)
  opNOPn   = 0F03DH; (* RRRN This instruction performs no operation. It is typically used for instruction alignment.
                        NOP.N *)
(*opRETn   = 0F00DH;  * RRRN The same as RET but with a 16-bit encoding NOT USED *)
  opRETWn  = 0F01DH; (* RRRN The same as RETW but with a 16-bit encoding
                        RETW.N *)
  opS32In  = 00009H; (* RRRNi4 Store 32 bits, 4-bit offset
                        S32I.N at, as, 0..60 *)

  (* 16bits / 32bits Multiplication Options *)
  opMUL16S = 0D10000H; (* RRR Signed 16×16 multiplication
                          MUL16S ar, as, at *)
  opMUL16U = 0C10000H; (* RRR Unsigned 16×16 multiplication
                          MUL16U ar, as, at *)
  opMULL   = 0820000H; (* RRR Multiply low
                          MULL ar, as, at *)
  opMULUH  = 0A20000H; (* RRR Multiply unsigned high
                          MULUH ar, as, at *)
  opMULSH  = 0B20000H; (* RRR Multiply signed high
                          MULSH ar, as, at *)

  (* 32bits Integer Divide *)
  opQUOS = 0D20000H; (* RRR Quotient Signed
                        QUOS ar, as, at *)
  opQUOU = 0C20000H; (* RRR Quotient Unsigned
                        QUOU ar, as, at *)
  opREMS = 0F20000H; (* RRR Remainder Signed
                        REMS ar, as, at *)
  opREMU = 0E20000H; (* RRR Remainder Unsigned
                        REMU ar, as, at *)

  (* Boolean Instructions *)
  opALL4  = 0009000H; (* RRR  4-Boolean and reduction
                         ALL4 bt, bs *)
  opALL8  = 000B000H; (* RRR  8-Boolean and reduction
                         ALL8 bt, bs *)
  opANDB  = 0020000H; (* RRR  Boolean and
                         ANDB br, bs, bt *)
  opANDBC = 0120000H; (* RRR  Boolean and with complement
                         ANDBC br, bs, bt *)
  opANY4  = 0008000H; (* RRR  4-Boolean or reduction
                         ANY4 bt, bs *)
  opANY8  = 000A000H; (* RRR  8-Boolean or reduction
                         ANY8 bt, bs *)
  opBF    = 0000076H; (* RRI8 Branch if boolean false
                         BF bs, label *)
  opBT    = 0001076H; (* RRI8 Branch if boolean true
                         BT bs, label *)
  opMOVF  = 0C30000H; (* RRR  Conditional move if false
                         MOVF ar, as, bt *)
  opMOVT  = 0D30000H; (* RRR  Conditional move if true
                         MOVT ar, as, bt *)
  opORB   = 0220000H; (* RRR  Boolean or
                         ORB br, bs, bt *)
  opORBC  = 0320000H; (* RRR  Boolean or with complement
                         ORBC br, bs, bt *)
  opXORB  = 0420000H; (* RRR  Boolean xor
                         XORB br, bs, bt *)

  (* Windowed Register Option *)
  opMOVSP   = 0001000H; (* RRR    Atomic check window and move
                           MOVSP at, as *)
  opCALL4   = 0000015H; (* CALL4  Call subroutine, PC-relative,  4 Registers
                           CALL4 label *)
  opCALL8   = 0000025H; (* CALL4  Call subroutine, PC-relative,  8 Registers
                           CALL8 label *)
  opCALL12  = 0000035H; (* CALL4  Call subroutine, PC-relative, 12 Registers
                           CALL12 label *)
  opCALLX4  = 00000D0H; (* CALLX  Call subroutine, address in register,  4 Registers
                           CALLX4 as *)
  opCALLX8  = 00000E0H; (* CALLX  Call subroutine, address in register,  8 Registers
                           CALLX8 as *)
  opCALLX12 = 00000F0H; (* CALLX  Call subroutine, address in register, 12 Registers
                           CALLX12 as *)
  opENTRY   = 0000036H; (* BRI12  [Align 4] Subroutine entry—rotate registers, adjust stack pointer
                           ENTRY as, 0..32760 *)
  opRETW    = 0000090H; (* CALLX  Subroutine return—unrotate registers, jump to return address
                           RETW *)
  opROTW    = 0408000H; (* RRR    Rotate window by a constant
                           ROTW -8..7 *)
  opL32E    = 0090000H; (* RRI4   Load 32 bits for window exception
                           L32E at, as, -64..-4 *)
  opS32E    = 0490000H; (* RRI4   Store 32 bits for window exception
                           S32E at, as, -64..-4 *)
  opRFWO    = 0003400H; (* RRR    Return from window overflow exception
                           RFWO *)
  opRFWU    = 0003500H; (* RRR    Return from window underflow exception
                           RFWU *)

  (* Miscellaneous Operations *)
  opCLAMPS = 0330000H; (* RRR Clamp to signed power of two range
                          CLAMPS ar, as, 7..22 *)
  opMAX    = 0530000H; (* RRR Maximum value signed
                          MAX ar, as, at *)
  opMAXU   = 0730000H; (* RRR Maximum value unsigned
                          MAXU ar, as, at *)
  opMIN    = 0430000H; (* RRR Minimum value signed
                          MIN ar, as, at *)
  opMINU   = 0630000H; (* RRR Minimum value unsigned
                          MINU ar, as, at *)
  opNSA    = 040E000H; (* RRR Normalization shift amount signed
                          NSA at, as *)
  opNSAU   = 040F000H; (* RRR Normalization shift amount unsigned
                          NSAU at, as *)
  opSEXT   = 0230000H; (* RRR Sign extend
                          SEXT ar, as, 7..22 *)

  (* Floating Point *)
  opABSs    = 0FA0010H; (* RRR  Single-precision absolute value
                           ABS.S fr, fs *)
  opADDs    = 00A0000H; (* RRR  Single-precision add
                           ADD.S fr, fs, ft *)
  opCEILs   = 0BA0000H; (* RRR  Scale and convert single-precision to integer, round to +infinite
                           CEIL.S ar, fs, 0..15 *)
  opFLOATs  = 0CA0000H; (* RRR  Convert signed integer to single-precision and scale
                           FLOAT.S fr, as, 0..15 *)
  opFLOORs  = 0AA0000H; (* RRR  Scale and convert single-precision to integer, round to -infinite
                           FLOOR.S ar, fs, 0..15 *)
  opLSI     = 0000003H; (* RRI8 Load single-precision immediate
                           LSI ft, as, 0..1020 *)
  opLSIU    = 0008003H; (* RRI8 Load single-Precision Immediate with Base Update
                           LSIU ft, as, 0..1020 *)
  opLSX     = 0080000H; (* RRR  Load single-Precision Indexed
                           LSX fr, as, at *)
  opLSXU    = 0180000H; (* RRR  Load single-Precision Indexed with Base Update
                           LSXU fr, as, at *)
  opMADDs   = 04A0000H; (* RRR  Single-precision multiply/add
                           MADD.S fr, fs, ft *)
  opMOVs    = 0FA0000H; (* RRR  Single-precision move
                           MOV.S fr, fs *)
  opMOVEQZs = 08B0000H; (* RRR  Single-precision conditional move if equal to zero
                           MOVEQZ.S fr, fs, at *)
  opMOVFs   = 0CB0000H; (* RRR  Single-precision conditional move if false
                           MOVF.S fr, fs, bt *)
  opMOVGEZs = 0BB0000H; (* RRR  Single-precision conditional move if greater than or equal to zero
                           MOVGEZ.S fr, fs, at *)
  opMOVLTZs = 0AB0000H; (* RRR  Single-precision conditional move if less than zero
                           MOVLTZ.S fr, fs, at *)
  opMOVNEZs = 09B0000H; (* RRR  Single-precision conditional move if not equal to zero
                           MOVNEZ.S fr, fs, at *)
  opMOVTs   = 0DB0000H; (* RRR  Single-precision conditional move if true
                           MOVT.S fr, fs, bt *)
  opMSUBs   = 05A0000H; (* RRR  Single-precision multiply/subtract
                           MSUB.S fr, fs, ft *)
  opMULs    = 02A0000H; (* RRR  Single-precision multiply
                           MUL.S fr, fs, ft *)
  opNEGs    = 0FA0060H; (* RRR  Single-precision negate
                           NEG.S fr, fs *)
  opOEQs    = 02B0000H; (* RRR  Single-precision compare equal
                           OEQ.S br, fs, ft *)
  opOLEs    = 06B0000H; (* RRR  Single-precision compare less than or equal
                           OLE.S br, fs, ft *)
  opOLTs    = 04B0000H; (* RRR  Single-precision compare less than
                           OLT.S br, fs, ft *)
  opRFR     = 0FA0040H; (* RRR  Move from FR to AR
                           RFR ar, fs *)
  opROUNDs  = 08A0000H; (* RRR  Scale and convert single-precision to integer, round to nearest
                           ROUND.S ar, fs, 0..15 *)
  opSSI     = 0004003H; (* RRI8  Store single-Precision Immediate
                           SSI ft, as, 0..1020 *)
  opSSIU    = 000C003H; (* RRI8 Store single-Precision Immediate with Base Update
                           SSIU ft, as, 0..1020 *)
  opSSX     = 0480000H; (* RRR  Store single-Precision Indexed
                           SSX fr, as, at *)
  opSSXU    = 0580000H; (* RRR  Store single-Precision Indexed with Base Update
                           SSXU fr, as, at *)
  opSUBs    = 01A0000H; (* RRR  Single-precision subtract
                           SUB.S fr, fs, ft *)
  opTRUNCs  = 09A0000H; (* RRR  Scale and convert single-precision to signed integer, round to 0
                           TRUNC.S ar, fs, 0..15 *)
  opUEQs    = 03B0000H; (* RRR  Single-precision compare unordered or equal
                           UEQ.S br, fs, ft *)
  opUFLOATs = 0DA0000H; (* RRR  Convert unsigned integer to single-precision and scale
                           UFLOAT.S fr, as, 0..15 *)
  opULEs    = 07B0000H; (* RRR  Single-precision compare unordered or less than or equal
                           ULE.S br, fs, ft *)
  opULTs    = 05B0000H; (* RRR  Single-precision compare unordered or less than
                           ULT.S br, fs, ft *)
  opUNs     = 01B0000H; (* RRR  Single-precision compare unordered
                           UN.S br, fs, ft *)
  opUTRUNCs = 0EA0000H; (* RRR  Scale and convert single-precision to unsigned integer, round to 0
                           UTRUNC.S ar, fs, 0..15 *)
  opWFR     = 0FA0050H; (* RRR  Move from AR to FR
                           WFR fr, as *)

VAR
  instr : INTEGER; (* Instruction result after formatting *)
  pc    : INTEGER; (* Program Counter *)

  code  : ARRAY maxCode OF BYTE;

PROCEDURE range(v, low, high: INTEGER);
BEGIN
  IF (v < low) OR (v > high) THEN
    (* INTERNAL ERROR *)
  END
END range;

(* Instructions formatting and generation *)

PROCEDURE Gen24;
BEGIN
  code[pc] := instr; INC(pc);
  code[pc] := ASR(instr,  8); INC(pc);
  code[pc] := ASR(instr, 16); INC(pc);    
END Gen24;

PROCEDURE Gen16;
BEGIN
  code[pc] := instr; INC(pc);
  code[pc] := ASR(instr, 8); INC(pc);
END Gen16;

(* +-----+-----+-----+-----+-----+-----+
   | op2 | op1 |  r  |  s  |  t  | op0 |
   +-----+-----+-----+-----+-----+-----+ *)
PROCEDURE RRR(op: INTEGER; r, s, t : BYTE);
BEGIN
  range(r, 0, 15);
  range(s, 0, 15);
  range(t, 0, 15);
  instr := op + LSL(r, 12) + LSL(s, 8) + LSL(t, 4);
  Gen24();
END RRR;

(* +-----+-----+-----+-----+-----+-----+
   | msk |op1 s|  r  |shft |  t  | op0 |
   +-----+-----+-----+-----+-----+-----+ *)
PROCEDURE RRRx(op: INTEGER; r, t, shift (* 0..31 *), mask (* 1..16 *): BYTE);
BEGIN
  range(r,     0, 15);
  range(t,     0, 15);
  range(shift, 0, 31);
  range(mask,  1, 16);
  instr := op + LSL(mask - 1, 20) + LSL(ASR(shift, 4), 16) + 
                LSL(r, 12) + LSL(shift MOD 16, 8) + LSL(t, 4);
  Gen24();
END RRRx;

(* +-------+-----+-----+-----+-----+-----+
   |op2 sa4| op1 |  r  |  s  | sa03| op0 |
   +-------+-----+-----+-----+-----+-----+ *)
PROCEDURE RRRll(op: INTEGER; r, s, sa (* 1..31 *): BYTE);
BEGIN
  range(r,  0, 15);
  range(s,  0, 15);
  range(sa, 1, 31);
  instr := op + LSL(ASR(32 - sa, 4), 20) + 
                LSL(r, 12) +  LSL(s, 8) + LSL((32 - sa) MOD 16, 4);
  Gen24();
END RRRll;

(* +-------+-----+-----+-----+-----+-----+
   |op2 sa4| op1 |  r  |  s  | sa03| op0 |
   +-------+-----+-----+-----+-----+-----+ *)
PROCEDURE RRRra(op: INTEGER; r, t, sa (* 0..31 *): BYTE);
BEGIN
  range(r,  0, 15);
  range(t,  0, 15);
  range(sa, 0, 31);
  instr := op + LSL(ASR(sa, 4), 20) + 
                LSL(r, 12) + LSL(sa MOD 16, 8) + LSL(t, 4);
  Gen24();
END RRRra;

(* +-----+-----+-----+-----+-----+-----+
   | im4 | op1 |  r  |  s  |  t  | op0 |
   +-----+-----+-----+-----+-----+-----+ *)
PROCEDURE RRI4(op: INTEGER; r, s, t, imm4 : BYTE);
BEGIN 
  range(r, 0, 15);
  range(s, 0, 15);
  range(t, 0, 15);
  instr := op + LSL(imm4, 20) + LSL(r, 12) + LSL(s, 8) + LSL(t, 4);
  Gen24();
END RRI4;

(* +-----+-----+-----+-----+-----+-----+
   |    imm8   |  r  |  s  |  t  | op0 |
   +-----+-----+-----+-----+-----+-----+ *)
PROCEDURE RRI8(op: INTEGER;  r, s, t, imm8 : BYTE);
BEGIN 
  range(r, 0, 15);
  range(s, 0, 15);
  range(t, 0, 15);
  instr := op + LSL(imm8, 16) + LSL(r, 12) + LSL(s, 8) + LSL(t, 4);
  Gen24();
END RRI8;

(* +-----+-----+-------+-----+-----+-----+
   |    imm8   | op bbi|  s  | bbi | op0 |
   +-----+-----+-------+-----+-----+-----+ *)
PROCEDURE RRI8b(op: INTEGER;  s, bbi, imm8 : BYTE);
BEGIN 
  range(s, 0, 15);
  instr := op + LSL(imm8, 16) + LSL(ASR(bbi, 4), 12) + LSL(s, 8) + LSL(bbi MOD 16, 4);
  Gen24();
END RRI8b;

(* +-----+-----+-----+-----+-----+-----+
   |         imm16         |  t  | op0 |
   +-----+-----+-----+-----+-----+-----+ *)
PROCEDURE RI16(op: INTEGER;  t: BYTE; imm16 : INTEGER);
BEGIN 
  range(t, 0, 15);
  instr := op + LSL(imm16, 8) + LSL(t, 4);
  Gen24();
END RI16;

(* +-----+-----+-----+-----+-----+-----+
   | op2 | op1 |     rs    |  t  | op0 |
   +-----+-----+-----+-----+-----+-----+ *)
PROCEDURE RSR(op: INTEGER; t: BYTE; rs (* 0..255 *): BYTE);
BEGIN
  range(t,  0,  15);
  range(rs, 0, 255);
  instr := op + LSL(rs, 8) + LSL(t, 4);
  Gen24();
END RSR;

(* +-----+-----+-----+-----+-----+-----+
   |         offset           |n | op0 |
   +-----+-----+-----+-----+-----+-----+ *)
PROCEDURE CALL(op: INTEGER; offset: INTEGER);
BEGIN 
  range(offset, -131068, 131075);
  instr := op + LSL(offset, 6);
  Gen24();
END CALL;

(* +-----+-----+-----+-----+-----+-----+
   |         offset           |n | op0 |
   +-----+-----+-----+-----+-----+-----+ *)
PROCEDURE CALL4(op: INTEGER; offset: INTEGER);
BEGIN 
  range(offset, -524284, 524288);
  instr := op + LSL(ASR(offset, 2), 6);
  Gen24();
END CALL4;

(* +-----+-----+-----+-----+-----+-----+
   | op1 | op2 |  r  |  s  | m|n | op0 |
   +-----+-----+-----+-----+-----+-----+ *)
PROCEDURE CALLX(op: INTEGER; r, s: BYTE; offset: INTEGER);
BEGIN 
  range(r, 0, 15);
  range(s, 0, 15);
  instr := op + LSL(r, 12) + LSL(s, 8);
  Gen24();
END CALLX;

(* +-----+-----+-----+-----+-----+-----+
   |   imm8    |  r  |  s  | m|n | op0 |
   +-----+-----+-----+-----+-----+-----+ *)
PROCEDURE BRI8(op: INTEGER; r, s: BYTE; imm8: BYTE);
BEGIN 
  range(r, 0, 15);
  range(s, 0, 15);
  instr := op + LSL(imm8, 16) + LSL(r, 12) + LSL(s, 8);
  Gen24();
END BRI8;

(* +-----+-----+-----+-----+-----+-----+
   |      imm12      |  s  | m|n | op0 |
   +-----+-----+-----+-----+-----+-----+ *)
PROCEDURE BRI12(op: INTEGER; s: BYTE; imm12: INTEGER);
BEGIN 
  range(s, 0, 15);
  instr := op + LSL(imm12, 12) + LSL(s, 8);
  Gen24();
END BRI12;

(* +-----+-----+-----+-----+
   |  r  |  s  |  t  | op0 |
   +-----+-----+-----+-----+ *)
PROCEDURE RRRN(op: INTEGER; r, s, t : BYTE);
BEGIN
  range(r, 0, 15);
  range(s, 0, 15);
  range(t, 0, 15);
  instr := op + LSL(r, 12) + LSL(s, 8) + LSL(t, 4);
  Gen16();
END RRRN;

(* +-----+-----+-----+-----+
   |imm4 |  s  |  t  | op0 |
   +-----+-----+-----+-----+ *)
PROCEDURE RRRNi4(op: INTEGER; s, t, offset : BYTE);
BEGIN
  range(s, 0, 15);
  range(t, 0, 15);
  range(offset, 0, 60);
  instr := op + LSL(ASR(offset, 2), 12) + LSL(s, 8) + LSL(t, 4);
  Gen16();
END RRRNi4;

(* +-----+-----+-----+-----+
   |imm7a|  s  |i  7b| op0 |
   +-----+-----+-----+-----+ *)
PROCEDURE RI7(op: INTEGER; s, i, imm7 : BYTE);
BEGIN
  range(s, 0, 15);
  instr := op + LSL(imm7 MOD 16, 12) + LSL(s, 8) + LSL(i, 7) + LSL(ASR(imm7, 4), 4);
  Gen16();
END RI7;

(* +-----+-----+-----+-----+
   |imm6a|  s  |iz 6b| op0 |
   +-----+-----+-----+-----+ *)
PROCEDURE RI6(op: INTEGER; s, imm6 : BYTE);
BEGIN
  range(s, 0, 15);
  range(imm6, 0, 63);
  instr := op + LSL(imm6 MOD 16, 12) + LSL(s, 8) + LSL(ASR(imm6, 4), 4);
  Gen16();
END RI6;

END Esp32.
