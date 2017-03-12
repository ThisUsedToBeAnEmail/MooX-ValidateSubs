package MooX::ValidateSubs;

use strict;
use warnings;

use MooX::ReturnModifiers;
use Params::Validate qw/validate_with validate_pos/;

our $VERSION = '0.01';

use constant SCALAR    => ( type => 1 );
use constant ARRAYREF  => ( type => 2 );
use constant HASHREF   => ( type => 4 );
use constant CODEREF   => ( type => 8 );
use constant GLOB      => ( type => 16 );
use constant GLOBREF   => ( type => 32 );
use constant SCALARREF => ( type => 64 );
use constant UNKNOWN   => ( type => 128 );
use constant UNDEF     => ( type => 256 );
use constant OBJECT    => ( type => 512 );
use constant OPT       => ( optional => 1 );

sub import {
    my $target    = caller;
    my %modifiers = return_modifiers($target);

    {
        no strict 'refs';
        ${"${target}::"}{$_} = ${ __PACKAGE__ . "::" }{$_}
          foreach (
            qw/SCALAR ARRAYREF HASHREF CODEREF GLOB GLOBREF SCALARREF UNKNOWN UNDEF OBJECT/
          );
    }

    my $modify_subs = sub {
        my @attr = @_;
        while (@attr) {
            my @names = ref $attr[0] eq 'ARRAY' ? @{ shift @attr } : shift @attr;
            my %spec = %{ shift @attr };
            for (@names) {
                $modifiers{before}->(
                    $_, sub { shift; create_validate_subs( $spec{params}, @_ ) }
                ) if $spec{params};
            }
        }

    };

    { no strict 'refs'; *{"${target}::validate_subs"} = $modify_subs; }

    return 1;
}

sub create_validate_subs {
    my ($spec) = shift;

    if ( ref $spec eq 'ARRAY' ) {
        my @pos = grep { $_ =~ /\d/ } @{$spec};
        return validate_pos( @_, @pos );
    }
    return validate_with( params => \@_, spec => $spec, stack_skip => 3 );
}

1;

__END__

=head1 NAME

MooX::ValidateSubs - The great new MooX::ValidateSubs!

=head1 VERSION

Version 0.01

=cut

=head1 SYNOPSIS
    
    package Im::Such::A::Defensive::Programmer;

    use Moo;
    use MooX::ValidateSubs;

    validate_subs (
        [qw/hello_world different_but_accept_the_same/] => {
            params => {
                one   => { SCALAR, default => 'I use params validate...' },
                two   => { ARRAYREF },
                three => { HASHREF, OPT },
            },
        },
        a_list => {
            params => [ SCALAR, ARRAYREF, HASHREF ],
        }
    );

    sub hello_world { 
        my ($self, %args) = @_;
        
        # yay now I know these exist
        # $args{one} 
        # $args{two} 
        # $args{three} 
    }
    
    sub different_but_accept_the_same {
        my ($self, %args) = @_;

    }

    sub a_list {
        my ($scalar, $arrayref, $hashref) = @_;

    }

=head1 EXPORT

=head2 validate_subs 

=head2 Constants

=head3 SCALAR

(type => 1)

=head3 ARRAYREF

(type => 2)

=head3 HASHREF

(type => 4)

=head3 CODEREF

(type => 8)

=head3 GLOB

(type => 32)

=head3 GLOBREF

(type => 32)

=head3 SCALARREF

(type => 64)

=head3 UNKNOWN

(type => 128)

=head3 UNDEF

(type => 256)

=head3 OBJECT

(type => 512)

=head3 OPT

( optional => 1 )

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
