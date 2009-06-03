use strict;
use warnings;

package B::Hooks::Parser;

use B::Hooks::OP::Check;
use parent qw/DynaLoader/;

our $VERSION = '0.09';

sub dl_load_flags { 0x01 }

__PACKAGE__->bootstrap($VERSION);

sub inject {
    my ($code) = @_;

    setup();

    my $line   = get_linestr();
    my $offset = get_linestr_offset();

    substr($line, $offset, 0) = $code;

    set_linestr($line);

    return;
}

1;

__END__

=head1 NAME

B::Hooks::Parser - Interface to perls parser variables

=head1 DESCRIPTION

This module provides an API for parts of the perl parser. It can be used to
modify code while it's being parsed.

=head1 Perl API

=head2 setup()

Does some initialization work. This must be called before any other functions
of this module if you intend to use C<set_linestr>. Returns an id that can be
used to disable the magic using C<teardown>.

=head2 teardown($id)

Disables magic registed using C<setup>.

=head2 get_linestr()

Returns the line the parser is currently working on, or undef if perl isn't
parsing anything right now.

=head2 get_linestr_offset()

Returns the position within the current line to which perl has already parsed
the input, or -1 if nothing is being parsed currently.

=head2 set_linestr($string)

Sets the line the perl parser is currently working on to C<$string>.

Note that perl won't notice any changes in the line string after the position
returned by C<get_linestr_offset>.

Throws an exception when nothing is being compiled.

=head2 inject($string)

Convenience function to insert a piece of perl code into the current line
string (as returned by C<get_linestr>) at the current offset (as returned by
C<get_linestr_offset>).

=head1 C API

The following functions work just like their equivalent in the perl api.

=head2 hook_op_check_id hook_parser_setup (void)

=head2 void hook_parser_teardown (hook_op_check_id id)

=head2 const char *hook_parser_get_linestr (pTHX)

=head2 IV hook_parser_get_linestr_offset (pTHX)

=head2 hook_parser_set_linestr (pTHX_ const char *new_value)

=head1 AUTHOR

Florian Ragwitz E<lt>rafl@debian.orgE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (c) 2008  Florian Ragwitz

This module is free software.

You may distribute this code under the same terms as Perl itself.

=cut
