
# Template - describe an object class and it's keys/settings

package Games::3D::Template;

# (C) by Tels <http://bloodgate.com/>

use strict;

require Exporter;
use vars qw/@ISA $VERSION/;
@ISA = qw/Exporter/;

$VERSION = '0.01';

##############################################################################
# protected vars

# Templates have their own unique IDs

  {
  my $id = 1;
  sub ID { return $id++;}
  }

##############################################################################
# methods

sub new
  {
  # create a new Template
  my $class = shift;

  my $args = $_[0];
  $args = { @_ } unless ref($_[0]) eq 'HASH';

  my $self = { id => ID() };
  bless $self, $class;

  $self->{valid} = { 
    name => 'STRING=',
    id => 'INT=',
    state => 'INT=0',
    states => 'ARRAY=-1,1',
    visible => 'BOOL=false',
    active => 'BOOL=true',
    think_time => 'INT=0',
    next_think => 'INT=0',
    inputs => 'ARRAY=0',
    outputs => 'ARRAY=0',
  };
  $self->{class} = $args->{class} || 'Games::3D::Thingy';
  $self;
  }

sub class
  {
  my $self = shift;
  $self->{class};
  }

sub id
  {
  my $self = shift;

  $self->{id};
  }

sub init_thing
  {
  # init all fields in a thing from the blueprint
  my ($self,$thing) = @_;

  foreach my $key (keys %{$self->{valid}})
    {
    next if exists $thing->{key};
    my ($type,$default) = split /=/, $self->{valid}->{$key};
    if ($type eq 'ARRAY')
      {
      $thing->{$key} = [ split /,/, $default ];
      }
    elsif ($type eq 'BOOL')
      {
      $thing->{$key} = $default =~ /^(false|off|no)$/i ? undef : 1;
      }
    else
      {
      $thing->{$key} = $default;
      }
    }
  }

sub validate
  {
  # check whether a given key is allowed, and whether his data confirms to the
  # blueprint
  my $self = shift;
  my $obj = shift;

  my $class = $self->{class};

  return 
   "Object class '". ref($obj)."' does not match template class '".$class."'"
    unless $class eq ref($obj);

  return $self->validate_key($obj, $_[0]) if (@_ > 0);

  foreach my $key (keys %$obj)
    {
    next if $key =~ /^_/;				# skip internals
    my $rc = $self->validate_key($obj, $key);
    return $rc if defined $rc;	# error?
    } 
  return;			# okay
  }

sub validate_key
  {
  my ($self,$obj,$key) = @_;
  
  return "Invalid key '$key' on object " . ref($obj) . " #" . ($obj->{id}||-1)
    unless exists $self->{valid}->{$key};

  return;			# okay
  }

sub from_string
  {
  my ($str) = shift;

  my @lines = split /\n/, $str;
 
  my ($name,@objects,$line);
  my $linenr = 0;
  while (@lines > 0)
    {
    $line = shift @lines; $linenr++;
    next if $line =~ /^\s*(#|$)/;       		# skip comments

    return ("Invalid format in string: '$line' in line $linenr")
      unless ($line =~ /\s*([\w:]+)\s*\{/);		# declaration: Class {

    my $class = $1;
    return "Undefined class in line $linenr" if ($class || '') eq '';

    my $self = bless { }, $class;			# emulate ->new();
    $line = shift @lines; $linenr++;
    while ($line !~ /^\s*\}/)
      {
      if ( $line =~ m/\s*([\w-]+)\s*=>?\s*\{\s*$/)	# "hash => {"	
	{
	$name = $1 || return ("Empty hash name in line $linenr\n");
	$self->{$name} = {};
        $line = shift @lines; $linenr++;
    	while ($line !~ /^\s*\}/)
	  {
 	  # var => val, var = val
          return "Invalid line format in line $linenr\n" unless
           $line =~
	    m/\s*([\w-]+)\s*=>?\s*(['\"])?(.*?)\2?\s*$/;
	  my $n = $1 || return ("Empty name in line $linenr\n");
	  return ("Field '$n' already defined in hash '$name' in '$class' in line $linenr")
	   if exists $self->{$name}->{$n};
	  $self->{$name}->{$n} = $3;
          $line = shift @lines; $linenr++;
	  }
	}
      else
	{
        return "Invalid line format in line $linenr\n" unless
         $line =~
	  m/\s*([\w-]+)\s*=>?\s*(['\"])?(.*?)\2?\s*$/;	# var => val, var = val
	$name = $1 || return ("Empty name in line $linenr\n");
	return ("Field '$name' already defined in '$class' in line $linenr")
         if exists $self->{$name};
	$self->{$name} = $3;
        $line = shift @lines; $linenr++;
	}
      }
    $line = shift @lines; $linenr++;
    # one object done
    push @objects, $self;
    }
  wantarray ? @objects : $objects[0];
  }

sub as_string
  {
  my $self = shift;

  my $txt = ref($self) . " {\n";
  foreach my $k (sort keys %$self)
    {
    next if $k =~ /^_/;					# skip internal keys
    my $v = $self->{$k};				# get key
    next if !defined $v;				# skip empty
    if (ref($v) eq 'HASH')
      {
      $v = "{\n";
      foreach my $key (sort keys %{$self->{$k}})
	{
        my $vi = $self->{$k}->{$key};
        $vi = $vi->as_string() if ref($v);
        $v .= "    $key = $vi\n";
	}
      $v .= "  }";
      }
    else
      {
      $v = '"'.$v.'"' if $v =~ /[^a-z0-9_\.,'"+-]/;
      next if $v eq '';
      }
    $txt .= "  $k = $v\n";
    }
  $txt .= "}\n";
  }

sub add_key
  {
  my ($self,$key,$data) = @_;

  $self->{valid}->{$key} = $data;
  $self;
  }

sub keys
  {
  my ($self) = @_;

  scalar keys %{$self->{valid}};
  }

1;

__END__

=pod

=head1 NAME

Games::3D::Template - describe an object class and it's keys/settings

=head1 SYNOPSIS

	use Games::3D::Template;
	use Games::3D::Thingy;

	Games::3D::Template->from_string($string);

	Games::3D::Thingy->new( ... );

	# check entire object
	$template->validate($thingy);

	# check only one key
	$template->validate_key($thingy,'name');

=head1 EXPORTS

Exports nothing on default.

=head1 DESCRIPTION

This package provides a validation class for "things" in Games::3D. It defines
what the valid keys are, and what their data should look like, and also how
this data should be transformed into strings and back to internal data (for
instance when saving/loading data).

=head1 METHODS

=over 2

=item new()

	my $template = Games::3D::Template->new();

Creates a new, empty template.

=item class()

	$template->class();

Return the class of objects this template describes. For instance,
'Games::3D::Foo::Bar'.

=item validate()

	$template->validate($thingy);

Validate the entire object C<$thingy>, e.g see if it still confirms to the
template.

Returns undef for ok, otherwise error message.

=item validate_key()

	$template->validate_key($thingy, $key);

Validate the key C<$key> from object C<$thingy>, e.g see if it still confirms to
the template.

Returns undef for ok, otherwise error message.

=item id()

Return the templates' unique id. They are independant from all other IDs.

=back

=head1 AUTHORS

(c) 2004 Tels <http://bloodgate.com/>

=head1 SEE ALSO

L<Games::3D>, L<Games::Irrlicht>.

=cut

