
# World - contains everything in the game world

package Games::3D::World;

# (C) by Tels <http://bloodgate.com/>

use strict;

require Exporter;
use vars qw/@ISA @EXPORT_OK $VERSION/;
@ISA = qw/Exporter/;

$VERSION = '0.01';

##############################################################################
# protected vars

  {
  my $id = 1;
  sub ID { return $id++;}
  sub reset_ID { $id = 1; }
  }

##############################################################################
# methods

sub new
  {
  # create a new world
  my $class = shift;
 
  my $self = bless {}, $class;

  $self->{things} = { };
  $self->{render} = { };
  $self->{thinks} = { };
  reset_ID();

  if (@_ == 2)
    {
    $self->load_templates($_[0]);
    $self->load_from_file($_[1]);
    }

  $self->{time} = 0;

  $self;
  }

sub load_from_file
  {
  my ($self,$file) = @_;

  $self->{file} = $file; 
  $self->{things} = { };
  reset_ID();

  $self;
  }

sub load_templates
  {
  my ($self,$file) = @_;
 
  $self;
  }

sub save_templates
  {
  my ($self,$file) = @_;
 
  $self;
  }

sub save_to_file
  {
  my ($self,$file) = @_;
 
  $self->{file} = $file; 
  $self;
  }

sub reload
  {
  my $self = shift;

  $self->load_from_file($self->{file});
  }

sub register
  {
  # register an object with yourself
  my ($self,$obj) = @_;

  $obj->{id} = ID();				# get it a new ID
  $self->{things}->{$obj->{id}} = $obj;   	# store it
  $self->{things}->{_world} = $self;		# give thing access to us
  if ($obj->{visible})
    {
    $self->{render}->{$obj->{id}} = $obj;   	# store it
    }
  if ($obj->{think_time} != 0)
    {
    $self->{think}->{$obj->{id}} = $obj;   	# store it
    }

  $self;
  }

sub unregister
  {
  # should ONLY be called via $thing->{_world}->unregister($thing) !
  my ($self,$thing) = @_;

  my $id = $thing->{id};
  delete $self->{render}->{$id};
  delete $self->{things}->{$id};
  # tricky, what happens if called inside update()?  
  delete $self->{think}->{$id};
 
  $self;
  }

sub things
  {
  # get count of things
  my ($self) = @_;

  scalar keys %{$self->{things}};
  }

sub thinkers
  {
  # get count of thinking things
  my ($self) = @_;

  scalar keys %{$self->{think}};
  }

sub update
  {
  my ($self,$now) = @_;

  $self->{time} = $now;				# cache time
  foreach my $id (keys %{$self->{think}})
    {
    my $thing = $self->{think}->{$id};
    if ($thing->{next_think} >= $now)
      {
      $thing->think($now);
      }
    # if the thing is in transition between states, let it update itself
    $thing->update($now) if $thing->{state_endtime} != 0;

    # XXX TODO: does not handle things that no longer want to think()
    }
  $self;
  }

sub time
  {
  my $self = shift;

  $self->{time};
  }

sub render
  {
  my ($self,$now,$callback) = @_;

  foreach my $id (keys %{$self->{render}})
    {
    &$callback ( $now, $self->{render}->{$id} );
    }
  $self;
  }

sub id { 0; }

1;

__END__

=pod

=head1 NAME

Games::3D::World - contains all things in the game world

=head1 SYNOPSIS

	use Games::3D::World;

	# construct world from templates file and level file
	my $level = Games::3D::World->new( $templates, $file);

	# load the same level again
	$level->reload();

	# create a new world from sratch:
	my $world = Games::3D::World->new();
	$world->load_templates( $templates_file );

	# add some thing directly
        $world->create ( $thing_class );

	# create another one
	my $thing = Games::3D::Thingy->new( ... );
	$thing->visible(1);
	$thing->think_time(100);
	# and make our world contain it
	$world->register($thing);
	
	# save the world
	$world->save_to_file();

	# foreach frame to render:
	while ($not_quit)
	  {
	  # other code like user input handling here
	  ...
	  # update the world with the current frame time:
	  $world->update( $now );
	  ...
	  # then let world call $callback for each visible object
	  $world->render( $now, $callback );
	  # other drawing code here
	  ...
	  }

=head1 EXPORTS

Exports nothing on default.

=head1 DESCRIPTION

=head1 METHODS

=over 2

=item new()

	my $world = Games::3D::World->new( templates => $file );

Creates a new game world/level and reads in the templates from C<$file>.

=item load_from_file()

	$world->load_from_file( $file );

Load the game world/level from a file, replacing all existing data.

=item load_from_file()

	$world->load_templates( $templates_file );

Loads the templates from a file.

=item save_to_file()

	my $rc = $world->save_to_file( $file );

Save game world/level to a file, returns undef for success, otherwise
ref to error message.

=item save_templates()

	my $rc = $world->save_templates( $file );

Save game world/level to a file, returns undef for success, otherwise
ref to error message.

=head1 AUTHORS

(c) 2004 Tels <http://bloodgate.com/>

=head1 SEE ALSO

L<Games::3D::Thingy>, L<Games::3D::Link>, L<Games::Irrlicht>.

=cut

