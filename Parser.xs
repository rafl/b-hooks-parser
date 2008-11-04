#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#define NEED_PL_parser
#include "ppport.h"

#include "hook_parser.h"
#include "stolen_chunk_of_toke.c"

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
	return count;
}

void
hook_parser_setup () {
	filter_add (grow_linestr, NULL);
}

const char *
hook_lexer_get_lex_stuff (pTHX) {
	if (NOT_PARSING || !PL_lex_stuff) {
		return NULL;
	}

	return SvPVX_const (PL_lex_stuff);
}

void
hook_lexer_clear_lex_stuff (pTHX) {
	if (!NOT_PARSING) {
		return;
	}

	PL_lex_stuff = (SV *)NULL;
}

char *
hook_lexer_move_past_token (pTHX_ char *s) {
	STRLEN tokenbuf_len;

	while (s < PL_bufend && isSPACE (*s)) {
		s++;
	}

	tokenbuf_len = strlen (PL_tokenbuf);
	if (memEQ (s, PL_tokenbuf, tokenbuf_len)) {
		s += tokenbuf_len;
	}

	return s;
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

MODULE = B::Hooks::Parser  PACKAGE = B::Hooks::Lexer  PREFIX = hook_lexer_

const char *
hook_lexer_get_lex_stuff ()
	C_ARGS:
		aTHX

void
hook_lexer_clear_lex_stuff ()
	C_ARGS:
		aTHX

int
hook_lexer_move_past_token (offset)
		int offset
	PREINIT:
		char *base_s, *s;
	CODE:
		base_s = SvPVX (PL_linestr) + offset;
		s = hook_lexer_move_past_token (aTHX_ base_s);
		RETVAL = s - base_s;
	OUTPUT:
		RETVAL
