use strict;
use warnings;
use Test::More tests => 2;

BEGIN { use_ok('B::Hooks::Parser'); }

our $x;

BEGIN { $x = "BEGIN { is(B::Hooks::Parser::get_linestr(), \$x); }\n" }
BEGIN { is(B::Hooks::Parser::get_linestr(), $x); }
