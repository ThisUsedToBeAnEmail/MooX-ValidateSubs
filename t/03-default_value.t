use Test::More;

{
    package One::Two::Three;
    use Moo;
    use MooX::ValidateSubs;
    use Types::Standard qw/Str/;

    validate_subs(
        hash => { 
            params => {
                one => [Str, sub { 'Hello World' }], 
                two => [Str, 'build_two' ], 
                three => [Str],
                four => [Str, 1],
            },
        }
    );

    sub build_two {
        return 'Goodbye World';
    }

    sub hash {
        my ($self, %array) = @_;
        return %array;
    }
}

my $maybe = One::Two::Three->new();

my %list = $maybe->hash( three => 'ahhhh' );
is_deeply(\%list, { one => 'Hello World', two => 'Goodbye World', three=>  'ahhhh' }, "list returns 3 key/value pairs");

eval { $maybe->hash };
my $errors = $@;
like( $errors, qr/Undef did not pass type constraint "Str"/, "a list fails");

done_testing();

