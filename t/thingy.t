#!/usr/bin/perl -w

use Test::More tests => 17;
use strict;

BEGIN
  {
  $| = 1;
  use blib;
  chdir 't' if -d 't';
  use_ok ('Games::3D::Thingy'); 
  }

can_ok ('Games::3D::Thingy', qw/ 
  new _init activate deactivate is_active id name
  state output signal add_input add_output link
  insert remove container _update_space 
  del_input del_output
  /);

use Games::3D::Signal qw/SIGNAL_ON SIGNAL_OFF STATE_OFF STATE_ON STATE_FLIP/;

# create thingy
my $thingy = Games::3D::Thingy->new ( );

is (ref($thingy), 'Games::3D::Thingy', 'new worked');
is ($thingy->id(), 1, 'id is 1');

is ($thingy->is_active(), 1, 'is active');
is ($thingy->deactivate(), 0, 'is deactive');
is ($thingy->deactivate(), 0, 'is still deactive');

is ($thingy->is_active(), 0, 'is no longer active');
is ($thingy->activate(), 1, 'is active again');

is ($thingy->activate(), 1, 'is stil active');

is ($thingy->name(), 'Thingy #1', "knows it's name");

is ($thingy->state(), STATE_OFF, "is off");
is ($thingy->state(STATE_ON), STATE_ON, "is now on");
is ($thingy->state(STATE_FLIP), STATE_OFF, "is now off again");
is ($thingy->state(STATE_OFF), STATE_OFF, "is still off");

$thingy->signal(1,SIGNAL_OFF); is ($thingy->state(), STATE_OFF, "is still off");
$thingy->signal(1,SIGNAL_ON); is ($thingy->state(), STATE_ON, "is on again");

