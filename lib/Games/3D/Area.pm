
# Area - a base class for 3D objects (well, it's has a shape and size)

package Games::3D::Area;

# (C) by Tels <http://bloodgate.com/>

use strict;

require Exporter;
use Games::3D::Point;
use vars qw/@ISA $VERSION @EXPORT_OK/;

@ISA = qw/Exporter Games::3D::Point/;
@EXPORT_OK = qw/GAMES_3D_CUBE GAMES_3D_SPHERE/;

$VERSION = '0.01';

##############################################################################
# constants

sub GAMES_3D_CUBE () { 0; }
sub GAMES_3D_SPHERE () { 1; }

##############################################################################
# methods

sub _init
  {
  # to be overwritten in subclasses
  my $self = shift;

  my $args = $_[0];
  $args = { @_ } unless ref $args eq 'HASH';

  # save the call to SUPER::_init()
  #$self->SUPER::_init($args);

  ($self->{x},$self->{y},$self->{z}) = @{$args->{pos}} if ref($args->{pos});
  ($self->{w},$self->{l},$self->{h}) = @{$args->{size}} if ref($args->{size});

  $self->{x} ||= $args->{x} || 0;
  $self->{y} ||= $args->{y} || 0;
  $self->{z} ||= $args->{z} || 0;
  
  $self->{w} ||= abs($args->{xs} || $args->{w} || $args->{width} || 1);
  $self->{l} ||= abs($args->{ys} || $args->{l} || $args->{length} || 1);
  $self->{h} ||= abs($args->{zs} || $args->{h} || $args->{height} || 1);
  
  $self->{rx} ||= abs($args->{rx} || 0);
  $self->{ry} ||= abs($args->{ry} || 0);
  $self->{rz} ||= abs($args->{rz} || 0);

  $self->{shape} = $args->{shape} || GAMES_3D_CUBE;

  $self;
  }

sub width
  {
  # return size in X
  my $self = shift;
  $self->{w} = shift if defined $_[0];
  $self->{w};
  }

sub length
  {
  # return size in Y
  my $self = shift;
  $self->{l} = shift if defined $_[0];
  $self->{l};
  }

sub shape
  {
  # return shape
  my $self = shift;
  $self->{shape} = shift if defined $_[0];
  $self->{shape};
  }

sub height
  {
  # return size in Z
  my $self = shift;
  $self->{h} = shift if defined $_[0];
  $self->{h};
  }

sub size
  {
  # return size in X,Y,Z
  my $self = shift;

  $self->{w} = $_[0] if defined $_[0];
  $self->{l} = $_[1] if defined $_[1];
  $self->{h} = $_[2] if defined $_[2];
  ($self->{w},$self->{l},$self->{h});
  }

sub rotation
  {
  # return rotation in X,Y,Z axes
  my $self = shift;

  $self->{rx} = $_[0] if defined $_[0];
  $self->{ry} = $_[1] if defined $_[1];
  $self->{rz} = $_[2] if defined $_[2];
  ($self->{rx},$self->{ry},$self->{rz});
  }

1;

__END__

=pod

=head1 NAME

Games::3D::Area - an area (or space) in 3D space

=head1 SYNOPSIS

	use Games::3D::Area;

	my $origin = Games::3D::Area->new();

	my $shape = Games::3D::Area->new ( 
		x => 1, y => 0, z => -1,
		w => 123, l => 9, height => 46 );

=head1 EXPORTS

Exports nothing on default. Can export on request:

	GAME_3D_CUBE
	GAME_3D_SPHERE

=head1 DESCRIPTION

This package provides a base class for shapes/areas in 3D space.

=head1 METHODS

It features all the methods of Games::3D::Point (namely: new(), _init(),
x(), y(), z() and pos()) plus:

=over 2

=item width()

	print $area->width();
	$area->width(123);
	
Set and return or just return the area's width (size along the X axis).

=item length()

	print $area->length();
	$area->length(123);
	
Set and return or just return the area's length (size along the Y axis).

=item height()

	print $area->height();
	$area->height(123);
	
Set and return or just return the area's height (size along the Z axis).

=item size()

	print join (" ", $area->size());
	$area->size(123,456,-1);		# set X,Y and Z
	$area->size(undef,undef,1);		# set only Z
	
Set and return or just return the area's size along the three axes.

=item rotation()

	print join (" ", $area->rotation());
	$area->rotation(0.5,1,-1);		# set X,Y and Z
	$area->rotation(undef,undef,1);		# set only Z
	
Set and return or just return the area's rotation around the X, Y and
Z axis, respectively.

=back

=head1 AUTHORS

(c) 2003, Tels <http://bloodgate.com/>

=head1 SEE ALSO

L<Games::3D::Point> as well as L<SDL:App::FPS>, L<SDL::App> and L<SDL>.

=cut

