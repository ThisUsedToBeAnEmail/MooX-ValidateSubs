package MooX::ValidateSubs;

use strict;
use warnings;

use MooX::ReturnModifiers;
use Carp qw/croak/;
use Scalar::Util;

our $VERSION = '0.05';

sub import {
    my $target    = caller;
    my %modifiers = return_modifiers($target);
    
    my $modify_subs = sub {
        my @attr = @_;
        while (@attr) {
            my @names = ref $attr[0] eq 'ARRAY' ? @{ shift @attr } : shift @attr;
            my $spec = shift @attr;
            for my $name (@names) {
                my $store_spec = sprintf '%s_spec', $name;
                $modifiers{has}->($store_spec => ( is => 'ro', default => sub { $spec } ));
                unless ( $name =~ m/^\+/ ) {
                    $modifiers{before}->(
                        $name, sub { shift->_validate_sub( $name, 'params', $store_spec, @_ ) }
                    );
                }
            }
        }
    };

    $target->can('_validate_sub') or $modifiers{with}->('MooX::ValidateSubs::Role');

    { no strict 'refs'; *{"${target}::validate_subs"} = $modify_subs; }

    return 1;
}

1;

__END__

=head1 NAME

MooX::ValidateSubs - Validating sub routine parameters via Type::Tiny.

=head1 VERSION

Version 0.05

=cut

=head1 SYNOPSIS
    
    package Welcome::To::A::World::Of::Types;

    use Moo;
    use MooX::ValidateSubs;
    use Types::Standard qw/Str ArrayRef HashRef/;

    validate_subs (
        hello_world => {
            one   => [ Str, 1 ], # 1 means I'm optional
            two   => [ ArrayRef ],
            three => [ HashRef ],
        },
        goodbye_world => [ [Str], [ArrayRef], [HashRef] ],
    );

    sub hello_world { 
        my ($self, %args) = @_;
        
        # $args{one}    # optional string 
        # $args{two}    # valid arrayref 
        # $args{three}  # valid hashref
    }

    sub goodbye_world {
        my ($self, $scalar, $arrayref, $hashref) = @_;
        
    }

    package Extends::I::Announced::My::Return

    use Moo;
    extends 'Welcome::To::A::World::Of::Types';

    validate_subs (
        '+goodbye_world' => [ [Str] ],
    );

    around goodbye_world = sub {
        $_[1] = 'And then disappeared again';
    };

=head1 EXPORT

=head2 validate_subs 

I'm a list, my key should be a reference to a sub routine. My value can either be an ArrayRef of ArrayRefs or a
HashRef of ArrayRefs. The ArrayRefs Must always have a first index of a Type::Tiny Object, You can optionally 
add a second index a - 1 - which will make the parameter optional. 

=head1 AUTHOR

Robert Acock, C<< <thisusedtobeanemail at gmail.com> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-moox-validatesubs at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=MooX-ValidateSubs>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc MooX::ValidateSubs

You can also look for information at:

=over 4

=item * RT: CPAN's request tracker (report bugs here)

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=MooX-ValidateSubs>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/MooX-ValidateSubs>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/MooX-ValidateSubs>

=item * Search CPAN

L<http://search.cpan.org/dist/MooX-ValidateSubs/>

=back

=head1 ACKNOWLEDGEMENTS

=head1 LICENSE AND COPYRIGHT

Copyright 2017 Robert Acock.

This program is free software; you can redistribute it and/or modify it
under the terms of the the Artistic License (2.0). You may obtain a
copy of the full license at:

L<http://www.perlfoundation.org/artistic_license_2_0>

Any use, modification, and distribution of the Standard or Modified
Versions is governed by this Artistic License. By using, modifying or
distributing the Package, you accept this license. Do not use, modify,
or distribute the Package, if you do not accept this license.

If your Modified Version has been derived from a Modified Version made
by someone other than you, you are nevertheless required to ensure that
your Modified Version complies with the requirements of this license.

This license does not grant you the right to use any trademark, service
mark, tradename, or logo of the Copyright Holder.

This license includes the non-exclusive, worldwide, free-of-charge
patent license to make, have made, use, offer to sell, sell, import and
otherwise transfer the Package with respect to any patent claims
licensable by the Copyright Holder that are necessarily infringed by the
Package. If you institute patent litigation (including a cross-claim or
counterclaim) against any party alleging that the Package constitutes
direct or contributory patent infringement, then this Artistic License
to you shall terminate on the date that such litigation is filed.

Disclaimer of Warranty: THE PACKAGE IS PROVIDED BY THE COPYRIGHT HOLDER
AND CONTRIBUTORS "AS IS' AND WITHOUT ANY EXPRESS OR IMPLIED WARRANTIES.
THE IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
PURPOSE, OR NON-INFRINGEMENT ARE DISCLAIMED TO THE EXTENT PERMITTED BY
YOUR LOCAL LAW. UNLESS REQUIRED BY LAW, NO COPYRIGHT HOLDER OR
CONTRIBUTOR WILL BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, OR
CONSEQUENTIAL DAMAGES ARISING IN ANY WAY OUT OF THE USE OF THE PACKAGE,
EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.


=cut

1; # End of MooX::ValidateSubs
