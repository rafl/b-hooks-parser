use strict;
use warnings;
use Test::More tests => 5;
use Test::Exception;

BEGIN { use_ok('B::Hooks::Parser'); }

our $x;

BEGIN { $x = "BEGIN { is(B::Hooks::Parser::get_linestr(), \$x); }\n" }
BEGIN { is(B::Hooks::Parser::get_linestr(), $x); }

is(B::Hooks::Parser::get_linestr, undef, 'get_linestr returns undef at runtime');
ok(B::Hooks::Parser::get_linestr_offset() < 0, 'get_linestr_offset returns something negative at runtime');

throws_ok(sub {
    B::Hooks::Parser::set_linestr('foo');
}, qr/runtime/, 'set_linestr fails at runtime');
