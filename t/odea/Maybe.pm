package t::odea::Maybe;

use Moo;
use MooX::ValidateSubs;

validate_subs (
    [qw/hello_one different_but_the_same/] => {
        params => {
            one   => SCALAR,
            two   => ARRAYREF,
            three => HASHREF,
        },
        returns => {
            one   => SCALAR,
            two   => ARRAYREF,
            three => HASHREF,
            four  => SCALAR,
        },
    },
    a_list_to_a_hash => {
        params => [ SCALAR, ARRAYREF, HASHREF ],
        returns => {
            one   => SCALAR,
            two   => ARRAYREF,
            three => HASHREF,
            four  => SCALAR,
        }
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

1;
