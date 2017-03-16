use Test::More;

{
    package One::Two::Three;
    use Moo;
    use MooX::ValidateSubs;
    use Types::Standard qw/Str/;

    has thing => (
        is => 'ro',
        default => sub { return 'a b c'; }
    );
    
    validate_subs(
        hash => { 
            params => {
                one => [Str, sub { 'Hello World' }], 
                two => [Str, 'build_two' ], 
                three => [Str],
            },
            returns => {
                one => [Str, sub { 'Hello World' }], 
                two => [Str, 'build_two' ], 
                three => [Str],
                four => [Str],
            }
        }
    );

    sub build_two {
        return 'Goodbye World';
    }

    sub hash {
        my ($self, %hash) = @_;
        $hash{four} = $self->thing;
        return %hash;
    }
}

my $maybe = One::Two::Three->new();
my %list = $maybe->hash( three => 'ahhhh' );
is_deeply(\%list, { 
    one => 'Hello World', 
    two => 'Goodbye World', 
    three => 'ahhhh', 
    four => 'a b c' 
}, "list returns 4 key/value pairs" );

done_testing();

