
# Signal - define the signal names and constants

package Games::3D::Signal;

# (C) by Tels <http://bloodgate.com/>

use strict;

use Exporter;
use vars qw/@ISA @EXPORT_OK $VERSION/;
@ISA = qw/Exporter/;
@EXPORT_OK = qw/ 
  SIGNAL_ON SIGNAL_UP SIGNAL_OPEN
  SIGNAL_OFF SIGNAL_CLOSE SIGNAL_DOWN
  SIGNAL_FLIP
  SIGNAL_LEFT SIGNAL_RIGHT
  STATE_ON STATE_UP STATE_OPEN
  STATE_OFF STATE_CLOSED STATE_DOWN
  SIGNAL_ACTIVATE SIGNAL_DEACTIVATE
  STATE_FLIP
  SIGNAL_LEVEL_WON
  SIGNAL_LEVEL_LOST
  invert
  /;

$VERSION = '0.01';

##############################################################################
# constants

sub SIGNAL_ON () { 1; }
sub SIGNAL_OPEN () { 1; }
sub SIGNAL_UP () { 1; }
sub SIGNAL_RIGHT () { 1; }

sub SIGNAL_OFF () { -1; }
sub SIGNAL_CLOSE () { -1; }
sub SIGNAL_DOWN () { -1; }
sub SIGNAL_LEFT () { -1; }
sub SIGNAL_FLIP () { 0; }
sub STATE_FLIP () { 0; }

sub STATE_ON () { 1; }
sub STATE_OPEN () { 1; }
sub STATE_UP () { 1; }
sub STATE_RIGHT () { 1; }
sub STATE_OFF () { -1; }
sub STATE_CLOSED () { -1; }
sub STATE_DOWN () { -1; }
sub STATE_LEFT () { -1; }

sub SIGNAL_ACTIVATE () { 2; }
sub SIGNAL_DEACTIVATE () { -2; }
sub SIGNAL_LEVEL_WON () { 3; }
sub SIGNAL_LEVEL_LOST () { -3; }

##############################################################################
# methods

sub invert
  {
  shift if ref($_[0]) || $_[0] eq 'Games::3D::Signal';
  my $signal = shift;

  $signal = -$signal;
  }

1;

__END__

=pod

=head1 NAME

Games::3D::Signal - export the signal and state names

=head1 SYNOPSIS

	use Games::3D::Signal qw/SIGNAL_ON SIGNAL_OFF/;

	$signal = Games::3D::Signal->invert($signal) if $signal == SIGNAL_ON;

=head1 EXPORTS

Exports nothing on default. Can export signal and state names like:

	SIGNAL_ON SIGNAL_UP SIGNAL_OPEN
	SIGNAL_OFF SIGNAL_CLOSE SIGNAL_DOWN
	SIGNAL_FLIP
	SIGNAL_LEFT SIGNAL_RIGHT

	STATE_ON STATE_UP STATE_OPEN
	STATE_OFF STATE_CLOSED STATE_DOWN
	STATE_LEFT STATE_RIGHT

	SIGNAL_LEVEL_WON
	SIGNAL_LEVEL_LOST

=head1 DESCRIPTION

This package just exports the signal and state names on request.

=head1 METHODS

=over 2

=item invert()

	$signal = Games::3D::Signal->invert($signal);

Invert a signal when the signal is SIGNAL_ON or SIGNAL_OFF (or one of it's
aliases like RIGHT, LEFT, UP, DOWN, CLOSE, or OPEN),

=back

=head1 AUTHORS

(c) 2002, 2003, Tels <http://bloodgate.com/>

=head1 SEE ALSO

L<SDL:App::FPS>, L<SDL::App> and L<SDL>.

=cut

