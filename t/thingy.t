#!/usr/bin/perl -w

use Test::More tests => 20;
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
  outputs inputs
  /);

use Games::3D::Signal qw/SIG_ON SIG_OFF STATE_OFF STATE_ON STATE_FLIP/;

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

$thingy->state(STATE_ON); 
is ($thingy->state(), STATE_OFF, "is still off (no update yet)");
is ($thingy->{state_target}, STATE_ON, "target state is ON");
is ($thingy->{state_endtime}, 1, "endtime is now (1)");

$thingy->update(1);
is ($thingy->state(), STATE_ON, "is now on");

$thingy->state(STATE_FLIP); $thingy->update(1);
is ($thingy->state(), STATE_OFF, "is now off again");

$thingy->state(STATE_OFF);
is ($thingy->state(), STATE_OFF, "is still off");

$thingy->signal(1,SIG_OFF); is ($thingy->state(), STATE_OFF, "is still off");
$thingy->signal(1,SIG_ON);
$thingy->update(2);
is ($thingy->state(), STATE_ON, "is on again");

