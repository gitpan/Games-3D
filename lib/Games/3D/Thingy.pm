
# Thingy - a base class for virtual and physical 3D objects

package Games::3D::Thingy;

# (C) by Tels <http://bloodgate.com/>

use strict;

use Exporter;
use Games::Object;
use vars qw/@ISA $VERSION $AUTOLOAD/;
@ISA = qw/Exporter Games::Object/;

use Games::3D::Signal
  qw/STATE_OFF SIGNAL_FLIP SIGNAL_ACTIVATE SIGNAL_DEACTIVATE/;

$VERSION = '0.02';

##############################################################################
# protected vars

  {
  my $id = 1;
  sub ID { return $id++;}
  }

##############################################################################
# methods

sub new
  {
  # create a new instance of a thingy
  my $class = shift;

  my $self = Games::Object->new( -id => ID() );
  bless $self, $class;

  $self->{active} = 1;
  $self->{parent} = undef;		# not contained in anything yet
  $self->{contains} = { };		# nothing
  
  $self->{state} = STATE_OFF;
  $self->{outputs} = {};
  
  $self->{name} = $class;
  $self->{name} =~ s/.*:://;
  $self->{name} = ucfirst($self->{name});
  $self->{name} .= ' #' . $self->{id};
  
  $self->_init(@_);
  }

sub DESTROY
  {
  my $self = shift;

  $self->destroy();	# remove the object from Games::Objects list to free
			# the memory
  }

sub AUTOLOAD
  {
  # when you do $self->name(), the AUTOLOAD steps in, checks that the
  # attribute "name" exists, and constructs a little accessor method for it.
  # This is then put into place and the next time round it will be called
  # directly.

  my $func = $AUTOLOAD;
  my $class = $func; 
  $func =~ s/.*:://;		# remove package
  $class =~ s/::[^:]+$//;	# keep package
  # return if $func eq 'DESTROY';	# we have DESTROY, so not necc. here
 
#  print "autoload for $class $func\n";
  no strict 'refs';
#  if (!$self->attr_exists($func))
#    {
#    require Carp; Carp::croak ("Attribute '$func' does not exist in $class");
#    }
  *{$class."::$func"} =
  sub { 
    my $self = shift;
    if (@_ > 0)
      {
      # more than one argument, need to modify
      $self->mod_attr( -name => $func, -value => $_[0]);
      }
    $self->attr($func);
    };
  &$func;	# call constructed accessor method using @_
  }

#sub can
#  {
#  my ($self,$name) = @_;
#  
#  print "$self,$name\n";
#  print "exists $name\n" if $self->attr_exists($name); 
#  print "second $self,$name\n";
#  return 0 if $self->attr_exists($name); 
#  print "second $self,$name\n";
#  $self->UNIVERSAL::can($self,$name);
#  }

sub new_flag
  {
  my ($self,$name,$value) = @_;

  $name =~ s/^-//;		# -name => name

  # set the initial value
  $self->{$name} = $value ? 1 : 0;

  my $class = ref($self);
  return if defined *{$class."::is_$name"};

  # create an accessor method
  no strict 'refs';
  *{$class."::is_$name"} =
  sub {
    my $self = shift;
    if (@_ > 0)
      {
      # more than one argument, need to modify
      $self->{$name} = $_[0] ? 1 : 0;
      }
    $self->{$name};
    };
  }

BEGIN { no warnings 'redefine'; }

sub is
  {
  my ($self,$flag) = @_;

  if (!exists $self->{$flag})
    {
    require Carp;
    Carp::croak ("Flag '$flag' does not exist at $self");
    }
  $self->{$flag};
  }

sub make
  {
  my ($self,$flag) = @_;

  if (!exists $self->{$flag})
    {
    require Carp;
    Carp::croak ("Flag '$flag' does not exist at $self");
    }
  $self->{$flag} = 1;
  }

sub _init
  {
  my $self = shift;
  $self;
  }

sub container
  {
  # return the container this thing is inside or undef for none
  my $self = shift;

  $self->{parent};
  }

sub insert
  {
  # insert thingy into a container
  my $self = shift;
  my $thingy = shift;

  $self->{contains}->{$thingy->{id}} = $thingy;
  $self->_update_space();
  $self;
  }

sub _update_space
  {
  }

sub remove
  {
  # remove thing from ourself
  my $self = shift;
  my $thing = shift;

  if (ref $thing)
    {
    my $c = $self->{contains};
    if (exists $c->{$thing->{id}})
      {
      delete $c->{$thing->{id}};
      $self->_update_space();	
      }
    }
  else
    {
    # try to remove us from out container
    $self->{parent}->remove($self) if (defined $self->{parent});
    }
  }

