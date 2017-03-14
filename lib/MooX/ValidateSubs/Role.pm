package MooX::ValidateSubs::Role;

use Moo::Role;
use Carp qw/croak/;

sub _validate_sub {
    my ($self, $name, $type, $spec, @params) = @_;
    my @count = (scalar @params);
    if ( ref $spec eq 'ARRAY' ) {
        push @count, scalar @{ $spec };
        if ( $count[0] == 1 and ref $params[0] eq 'ARRAY' ) {
            @params = @{ $params[0] };
            $count[0] = scalar @params;
        }
        $count[2] = $count[1] - grep { $spec->[$_]->[1] } 0 .. $count[1] - 1;
        $count[0] >= $count[2] && $count[0] <= $count[1]
            or croak sprintf 'Error - Invalid count in %s for sub - %s - expected - %s - got - %s',
                $type, $name, $count[1], $count[0];
        foreach ( 0 .. $count[1] - 1 ) {
            not $params[$_] and $spec->[$_]->[1] and next;
            $spec->[$_]->[0]->($params[$_]);
        }
    
        return 1;
    }
    
    my %para = $count[0] == 1 ? %{ $params[0] } : @params;
    my %cry = (%{$spec}, %para);
    foreach (keys %cry) {
        not $para{$_} and $spec->{$_}->[1] and next;
        $spec->{$_} and $spec->{$_}->[0]->($para{$_}) 
            or croak sprintf "Error in %s - An illegal passed key - %s - for sub %s", $type, $_, $name;   
    }

    return 1;
}

1;

