
# Living - a base class for 3D physical, living objects (NPCs etc)

package Games::3D::Living;

# (C) by Tels <http://bloodgate.com/>

use strict;

use Games::3D::Physical;
use vars qw/@ISA $VERSION/;

@ISA = qw/Games::3D::Physical/;

$VERSION = '0.01';

##############################################################################
# methods

sub _init
  {
  # to be overwritten in subclasses
  my $self = shift;

  my $args = $_[0];
  $args = { @_ } unless ref $args eq 'HASH';

  $self->SUPER::_init($args);

  $self->new_attr(
        -name => "health",
        -type => 'int',
        -value => $args->{health} || 100,
        -minimum => 0,
  );
  $self->new_flag ( "dead", $args->{dead} );
  $self->new_flag ( "knocked_out", $args->{knocked_out} );

  $self;
  }

1;

__END__

=pod

=head1 NAME

Games::3D::Living - an 3D objcet which lives (or is dead)

=head1 SYNOPSIS

	use Games::3D::Living;

	my $object = Games::3D::Physical->new( health => 45 );
	if ($object->is_dead()) { ... }

=head1 EXPORTS

Exports nothing on default.

=head1 DESCRIPTION

This package provides a base class for shapes/areas in 3D space.

=head1 METHODS

It features all the methods of Games::3D::Area (namely: new(), _init(),
x(), y(), z(), width(), length(), height(), size() and center()) plus has the
following attributes:

=over 2

=item is_dead()

	print "It's dead, Jim." if $object->is_dead();
	
Returns true if the object is dead.

=back

=head1 AUTHORS

(c) 2003, Tels <http://bloodgate.com/>

=head1 SEE ALSO

L<Games::3D::Area>, L<Games::3D::Thingy> as well as
L<SDL:App::FPS>, L<SDL::App> and L<SDL>.

=cut

