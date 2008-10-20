use strict;
use warnings;
use Test::More tests => 1;
use B::Hooks::EndOfScope;
use B::Hooks::Parser;

sub class (&) { }

# This would usually be a compilation error as class only expects one argument,
# but with the 'pass', there are two. After injecting a semicolon after the end
# of the block it becomes valid.

    class {
        BEGIN { on_scope_end {
            my $linestr = B::Hooks::Parser::get_linestr;
            my $offset  = B::Hooks::Parser::get_linestr_offset;
            substr($linestr, $offset, 0) = ';';
            B::Hooks::Parser::set_linestr($linestr);
        }}
    }

pass;
