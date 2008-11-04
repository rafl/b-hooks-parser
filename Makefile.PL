use strict;
use warnings;
use inc::Module::Install;
use ExtUtils::Depends;

name 'B-Hooks-Parser';
all_from 'lib/B/Hooks/Parser.pm';

requires 'parent';
test_requires 'Test::Exception';
test_requires 'B::Hooks::EndOfScope';
configure_requires 'ExtUtils::Depends';

my $pkg = ExtUtils::Depends->new('B::Hooks::Parser');
$pkg->install('hook_parser.h');
$pkg->add_xs('Parser.xs');
$pkg->add_pm('lib/B/Hooks/Parser.pm' => '$(INST_LIB)/B/Hooks/Parser.pm');

mkdir 'build';
$pkg->save_config('build/IFiles.pm');

makemaker_args(
    $pkg->get_makefile_vars,
    dist => { preop => 'pod2text lib/B/Hooks/Parser.pm > README' },
);

extra_tests;

WriteAll;
