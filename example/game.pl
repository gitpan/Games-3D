#!/usr/bin/perl -w

BEGIN { $| = 1; }
use lib '../lib';
use strict;

##############################################################################
# the world/object container

package Games::3D::MyWorld;

use Games::3D::Thingy;
use strict;
use vars qw/@ISA/;

use SDL::App::FPS::Group;

@ISA = qw/Games::3D::Thingy/;

sub _init
  {
  my ($self,$args) = @_;
  $self;
  }

sub load_hirarchy
  {
  my ($self,$classes) = @_;

  $self->{classes} = $self->load('Games::3D::Object',$classes);
  $self;
  }
  
sub load_level
  {
  my ($self,$level,$difficulty) = @_;

  $self->{level} = $self->load('Games::3D::Object',$level,$difficulty);
  $self->{objects} = SDL::App::FPS::Group->new();
  $self->{objects}->add( @{$self->{level}} );

  use Data::Dumper;
  foreach my $o (@{$self->{level}})
    {
    $o->{world} = $self;
    print Dumper($o);
    }
  }

sub find_target
  {
  my ($self,$name) = @_;

  $self->{objects}->named(qr/^$name/i);
  }

sub kill
  {
  my ($self) = shift;

  $self->{objects}->del(@_);
  print "Now we have ",$self->{objects}->members()," objects.\n";
  }

##############################################################################
# base class for in-game objects

package Games::3D::Object;

use Games::3D::Thingy;
use strict;
use vars qw/@ISA/;

@ISA = qw/Games::3D::Thingy/;
  
sub kill
  {
  my $self = shift;

  print "$self->{name} just died.\n";
  # kill yourself
  $self->{world}->kill($self->{id});
  }

package main;

my $world = Games::3D::MyWorld->new ( );

print "Constructing object hirarchy from classes.txt...";
$world->load_hirarchy ('classes.txt');
print "done.\n";

print "Loading level 0...";
$world->load_level('level00.txt'); 
print "done.\n";

help();
my $main = 'main';

while (defined $world->find_target('Player'))
  {
  print "Enter command: ";
  my $command = lc(<>); chomp($command);
  my $object = '';
  #print "You entered $command\n";
  ($command,$object) = split / /,$command;
  $command = 'help' if $command eq '?';
  $command = 'kill' if $command eq 'quit';
  if ($command !~ /^(eat|pickup|help|\?|kill|quit|drop|examine)$/)
    {
    print "Unknown command $command. Try 'help'.\n";
    next;
    }
  $object ||= 'Player';
  my $obj = $world->find_target($object);
  $obj = $world if $object eq 'world';
  print "Don't know object $object.\n" and next unless defined $obj;

  $main->$command($object,$obj);
  }

print "Player died, game over\n";

1;

sub kill
  {
  my ($self,$object,$obj) = @_;

  $obj->kill();
  }

sub pickup
  {
  my ($self,$object,$obj) = @_;

  print "You picked up the $object\n";
  }

sub drop
  {
  my ($self,$object,$obj) = @_;

  print "You dropped up the $object\n";
  }

sub eat
  {
  my ($self,$object,$obj) = @_;

  print "You ate the $object\n";
  }

sub examine
  {
  my ($self,$object,$obj) = @_;

  # avoid dumping world, too
  my $w = $obj->{world}; delete $obj->{world};
  use Data::Dumper; print Dumper($obj);
  $obj->{world} = $w;
  }

sub help
  {
  print "I know the following commands (synonyms listed with '/'):\n";
  print "help/?\n";
  print "kill [OBJECT]\n";
  print "kill/quit\n";
  print "pickup/take OBJECT\n";
  print "drop OBJECT\n";
  print "use OBJECT\n";
  print "eat OBJECT\n";
  print "examine\n";
  print "examine OBJECT\n";
  print "\n";
  }

