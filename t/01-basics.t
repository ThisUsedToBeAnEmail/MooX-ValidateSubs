use Test::More;

use lib '.';
use t::odea::Maybe;

my $maybe = t::odea::Maybe->new();

my %hash = $maybe->hello_hash( one => 'a', two => ['b'], three => { four => 'ahh' } );
is_deeply(\%hash, { one => 'a', two => ['b'], three => { four => 'ahh' }, four => 'd' });
eval { $maybe->hello_hash };
my $error = $@;
like( $error, qr/^Mandatory parameters/, "hello hash fails");

my @list = $maybe->a_list( 'a', ['b'], { four => 'ahh' } );
is_deeply(\@list, [ 'a', ['b'], { four => 'ahh' } ]);
eval { $maybe->a_list };
my $errors = $@;
like( $errors, qr/^0 parameters were passed/, "a list fails");

done_testing();

