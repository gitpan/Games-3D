
# Marker - a point in 3D space that marks a place

package Games::3D::Marker;

# (C) by Tels <http://bloodgate.com/>

use strict;

require Exporter;
use Games::3D::Point;
use Games::3D::Thingy;
use vars qw/@ISA $VERSION/;

@ISA = qw/Games::3D::Thingy Games::3D::Point Exporter/;

$VERSION = '0.01';

##############################################################################
# methods

sub _init
  {
  # to be overwritten in subclasses
  my $self = shift;

  my $args = $_[0];
  $args = { @_ } unless ref $args eq 'HASH';

  Games::3D::Point::_init($self,$args);

  $self;
  }

1;

__END__

=pod

=head1 NAME

Games::3D::Marker - marks a point in the 3D world

=head1 SYNOPSIS

	use Games::3D::Marker;

	my $goal = Games::3D::Marker->new( name => 'Goal' );

=head1 EXPORTS

Exports nothing on default.

=head1 DESCRIPTION

This package provides a class ffor marking certain points in 3D space.

Will probably gone from the distribution because the object hierarchy can model
it without any additional code.

=head1 METHODS

It is based on Games::3D::Point and Games::3D::Thingy, so it features all the
methods of these two plus:

=over 2

=back

=head1 AUTHORS

(c) 2003, Tels <http://bloodgate.com/>

=head1 SEE ALSO

L<Games::3D::Point>, L<Game::3D::Thingy> as well as
L<SDL:App::FPS>, L<SDL::App> and L<SDL>.

=cut

