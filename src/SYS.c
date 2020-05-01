/*GENERATED BY OBNC 0.16.1*/

#include ".obnc/SYS.h"
#include <obnc/OBNC.h>

#include <stdio.h>
#include <stdlib.h> 
#include <unistd.h> 
#include <errno.h>

#define OBERON_SOURCE_FILENAME "SYS.Mod"

extern void exit(int);

union {
  OBNC_REAL f;
  OBNC_INTEGER i;
} w;

union {
  int64_t i;
  struct {
    int32_t xlow;
    int32_t xhigh;
  };
} num1, num2;

void SYS__IntToReal_(OBNC_INTEGER i_, OBNC_REAL *r_)
{
  w.i = i_; *r_ = w.f;
}

void SYS__RealToInt_(OBNC_REAL r_, OBNC_INTEGER *i_)
{
  w.f = r_;  *i_ = w.i;
}

void SYS__Exit_(OBNC_INTEGER i_)
{
  exit(i_);
}

static char cmd[1024];

OBNC_INTEGER SYS__Assembler_(const char fromFile_[], OBNC_INTEGER fromFile_len, const char toFile_[], OBNC_INTEGER toFile_len)
{
  #if 0
    // This doesn't work... yet.
    const char *pgm = "xtensa-esp32-elf-gcc";
    char * args[] = {
      "-x assembler-with-cpp",
      "-c",
      "-O0",
      "-Wall",
      "-fmessage-length=0",
        "-mlongcalls",
      "-mauto-litpools",
      "-mtext-section-literals",
      "-fstrict-volatile-bitfields",
      "-g",
      (char *) fromFile_,
      "-o",
      (char *) toFile_,
      NULL
    };
    
    execv(pgm, args);
    perror("Call to assembler error");
    return 1;
  #else
    int res;

    strcpy(cmd, "xtensa-esp32-elf-gcc -x assembler-with-cpp -c -O0 -Wall -fmessage-length=0 -mlongcalls -mauto-litpools -mtext-section-literals -fstrict-volatile-bitfields -g ");
    strcat(cmd, fromFile_);
    strcat(cmd, " -o ");
    strcat(cmd, toFile_);

    if ((res = system(cmd))) perror("Last assembler msg");
    return res;
  #endif
}

void SYS__Int64Op1_(OBNC_INTEGER op_, OBNC_INTEGER *xlow_, OBNC_INTEGER *xhigh_)
{
  num1.xlow  = * xlow_;
  num1.xhigh = *xhigh_;

  if (op_ == SYS__OP_ABS_) num1.i = llabs(num1.i); 
  else if (op_ == SYS__OP_NEG_) num1.i = -num1.i; 

  *xlow_  = num1.xlow;
  *xhigh_ = num1.xhigh;
}

void SYS__Int64Op2_(OBNC_INTEGER op_, OBNC_INTEGER *xlow_, OBNC_INTEGER *xhigh_, OBNC_INTEGER ylow_, OBNC_INTEGER yhigh_)
{
  num1.xlow  = * xlow_;
  num1.xhigh = *xhigh_;
  num2.xlow  =   ylow_;
  num2.xhigh =  yhigh_;

  if      (op_ == SYS__OP_ADD_) num1.i = num1.i + num2.i; 
  else if (op_ == SYS__OP_SUB_) num1.i = num1.i - num2.i; 
  else if (op_ == SYS__OP_MUL_) num1.i = num1.i * num2.i; 
  else if (op_ == SYS__OP_DIV_) num1.i = num1.i / num2.i; 
  else if (op_ == SYS__OP_MOD_) num1.i = num1.i % num2.i; 

  *xlow_  = num1.xlow;
  *xhigh_ = num1.xhigh;
}

int SYS__StrToInt64_(OBNC_INTEGER base_, const char str_[], OBNC_INTEGER str_len, OBNC_INTEGER *xlow_, OBNC_INTEGER *xhigh_)
{
  errno = 0;
  num1.i = strtoll(str_, NULL, base_);
  *xlow_  = num1.xlow;
  *xhigh_ = num1.xhigh;
  return errno == 0;
}

void SYS__Init(void)
{
}
