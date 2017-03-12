package t::odea::Maybe;

use Moo;
use MooX::ValidateSubs;

validate_subs (
    [qw/hello_hash different_but_the_same/] => {
        params => {
            one   => { SCALAR },
            two   => { ARRAYREF },
            three => { HASHREF },
        },
    },
    a_list => {
        params => [ SCALAR, ARRAYREF, HASHREF ],
    }
);

sub hello_hash {
    my ($self, %args) = @_;

    $args{four} = 'd';
    return %args;
}

sub different_but_the_same {
    my ($self, %args) = @_;

    $args{four} = 'rawrrrrr';
    return %args;
}

sub a_list {
    my ($self, @args) = @_;    
    return @args;
}

1;
