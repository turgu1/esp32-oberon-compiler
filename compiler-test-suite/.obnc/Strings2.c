/*GENERATED BY OBNC 0.16.1*/

#include "Out.h"
#include <obnc/OBNC.h>

#define OBERON_SOURCE_FILENAME "Strings2.Mod"

static char s4_[4];

static char s5_[5];

static char f_[20];

static void P_(const char x_[], OBNC_INTEGER x_len)
{
	OBNC_INTEGER i_;

	for (i_ = 0; i_ <= x_len - 1; i_ += 1) {
		if (x_[OBNC_IT(i_, x_len, 17)] == '\x00') {
			Out__Char_('$');
		}
		else {
			Out__Char_(x_[OBNC_IT(i_, x_len, 20)]);
		}
	}
	Out__Ln_();
}


static void K_(void)
{
	char f_[20];

	OBNC_COPY_ARRAY("Hello", f_, 6);
	if (OBNC_CMP(f_, 20, "", 1) == 0) {
		Out__Int_(1, 0);
	}
	OBNC_COPY_ARRAY("", f_, 1);
	if (OBNC_CMP(f_, 20, "", 1) == 0) {
		Out__Int_(2, 0);
	}
	f_[0] = '\x00';
	if (OBNC_CMP(f_, 20, "", 1) == 0) {
		Out__Int_(3, 0);
	}
}


#if OBNC_CONFIG_TARGET_EMB
int main(void)
{
	OBNC_Init(0, NULL);
#else
int main(int argc, char *argv[])
{
	OBNC_Init(argc, argv);
#endif
	Out__Init();
	OBNC_COPY_ARRAY("a", s4_, 2);
	P_(s4_, 4);
	OBNC_COPY_ARRAY("a", s4_, 2);
	P_(s4_, 4);
	OBNC_COPY_ARRAY("ab", s4_, 3);
	P_(s4_, 4);
	P_("a", 2);
	P_("a", 2);
	P_("ab", 3);
	OBNC_COPY_ARRAY("abcd", s5_, 5);
	P_(s5_, 5);
	OBNC_COPY_ARRAY("abcd", s5_, 5);
	P_(s5_, 5);
	OBNC_COPY_ARRAY("", s5_, 1);
	P_(s5_, 5);
	OBNC_COPY_ARRAY("Hello", f_, 6);
	if (OBNC_CMP(f_, 20, "", 1) == 0) {
		Out__Int_(1, 0);
	}
	OBNC_COPY_ARRAY("", f_, 1);
	if (OBNC_CMP(f_, 20, "", 1) == 0) {
		Out__Int_(2, 0);
	}
	f_[0] = '\x00';
	if (OBNC_CMP(f_, 20, "", 1) == 0) {
		Out__Int_(3, 0);
	}
	K_();
	return 0;
}