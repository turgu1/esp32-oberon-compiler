(* ESP32 MWDT Watchdog Timer Control *)

MODULE Watchdog;
  IMPORT SYSTEM, Out;
  CONST 

    (* Watchdog Control Registers *)
    RTC_CNTL_WDTCONFIG0_REG  = 3FF4808CH; (* WDT Configuration register 0    *)
    RTC_CNTL_WDTCONFIG1_REG  = 3FF48090H; (* WDT Configuration register 1    *)
    RTC_CNTL_WDTCONFIG2_REG  = 3FF48094H; (* WDT Configuration register 2    *)
    RTC_CNTL_WDTCONFIG3_REG  = 3FF48098H; (* WDT Configuration register 3    *)
    RTC_CNTL_WDTCONFIG4_REG  = 3FF4809CH; (* WDT Configuration register 4    *)
    RTC_CNTL_WDTFEED_REG*    = 3FF480A0H; (* Watchdog feed register          *)
    RTC_CNTL_WDTWPROTECT_REG = 3FF480A4H; (* Watchdog write protect register *)

    RTC_CNTL_WDTFEED*        = 80000000H; (* WDT Feed value *)
    WDTWPROTECT_UNLOCK       = 50D83AA1H; (* Write Protect  *)

    (* Stage Configuration Values *)
    STG_OFF*           = 0;
    STG_INT*           = 1;
    STG_RESET_CPU*     = 2;
    STG_RESET_SYSTEM*  = 3;
    STG_RESET_RTC*     = 4;

    (* Stage configuration offsets *)
    STG0_OFFSET = 28;
    STG1_OFFSET = 25;
    STG2_OFFSET = 22;
    STG3_OFFSET = 19;

    CPU_RESET_OFFSET = 14;
    SYS_RESET_OFFSET = 11;

    WDT_ENABLE  = 80000000H;

    FLAG_PAUSE_IN_SLEEP = 00000080H;
    FLAG_APPCPU_RESET   = 00000100H;
    FLAG_PROCPU_RESET   = 00000200H;
    FLAG_FLASHBOOT_MODE = 00000400H;
    FLAG_NONE           = 00000000H;

    STAGES_MASK = 7FF80000H;
    RESETS_MASK = 0001F800H;
    FLAGS_MASK  = 00000780H;

  PROCEDURE ShowRegs*;
  VAR
    i: INTEGER;
  BEGIN
    SYSTEM.GET(RTC_CNTL_WDTCONFIG0_REG, i);
    Out.Ln; Out.String("RTC_CNTL_WDTCONFIG0_REG: "); Out.Hex(i, 0);
    (* SYSTEM.GET(RTC_CNTL_WDTCONFIG1_REG, i);
    Out.Ln; Out.String("RTC_CNTL_WDTCONFIG1_REG: "); Out.Hex(i, 0);
    SYSTEM.GET(RTC_CNTL_WDTCONFIG2_REG, i);
    Out.Ln; Out.String("RTC_CNTL_WDTCONFIG2_REG: "); Out.Hex(i, 0);
    SYSTEM.GET(RTC_CNTL_WDTCONFIG3_REG, i);
    Out.Ln; Out.String("RTC_CNTL_WDTCONFIG3_REG: "); Out.Hex(i, 0);
    SYSTEM.GET(RTC_CNTL_WDTCONFIG4_REG, i);
    Out.Ln; Out.String("RTC_CNTL_WDTCONFIG4_REG: "); Out.Hex(i, 0); *)
  END ShowRegs;

  (* EnableCtrlChanges must be called before *)
  PROCEDURE SetResetLengths*(cpu, system: INTEGER);
  VAR i, j: INTEGER;
  BEGIN
    i := LSL(AND(cpu, 7), CPU_RESET_OFFSET) + LSL(AND(system, 7), SYS_RESET_OFFSET);
    SYSTEM.GET(RTC_CNTL_WDTCONFIG0_REG,  j);
    SYSTEM.PUT(RTC_CNTL_WDTCONFIG0_REG,  BOR(i, AND(j, NOT(RESETS_MASK))));
  END SetResetLengths;

  (* Parameters are in ms *)
  (* EnableCtrlChanges must be called before *)
  PROCEDURE SetTimers*(timer0, timer1, timer2, timer3: INTEGER);
  BEGIN
    SYSTEM.PUT(RTC_CNTL_WDTCONFIG1_REG,  LSL(timer0, 7));
    SYSTEM.PUT(RTC_CNTL_WDTCONFIG2_REG,  LSL(timer1, 7));
    SYSTEM.PUT(RTC_CNTL_WDTCONFIG3_REG,  LSL(timer2, 7));
    SYSTEM.PUT(RTC_CNTL_WDTCONFIG4_REG,  LSL(timer3, 7));
  END SetTimers;

  (* EnableCtrlChanges must be called before *)
  PROCEDURE SetStages*(stage0, stage1, stage2, stage3: INTEGER);
    VAR i, j: INTEGER;
  BEGIN
    i := LSL(stage0, STG0_OFFSET) +
         LSL(stage1, STG1_OFFSET) +
         LSL(stage2, STG2_OFFSET) +
         LSL(stage3, STG3_OFFSET);
    SYSTEM.GET(RTC_CNTL_WDTCONFIG0_REG,  j);
    SYSTEM.PUT(RTC_CNTL_WDTCONFIG0_REG,  BOR(i, AND(j, NOT(STAGES_MASK))));
    ShowRegs;
  END SetStages;  

  (* EnableCtrlChanges must be called before *)
  PROCEDURE SetFlags*(flags: INTEGER);
    VAR j: INTEGER;
  BEGIN
    SYSTEM.GET(RTC_CNTL_WDTCONFIG0_REG,  j);
    SYSTEM.PUT(RTC_CNTL_WDTCONFIG0_REG,  BOR(flags, AND(j, NOT(FLAGS_MASK))));
  END SetFlags;

  PROCEDURE EnableCtrlChanges*;
  BEGIN
    SYSTEM.PUT(RTC_CNTL_WDTWPROTECT_REG, WDTWPROTECT_UNLOCK);
  END EnableCtrlChanges;

  PROCEDURE DisableCtrlChanges*;
  BEGIN
    SYSTEM.PUT(RTC_CNTL_WDTWPROTECT_REG, 0)
  END DisableCtrlChanges;

  PROCEDURE Feed*;
  BEGIN
    SYSTEM.PUT(RTC_CNTL_WDTFEED_REG, RTC_CNTL_WDTFEED);
  END Feed;

  PROCEDURE Disable*;
    VAR i: INTEGER;
  BEGIN 
    SYSTEM.PUT(RTC_CNTL_WDTWPROTECT_REG, WDTWPROTECT_UNLOCK);
    SYSTEM.GET(RTC_CNTL_WDTCONFIG0_REG,  i);
    SYSTEM.PUT(RTC_CNTL_WDTCONFIG0_REG,  AND(i, NOT(WDT_ENABLE)));
    SYSTEM.PUT(RTC_CNTL_WDTWPROTECT_REG, 0);
  END Disable;

  PROCEDURE Enable*;
    VAR i: INTEGER;
  BEGIN 
    Feed;
    SYSTEM.PUT(RTC_CNTL_WDTWPROTECT_REG, WDTWPROTECT_UNLOCK);
    SYSTEM.GET(RTC_CNTL_WDTCONFIG0_REG,  i);
    SYSTEM.PUT(RTC_CNTL_WDTCONFIG0_REG,  BOR(i, WDT_ENABLE));
    SYSTEM.PUT(RTC_CNTL_WDTWPROTECT_REG, 0);
  END Enable;

  PROCEDURE Init*;
  BEGIN
    (* By default, only one stage is used. The system will be reset after 10 seconds without feed. *)
    EnableCtrlChanges;
    SetStages(STG_RESET_SYSTEM, STG_OFF, STG_OFF, STG_OFF);
    SetTimers(10000, 0, 0, 0);
    SetResetLengths(7, 7);
    SetFlags(FLAG_PAUSE_IN_SLEEP);
    DisableCtrlChanges
  END Init;

END Watchdog.