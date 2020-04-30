/*GENERATED BY OBNC 0.16.1*/

#ifndef SYS_h
#define SYS_h

#include <obnc/OBNC.h>

#define SYS__OP_ADD_ 1

#define SYS__OP_SUB_ 2

#define SYS__OP_MUL_ 3

#define SYS__OP_DIV_ 4

#define SYS__OP_MOD_ 5

#define SYS__IntToReal_ src__SYS__IntToReal_
void SYS__IntToReal_(OBNC_INTEGER i_, OBNC_REAL *r_);

#define SYS__RealToInt_ src__SYS__RealToInt_
void SYS__RealToInt_(OBNC_REAL r_, OBNC_INTEGER *i_);

#define SYS__Exit_ src__SYS__Exit_
void SYS__Exit_(OBNC_INTEGER i_);

#define SYS__Assembler_ src__SYS__Assembler_
OBNC_INTEGER SYS__Assembler_(const char fromFile_[], OBNC_INTEGER fromFile_len, const char toFile_[], OBNC_INTEGER toFile_len);

#define SYS__Int64Op_ oberon__SYS__Int64Op_
void SYS__Int64Op_(OBNC_INTEGER op_, OBNC_INTEGER *xlow_, OBNC_INTEGER *xhigh_, OBNC_INTEGER ylow_, OBNC_INTEGER yhigh_);

#define SYS__StrToInt64_ oberon__SYS__StrToInt64_
int SYS__StrToInt64_(OBNC_INTEGER base_, const char str_[], OBNC_INTEGER str_len, OBNC_INTEGER *xlow_, OBNC_INTEGER *xhigh_);

#define SYS__Init src__SYS__Init
void SYS__Init(void);

#endif
