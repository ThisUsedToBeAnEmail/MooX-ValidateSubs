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
                two => [Str, sub { 'Goodbye World' }], 
                three => [Str] 
            },
        }
    );

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

