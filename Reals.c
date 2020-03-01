#include ".obnc/Reals.h"
#include <obnc/OBNC.h>

#define OBERON_SOURCE_FILENAME "Reals.Mod"

union {
  OBNC_REAL f;
  OBNC_INTEGER i;
} w;

void Reals__RealToInt_(OBNC_REAL r_, OBNC_INTEGER *i_) {
  w.f = r_;  *i_ = w.i;
}

void Reals__IntToReal_(OBNC_INTEGER i_, OBNC_REAL *r_) {
  w.i = i_; *r_ = w.f;
}

void Reals__Init(void) {
}
