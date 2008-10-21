use strict;
use warnings;
use Test::More tests => 1;
use Test::Pod::Coverage;

pod_coverage_ok(
    'B::Hooks::Parser',
    { also_private => ['dl_load_flags'] },
);
