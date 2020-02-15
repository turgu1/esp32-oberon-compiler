(* ESP32 Definition *)
(* Xtensa Little Endian Architecture (Big Endian not available) *)

(* The following Xtensa LX6 instruction options are available on the ESP32: 

    - Core Architecture
    - Windowed Registers (64 registers)
    - 16-bits instructions
    - Boolean registers (16) and instructions
    - Zero-overhead Loops with buffer size of 256
    - SEXT Instruction
    - MUL16S / MUL16U / MULL / MULUH / MULSH Instructions
    - QUOS / QUOU / REMS / REMU Instructions

    Not used options
    - MAC16 DSP Instructions
    - CLAMPS Instruction
    - NSA/NSAU Instructions
    - MIN/MAX Instructions
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
    
  *)

MODULE Esp32;

CONST
  maxCode = 100000H;

  (* Core Architecture Op codes *)
  (* Load *)
  opL8UI  = 000002H; (* RRI8 8-bit unsigned load (8-bit offset) *)
  opL16SI = 009002H; (* RRI8 16-bit signed load (8-bit shifted offset) *)
  opL16UI = 001002H; (* RRI8 16-bit unsigned load (8-bit shifted offset) *)
  opL32I  = 002002H; (* RRI8 32-bit load (8-bit shifted offset) *)
  opL32R  = 000001H; (* RI16 32-bit load PC-relative (16-bit negative word offset) *)

  (* Store *)
  opS8I  = 004002H; (* RRI8 8-bit store (8-bit offset) *)
  opS16I = 005002H; (* RRI8 16-bit store (8-bit shifted offset) *)
  opS32I = 006002H; (* RRI8 32-bit store (8-bit shifted offset) *)

  (* Jump and Call *)
