
# Point - a base class for 3dimensional objects (well, it's a point)

package Games::3D::Point;

# (C) by Tels <http://bloodgate.com/>

use strict;

use Exporter;
use vars qw/@ISA $VERSION/;
@ISA = qw/Exporter/;

$VERSION = '0.01';

##############################################################################
# methods

sub new
  {
  # create a new instance of a point
  my $class = shift;
  my $self = {}; bless $self, $class;

  $self->_init(@_);
  }

sub _init
  {
  # to be overwritten in subclasses
  my $self = shift;

  my $args = $_[0];
  $args = { @_ } unless ref $args eq 'HASH';

  $self->{x} = $args->{x} || 0;
  $self->{y} = $args->{y} || 0;
  $self->{z} = $args->{z} || 0;

  $self;
  }

sub x
  {
  # return X
  my $self = shift;
  $self->{x} = shift if defined $_[0];
  $self->{x};
  }

sub y
  {
  # return Y
  my $self = shift;
  $self->{y} = shift if defined $_[0];
  $self->{y};
  }

sub z
  {
  # return Z
  my $self = shift;
  $self->{z} = shift if defined $_[0];
  $self->{z};
  }

sub pos
  {
  # return X,Y,Z
  my $self = shift;

  $self->{x} = $_[0] if defined $_[0];
  $self->{y} = $_[1] if defined $_[1];
  $self->{z} = $_[2] if defined $_[2];
  ($self->{x},$self->{y},$self->{z});
  }

1;

__END__

=pod

=head1 NAME

Games::3D::Point - a point in 3D space

=head1 SYNOPSIS

	use Games::3D::Point;

	my $origin = Games::3D::Point->new();

	my $point = Games::3D::Point->new ( x => 1, y => 0, z => -1);

=head1 EXPORTS

Exports nothing on default.

=head1 DESCRIPTION

This package provides a base class for things in 3D space.

=head1 METHODS

These methods need not to be overwritten:

=over 2

=item new()

	my $point = Games::3D::Point->new( $arguments );

Creates a new point. The arguments are x,y and z.

=item id()

Return the point's unique id.

=item x()

	print $point->x();
	$point->x(123);
	
Set and return or just return the point's X coordinate.

=item y()

	print $point->y();
	$point->y(123);
	
Set and return or just return the point's Y coordinate.

=item z()

	print $point->z();
	$point->z(123);
	
Set and return or just return the point's Z coordinate.

=item pos()

	print join (" ", $point->center());
	$point->pos(123,456,-1);		# set X,Y and Z
	$point->pos(undef,undef,1);		# set only Z
	
Set and return or just return the point's coordinates.

=back

=head1 AUTHORS

(c) 2003, Tels <http://bloodgate.com/>

=head1 SEE ALSO

L<SDL:App::FPS>, L<SDL::App> and L<SDL>.

=cut