sub name
  {
  # (set and) return the name of this thingy
  my $self = shift;
  if (defined $_[0])
    {
    $self->{name} = shift;
    }
  $self->{name};
  }

sub activate
  {
  my ($self) = shift;

  return 1 if $self->{active} == 1;			 # already active
  $self->{active} = 1;
  $self->output($self,SIGNAL_ACTIVATE);
  1;
  }

sub deactivate
  {
  my ($self) = shift;

  return 0 if $self->{active} == 0;			 # already inactive
  $self->{active} = 0;
  $self->output($self,SIGNAL_DEACTIVATE);
  0;
  }

sub is_active
  {
  my ($self) = shift;

  $self->{active};
  }

sub state
  {
  my $self = shift;

  # if given a state change and we are active
  if (defined $_[0] && $self->{active} == 1)
    {
    my $old_state = $self->{state};
    if ($_[0] == SIGNAL_FLIP)
      {
      $self->{state} = -$self->{state};		# invert()
      }
    else
      {
      $self->{state} = shift;
      }
    # notify our listeners of all changes
    $self->output($self->{id},$self->{state}) if $self->{state} != $old_state;
    } 
  $self->{state};
  }

sub signal
  {
  # receive signal $sig from input $input, where $input is the sender's ID (not
  # the link(s) relaying the signal). We ignore here the input.
  my ($self,$input,$sig) = @_;

  $self->state($sig);
  }

sub add_input
  {
  # no-op for Thingies
  # my ($self,$src) = @_;
  }

sub add_output
  {
  my ($self,$dst) = @_;

  $self->{outputs}->{$dst->{id}} = $dst;
  }

sub output
  {
  # send a signal to all the outputs
  my ($self,$source,$sig) = @_;

  $source = $source->{id} if ref($source);
  my $out = $self->{outputs};
  foreach my $id (keys %{$self->{outputs}})
    {
    $out->{$id}->signal($source,$sig);			# sender id, signal	
    }
  }

sub link
  {
  # link us to another one by creating intermidiate link object and return
  # link object
  my ($self,$dst,$link) = @_;

  $self->{outputs}->{$link->{id}} = $link;
  $link->add_output($dst);			# from link to $dst
  $dst->add_input($link);
  $link->add_input($self);			# from us to link
  $link;
  }

##############################################################################
# load a class(es) and/or object(s) from a file

# eventuall the code below can be handled by Games::Object

sub DEBUG () { 0 };