(*opCALL0  = 000005H; (* CALL4  Call subroutine, PC-relative  NOT USED *)
(*opCALLX0 = 0000C0H; (* CALLX Call subroutine, address in register NOT USED *)
  opJ      = 000006H; (* CALL  Unconditional jump, PC-relative *)
  opJX     = 0000A0H; (* CALLX Unconditional jump, address in register *)
(*opRET    = 000080H; (* CALLX Subroutine return—jump to return address. 
                         Used to return from a routine called by CALL0/CALLX0 NOT USED *)

  (* Conditional Branch *)
  opBEQZ  = 000016H; (* BRI12  Branch if equal to zero *)
  opBNEZ  = 000056H; (* BRI12  Branch if not equal to zero *)
  opBGEZ  = 0000D6H; (* BRI12  Branch if greater than or equal to zero *)
  opBLTZ  = 000096H; (* BRI12  Branch if less than zero *)
  opBEQI  = 000026H; (* BRI8   Branch if equal immediate *)
  opBNEI  = 000066H; (* BRI8   Branch if not equal immediate *)
  opBGEI  = 0000E6H; (* BRI8   Branch if greater than or equal immediate *)
  opBLTI  = 0000A6H; (* BRI8   Branch if less than immediate *)
  opBGEUI = 0000F6H; (* BRI8   Branch if greater than or equal unsigned immediate *)
  opBLTUI = 0000B6H; (* BRI8   Branch if less than unsigned immediate *)
  opBBCI  = 006007H; (* RRI8b  Branch if bit clear immediate *)
  opBBSI  = 00E007H; (* RRI8b  Branch if bit set immediate *)
  opBEQ   = 001007H; (* RRI8   Branch if equal *)
  opBNE   = 009007H; (* RRI8   Branch if not equal *)
  opBGE   = 00A007H; (* RRI8   Branch if greater than or equal *)
  opBLT   = 002007H; (* RRI8   Branch if less than *)
  opBGEU  = 00B007H; (* RRI8   Branch if greater than or equal unsigned *)
  opBLTU  = 003007H; (* RRI8   Branch if less than Unsigned *)
  opBANY  = 008007H; (* RRI8   Branch if any of masked bits set *)
  opBNONE = 000007H; (* RRI8   Branch if none of masked bits set (All Clear) *)
  opBALL  = 004007H; (* RRI8   Branch if all of masked bits set *)
  opBNALL = 00C007H; (* RRI8   Branch if not all of masked bits set *)
  opBBC   = 005007H; (* RRI8   Branch if bit clear *)
  opBBS   = 00D007H; (* RRI8   Branch if bit set *)

  (* Move *)
  opMOVI   = 000A002H; (* RRI8 Load register with 12-bit signed constant *)
  opMOVEQZ = 0830000H; (* RRR  Conditional move if zero *)
  opMOVNEZ = 0930000H; (* RRR  Conditional move if non-zero *)
  opMOVLTZ = 0A30000H; (* RRR  Conditional move if less than zero *)
  opMOVGEZ = 0B30000H; (* RRR  Conditional move if greater than or equal to zero *)

  (* Arithmetic *)
  opADD   = 0800000H; (* RRR  Add two registers *)
  opADDX2 = 0900000H; (* RRR  Add register to register shifted by 1 *)
  opADDX4 = 0A00000H; (* RRR  Add register to register shifted by 2 *)
  opADDX8 = 0B00000H; (* RRR  Add register to register shifted by 3 *)
  opSUB   = 0C00000H; (* RRR  Subtract two registers *)
  opSUBX2 = 0D00000H; (* RRR  Subtract register from register shifted by 1 *)
  opSUBX4 = 0E00000H; (* RRR  Subtract register from register shifted by 2 *)
  opSUBX8 = 0F00000H; (* RRR  Subtract register from register shifted by 3 *)
  opNEG   = 0600000H; (* RRR  Negate *)
  opABS   = 0600100H; (* RRR  Absolute value *)
  opADDI  = 000C002H; (* RRI8 Add signed constant to register *)
  opADDMI = 000D002H; (* RRI8 Add signed constant shifted by 8 to register *)

  (* Bitwise Logical *)
  opAND = 0100000H; (* RRR Bitwise logical AND *)
  opOR  = 0200000H; (* RRR Bitwise logical OR *)
  opXOR = 0300000H; (* RRR Bitwise logical exclusive OR *)

  (* Shift *)
  opEXTUI = 0040000H; (* RRRx Extract unsigned field immediate *)
  opSLLI  = 0010000H; (* RRRll Shift left logical immediate by 1..31 bit positions *)
  opSRLI  = 0410000H; (* RRR Shift right logical immediate by 0..15 bit positions *)
  opSRAI  = 0210000H; (* RRRra Shift right arithmetic immediate by 0..31 bit positions *)
  opSRC   = 0810000H; (* RRR Shift right combined (a funnel shift with shift amount from SAR) *)
  opSRA   = 0B10000H; (* RRR Shift right arithmetic (shift amount from SAR) *)
  opSLL   = 0A10000H; (* RRR Shift left logical *)
  opSRL   = 0910000H; (* RRR Shift right logical *)
  opSSA8B = 0403000H; (* RRR Set shift amount register (SAR) for big-endian byte align *)
  opSSA8L = 0402000H; (* RRR Set shift amount register (SAR) for little-endian byte align *)
  opSSR   = 0400000H; (* RRR Set shift amount register (SAR) for shift right logical *)
  opSSL   = 0401000H; (* RRR Set shift amount register (SAR) for shift left logical *)
  opSSAI  = 0404000H; (* RRR Set shift amount register (SAR) immediate *)

  (* Processor Control *)
  opRSR   = 0030000H; (* RSR Read Special Register *)
  opWSR   = 0130000H; (* RSR Write Special Register *)
  opXSR   = 0610000H; (* RSR Exchange Special Register *)
  opISYNC = 0002000H; (* RRR Instruction fetch synchronize *)
  opRSYNC = 0002010H; (* RRR Instruction register synchronize *)
  opESYNC = 0002020H; (* RRR Register value synchronize *)
  opDSYNC = 0002030H; (* RRR Load/store synchronize *)
  opNOP   = 00020F0H; (* RRR No operation *)

  (* Zero Overhead Loop Option *)
  (* Special Registers for Zero Overhead Loop option *)
  srLBEG   = 0;  (* Loop begin *) 
  srLEND   = 1;  (* Loop end *)
  srLCOUNT = 2;  (* Loop count *)
  (* Instructions *)
  opLOOP    = 0008076H; (* BRI8 Loop *)
  opLOOPGTZ = 000A076H; (* BRI8 Loop if Greater Than Zero *)
  opLOOPNEZ = 0009076H; (* BRI8 Loop if Not-Equal Zero *)

  (* Code density instruction (16-bits wide) *)
  opADDn   = 0000AH; (* RRRN Add two registers  *)
  opADDIn  = 0000BH; (* RRRN Add register and immediate (-1 and 1..15) *)
  opBEQZn  = 0008CH; (* RRI6 Branch if register is zero with a 6-bit unsigned offset (forward only) *)
  opBNEZn  = 000CCH; (* RRI6 Branch if register is non-zero with a 6-bit unsigned offset (forward only) *)
  opBREAKn = 0F02DH; (* RRRN This instruction is the same as BREAK but with a 16-bit encoding *)
  opL32In  = 00008H; (* RRRNi4 Load 32 bits, 4-bit offset *)
  opMOVn   = 0000DH; (* RRRN Narrow move *)
  opMOVIn  = 0000CH; (* RRI7 Load register with immediate (-32..95) *)
  opNOPn   = 0F03DH; (* RRRN This instruction performs no operation. It is typically used for instruction alignment. *)
(*opRETn   = 0F00DH;  * RRRN The same as RET but with a 16-bit encoding NOT USED *)
  opRETWn  = 0F01DH; (* RRRN The same as RETW but with a 16-bit encoding *)
  opS32In  = 00009H; (* RRRNi4 Store 32 bits, 4-bit offset *)

  (* 16bits / 32bits Multiplication Options *)
  opMUL16S = 0D10000H; (* RRR Signed 16×16 multiplication *)
  opMUL16U = 0C10000H; (* RRR Unsigned 16×16 multiplication *)
  opMULL   = 0820000H; (* RRR Multiply low *)
  opMULUH  = 0A20000H; (* RRR Multiply unsigned high *)
  opMULSH  = 0B20000H; (* RRR Multiply signed high *)

  (* 32bits Integer Divide *)
  opQUOS = 0D20000H; (* RRR Quotient Signed *)
  opQUOU = 0C20000H; (* RRR Quotient Unsigned *)
  opREMS = 0F20000H; (* RRR Remainder Signed *)
  opREMU = 0E20000H; (* RRR Remainder Unsigned *)

  (* Boolean Instructions *)
  opALL4  = 0009000H; (* RRR  4-Boolean and reduction *)
  opALL8  = 000B000H; (* RRR  8-Boolean and reduction *)
  opANDB  = 0020000H; (* RRR  Boolean and *)
  opANDBC = 0120000H; (* RRR  Boolean and with complement *)
  opANY4  = 0008000H; (* RRR  4-Boolean or reduction *)
  opANY8  = 000A000H; (* RRR  8-Boolean or reduction *)
  opBF    = 0000076H; (* RRI8 Branch if boolean false *)
  opBT    = 0001076H; (* RRI8 Branch if boolean true *)
  opMOVF  = 0C30000H; (* RRR  Conditional move if false *)
  opMOVT  = 0D30000H; (* RRR  Conditional move if true *)
  opORB   = 0220000H; (* RRR  Boolean or *)
  opORBC  = 0320000H; (* RRR  Boolean or with complement *)
  opXORB  = 0420000H; (* RRR  Boolean xor *)

  (* Windowed Register Option *)
  opMOVSP   = 0H; (* RRR    Atomic check window and move *)
  opCALL4   = 0H; (* CALL4  Call subroutine, PC-relative,  4 Registers *)
  opCALL8   = 0H; (* CALL4  Call subroutine, PC-relative,  8 Registers *)
  opCALL12  = 0H; (* CALL4  Call subroutine, PC-relative, 12 Registers *)
  opCALLX4  = 0H; (* CALLX  Call subroutine, address in register,  4 Registers *)
  opCALLX8  = 0H; (* CALLX  Call subroutine, address in register,  8 Registers *)
  opCALLX12 = 0H; (* CALLX  Call subroutine, address in register, 12 Registers *)
  opENTRY   = 0H; (* BRI12  [Align 4] Subroutine entry—rotate registers, adjust stack pointer *)
  opRETW    = 0H; (* CALLX  Subroutine return—unrotate registers, jump to return address *)
  opROTW    = 0H; (* RRR    Rotate window by a constant *)
  opL32E    = 0H; (* RRI4   Load 32 bits for window exception *)
  opS32E    = 0H; (* RRI4   Store 32 bits for window exception *)
  opRFWO    = 0H; (* RRR    Return from window overflow exception *)
  opRFWU    = 0H; (* RRR    Return from window underflow exception *)

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
  range(r, 0, 15);
  range(s, 0, 15);
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
