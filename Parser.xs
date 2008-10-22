#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#define NEED_PL_parser
#include "ppport.h"

#include "hook_parser.h"

#define NOT_PARSING (!PL_parser || !PL_bufptr)

const char *
hook_parser_get_linestr (pTHX) {
	if (NOT_PARSING) {
		return NULL;
	}

	return SvPVX_const (PL_linestr);
}

IV
hook_parser_get_linestr_offset (pTHX) {
	char *linestr;

	if (NOT_PARSING) {
		return -1;
	}

	linestr = SvPVX (PL_linestr);
	return PL_bufptr - linestr;
}

void
hook_parser_set_linestr (pTHX_ const char *new_value) {
	int new_len;

	if (NOT_PARSING) {
        croak ("trying to alter PL_linestr at runtime");
	}

	new_len = strlen (new_value);

	if (SvLEN (PL_linestr) < new_len) {
		croak ("forced to realloc PL_linestr for line %s,"
		       " bailing out before we crash harder", SvPVX (PL_linestr));
	}

	SvGROW (PL_linestr, new_len);

	Copy (new_value, SvPVX (PL_linestr), new_len + 1, char);

	SvCUR_set (PL_linestr, new_len);
	PL_bufend = SvPVX(PL_linestr) + new_len;
}

STATIC I32
grow_linestr (pTHX_ int idx, SV *sv, int maxlen) {
	const I32 count = FILTER_READ (idx + 1, sv, maxlen);
	SvGROW (sv, 8192);
	filter_del (grow_linestr);
	return count;
}

void
hook_parser_setup () {
	filter_add (grow_linestr, NULL);
}

MODULE = B::Hooks::Parser  PACKAGE = B::Hooks::Parser  PREFIX = hook_parser_

PROTOTYPES: DISABLE

void
hook_parser_setup ()

const char *
hook_parser_get_linestr ()
	C_ARGS:
		aTHX

IV
hook_parser_get_linestr_offset ()
	C_ARGS:
		aTHX

void
hook_parser_set_linestr (new_value)
		const char *new_value
	C_ARGS:
		aTHX_ new_value