sub load
  {
  my ($self,$baseclass,$file,$level) = @_;

  $file ||= '';
  my $line_nr = 0; my $hash = {};
  my $state = 0; my @ret = ();
  open my $FILE, $file or die ("Cannot read file '$file': $!");
  my $target; my $type = 0;
  while (my $line = <$FILE>)
    {
    $line_nr++;
    next if $line =~ /^#/;	# comment
    next if $line =~ /^\s*$/;	# empty line
    chomp($line);

    if ($line =~ /^\s*[\}\]]/)
      {
      # closing block sign
      die ("Unexpected '}' at file $file, line $line_nr") if $state == 0;
      $state--;
      if ($state == 0)
        {
        push @ret, $hash;
        $self->_construct($baseclass,$hash);
        }
      $target = undef;
      print "$line\n" if DEBUG;
      }
    elsif ($line =~ /^\s*([\w:]+)\s*\{\s*$/)
      {
      die ("Error, missing '}' in $file, line $line_nr") if $state != 0;
      # starting block
      print "Starting definition for '$1'\n" if DEBUG;
      $hash = { class => $1 }; $state = 1;
      }
    elsif ($line =~ /^\s*([\w]+)\s+=>\s+(.*?)\s*$/)
      {
      die ("Error, missing 'Class::Name {' in $file, line $line_nr")
       if $state == 0;
      my $res = $2; my $ta = $1;
      print " " x $state, "$ta => '$res'\n" if DEBUG;
      if ($res =~ /^\{|\[$/)
        {
        # new block
        die ("Too deeply nested in file $file, line $line_nr") if $state == 2;
        $state = 2;
        $hash->{$ta} = {} if $res =~ /^\{/;
        $hash->{$ta} = [] if $res !~ /^\{/;
        $target = $hash->{$ta};
        print "target $target ($ta)\n" if DEBUG;
        $type = 0; $type = 1 if $res =~ /^\{/;
        }
      else
        {
        $res = eval("$res");
        my $t = $hash; $t = $target if defined $target;
        if (exists $t->{$ta})
          {
          if ($type == 0)				# array or hash?
            {
            push @{$t->{$ta}}, $res;
            }
          else
            {
            $t->{$ta} = $res;
            }
          }
        else
          {
          $t->{$ta} = $res; 
          }
        }
      }
    elsif ($line =~ /^\s+(\[.*?\])\s*,\s*$/)
      {
      die ("Wrong nesting in file $file, line $line_nr") if $state != 2;
      print "$line\n" if DEBUG;
      my $res = eval("$1");
      my $t = $target;
      if ($type == 0)				# array or hash?
        {
        push @$t, $res; 
        }
      else
        {
        if (exists $t->{$1})
          {
          $t->{$1} = [ $t->{$1} ] unless ref($t->{$1}) eq 'ARRAY';
          push @{$t->{$1}}, $res;
          }
        else
          {
          $t->{$1} = $res; 
          }
        }
      }
   else
      {   
      print "Ignoring $line\n" if DEBUG;
      }
    }
  die ("Error, missing '}' in $file, line $line_nr") if $state != 0;
  close $FILE;
  \@ret;
  }

sub _construct
  {
  my ($self,$baseclass,$hash) = @_;

  my $type = 'CLASS'; $type = 'OBJECT' if exists $hash->{id};
  print "constructing $type $baseclass"."::$hash->{class}\n" if DEBUG;

  my $object = $hash->{class};

  my $class = $baseclass . '::' . $hash->{class};
  if ($type eq 'CLASS')
    {
    my $def = <<CLASS

	package $class;
	use strict;
	use vars qw/\@ISA/;
	\@ISA = qw/$baseclass/;

	sub _init
	  {
	  my \$self = shift;

	  my \$args = \$_[0];
	  \$args = { \@_ } unless ref \$args eq 'HASH';

	  \$self\->SUPER::_init(\@_);

	  \$self;
	  }

CLASS
    ;
    print "Using '$def'\n" if DEBUG;
    eval ($def);
    } 
  else
    {
    print "new\n" if DEBUG;
    $object = $class->new( $hash );
    print "result $object\n" if DEBUG;
    }
  print "Done\n" if DEBUG;
  $object;
  }

1;

__END__

=pod

=head1 NAME

Games::3D::Thingy - base class for virtual and physical 3D objects

=head1 SYNOPSIS

	package Games::3D::MyThingy;

	use Games::3D::Thingy;
	require Exporter;

	@ISA = qw/Games::3D::Thingy/;

	sub _init
	  {
	  my ($self) = shift;

	  # init with arguments from @_
	  }

	# override or add any method you need

=head1 EXPORTS

Exports nothing on default. Can export signal and state names like:

	SIGNAL_ON SIGNAL_UP SIGNAL_OPEN
	SIGNAL_OFF SIGNAL_CLOSE SIGNAL_DOWN
	SIGNAL_FLIP

	STATE_ON STATE_UP STATE_OPEN
	STATE_OFF STATE_CLOSED STATE_DOWN
	STATE_FLIP

=head1 DESCRIPTION

This package provides a base class for "things" in Games::3D. It should
not be used on it's own.

=head1 METHODS

These methods need not to be overwritten:

=over 2

=item new()

	my $thingy = Games::3D::Thingy->new(@options);
	my $thingy = Games::3D::Thingy->new( $options ); # hash ref w/ options

Creates a new thing.

=item container()

	print $thing->container();

Return the container this thing is contained in or undef for none.

=item insert()

	$thing->insert($other_thing);

Insert the other thing into thing, if possible. Returns undef for not
possible (thing does not fit, container full etc), or C<$thing>.

=item remove()

	$container = $thing->inside();			   # get container
	$container->remove($thing) if defined $container;  # remove now

	# or easier:
	$thing->remove();		# if inside container, remove me	

Removes the thing from it's container.

See also L<insert()>.

=item is_active()

	$thingy->is_active();

Returns true if the thingy is active, or false for inactive.

=item activate()

	$thingy->activate();

Set the thingy to active. Newly created ones are always active.

=item deactivate()
	
	$thingy->deactivate();

Set the thingy to inactive. Newly created ones are always active.

Inactive thingies ignore signals or state changes until they become active
again.

=item id()

Return the thingy's unique id.

=item name()

	print $thingy->name();
	$thingy->name('new name');

Set and/or return the thingy's name. The default name is the last part of
the classname, uppercased, preceded by '#' and the thingy's unique id.

=item is()

	$thingy->is('dead');

Returns the flag as 1 or 0. The argument is the flag name.

=item make()

	$thingy->make($flag);
	$thingy->make('dead');

Sets the flag named $flag to 1.

=item is_$name()

	print "dead!" if $thingy->is_dead();
	$thingy->is_dead(0);			# let it live again

Sets the flag named $name to 1 or 0, if no argument is given, returns simple
the state of the flag. Of course, the flag has to exist.

=item state

	print "ON " if $thingy->state() == STATE_ON;
	$thingy->state(STATE_OFF);
	$thingy->state(STATE_FLIP);

Returns the state of the thing. An optional argument changes the object's
state to the given one, and sends the newly set state to all outputs (see
L<add_output()>.

=item signal()

        $link->signal($input_id,$signal);
        $link->signal($self,$signal);

Put the signal into the link's input. The input can either be an ID, or just
the object sending the signal. The object needs to be linked to the input
of the link first, by using L<link()>, or L<add_input()>.

=item add_input()

        $thingy->add_input($object);

Registers C<$object> as a valid input source for this object. Does nothing
for Thingies and their subclasses, they simple receive and handle signals from
everyone. Important for Games::3D::Link, though.

Do not forget to also register the link C<$link> as output for C<$object> via
C<$object->add_output($link);>. It is easier and safer to just use
link() from Games::3D::Link, though.

=item add_output()

        $thingy->add_output($destination);

Registers C<$object> as an output of this object, e.g. each signal the object
generateds will also be sent to the destinationt.

If the target of the output is not a Thingy or a subclass, but a
Games::3D::Link object, do not forget to also register the
object C<$thingy> as input for C<$destination> via
C<$destination->add_input($object);>.

In short: If you want to simple link two objects, just register the second
object as output on the first. If you want to link two objects (ore even more)
in more complex ways, use L<link()>.

=item link()

	$link = $object->link($different_object);

Links the object to a different object by creating an intermediate link
object. Returns the reference to that link object.

It is possible to link the object to itself, however, this makes only sense
when using delayed, inverted, or otherwise limited (like one-shot) links.
Otherwise you create a signal endless-loop, which will take an eternity or
two to resolve.

Here is an example, that turns the object automatically off two seconds after
it was turned on:
	
	$link = $object->link($object);
	$link->delay(2000);
	$link->fixed_output(SIGNAL_OFF);
	$link->fixed_input(SIGNAL_ON);

Note that without that last line, turning C<$object> would cause another 
off signal to be send after two more seconds, which is not neccessary. Here
is an example of an object that flips it self on and off in randomized 2
second intervalls:

	$link = $object->link($object);
	$link->delay(2000,500);
	$link->fixed_output(SIGNAL_FLIP);

Note that each flip signal will start the next flip signal.

=item output()

  	$thingy->output($source,$signal);

Sends the signal C<$signal> to all the outputs that were registered with that
thingy and tells the receiver that the signal came from C<$source>. Example:

	$thingy->output($thingy->{id}, SIGNAL_ON);

=item load()

	$thingy->load($baseclass,$file,$difficulty_level);

This loads a file and reads the class and object definitions in this file.
The classes and objects are then constructed as subcalsses of $baseclass
as they are read in. This basically pullsin the entire object hirarchy plus
all the objects, although it make sense to keep them in two seperate files
and load first the hirarchy, then the objects:

	$thingy->load('Games::3D::Object','hirarchy.txt');
	$world = $thingy->load('Games::3D::Object','world.txt');
	$level = $thingy->load('Games::3D::Object','level00.txt',1);

The first line loads the hirachy (this doesn't contain any objects, so we
discard the return value, although it might be safer to check for stray
objects), then loads all the basic world objects (like: player, camera,
quests etc and constructs them), and then it loads level 0, and constructs
all the objects from there. The difficulty level is set to 1, meaning any
object that is defined not to appear in level 1 (like: 1 means C<Easy>, and
a certain blocking door is not there in C<Easy>, but only in C<Hard> and
C<Expert>) will not be constructed in the first place. This is faster than
constructing them, and then throwing them away.

=item _construct()

	$thingy->_construct($baseclass,$hash);

This is called by L<load()> for each object or class to be constructed.

=back

=head1 AUTHORS

(c) 2002, 2003, Tels <http://bloodgate.com/>

=head1 SEE ALSO

L<Games::3D>, L<SDL:App::FPS>, L<SDL::App> and L<SDL>.

=cut

