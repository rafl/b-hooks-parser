#ifndef __HOOK_PARSER_H__
#define __HOOK_PARSER_H__

#include "perl.h"

void hook_parser_setup (void);
char *hook_parser_get_linestr (pTHX);
IV hook_parser_get_linestr_offset (pTHX);
void hook_parser_set_linestr (pTHX_ const char *new_value);

char *hook_parser_get_lex_stuff (pTHX);
void hook_parser_clear_lex_stuff (pTHX);
char *hook_toke_skipspace (pTHX_ char *s);
char *hook_toke_scan_str (pTHX_ char *s);

#endif
