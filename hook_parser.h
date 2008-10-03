#ifndef __HOOK_PARSER_H__
#define __HOOK_PARSER_H__

#include "perl.h"

const char *hook_parser_get_linestr (pTHX);
UV hook_parser_get_linestr_offset (pTHX);
void hook_parser_set_linestr (pTHX_ const char *new_value);

#endif
