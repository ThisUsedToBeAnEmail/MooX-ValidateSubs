#!perl -T
use 5.006;
use strict;
use warnings;
use Test::More;

plan tests => 1;

BEGIN {
    use_ok( 'MooX::ValidateSubs' ) || print "Bail out!\n";
}

diag( "Testing MooX::ValidateSubs $MooX::ValidateSubs::VERSION, Perl $], $^X" );
