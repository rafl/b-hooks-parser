use strict;
use warnings;

package B::Hooks::Parser;

use parent qw/DynaLoader/;

our $VERSION = '0.03';

sub dl_load_flags { 0x01 }

__PACKAGE__->bootstrap($VERSION);

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
of this module if you intend to use C<set_linestr>.

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

=head1 C API

The following functions work just like their equivalent in the perl api.

=head2 void hook_parser_setup (void)

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
