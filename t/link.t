#!/usr/bin/perl -w

use Test::More tests => 44;
use strict;

BEGIN
  {
  $| = 1;
  use blib;
  chdir 't' if -d 't';
  use_ok ('Games::3D::Link');
  }

can_ok ('Games::3D::Link', qw/ 
  new _init activate deactivate is_active id name
  state output signal add_input add_output
  insert remove container
  link
  and_gate
  delay count
  once invert fixed_output
  /);
    
use Games::3D::Signal qw/
  SIGNAL_ON SIGNAL_OFF STATE_OFF STATE_ON SIGNAL_ACTIVATE SIGNAL_DEACTIVATE
  SIGNAL_FLIP
 /;

# create link
my $link = Games::3D::Link->new ( );

is (ref($link), 'Games::3D::Link', 'new worked');
is ($link->id(), 1, 'id is 1');

is ($link->and_gate(), 0, 'OR gate');
is ($link->and_gate(1), 1, 'AND gate');

is ($link->is_active(), 1, 'is active');
is ($link->deactivate(), 0, 'is deactive');
is ($link->deactivate(), 0, 'is still deactive');

is ($link->is_active(), 0, 'is no longer active');
is ($link->activate(), 1, 'is active again');

is ($link->activate(), 1, 'is stil active');

is ($link->name(), 'Link #1', "knows it's name");

is (join(" ",$link->delay()), '0 2000 0', "0 s delay, 2 seconds, 0 rand");
is ($link->count(), 1, "once");
is ($link->count(-1), -1, "infinitely");
is ($link->count(2), 2, "twice");
is ($link->count(1), 1, "once");

is ($link->once(), 0, 'not an one-shot link');
is ($link->invert(), 0, 'not an inverted link');
is (!defined $link->fixed_output(), 1, 'no fixed output');

##############################################################################
# create two thingies and link them together

my $t1 = Games::3D::Thingy->new( );
my $t2 = Games::3D::Thingy->new( );

$link->link($t1,$t2);

is (keys %{$t1->{outputs}}, 1, 'one listener');
is (ref($t1->{outputs}->{1}), 'Games::3D::Link', 'listener on t1 ok');
is (ref($link->{outputs}->{3}), 'Games::3D::Thingy', 'listener on link ok');

is ($t2->state(), STATE_OFF, 't2 is off');

# sending as object
$t1->output($t1,SIGNAL_ON);
is ($t2->state(), STATE_ON, 't2 is now on');

# sending as id
$t1->output($t1,SIGNAL_OFF);
is ($t2->state(), STATE_OFF, 't2 is now off');

# state change on t1 causes signal to be sent to t2
$t1->state(STATE_ON);
is ($t2->state(), STATE_ON, 't2 is now on again after state change');


##############################################################################
# create three thingies and link them together with an AND gate

$t1 = Games::3D::Thingy->new( );
$t2 = Games::3D::Thingy->new( );
my $t3 = Games::3D::Thingy->new( );

print "# ",$t1->name(),"\n";
print "# ",$t2->name(),"\n";
print "# ",$t3->name(),"\n";
print "# ",$link->name(),"\n";

$link->unlink();

$link->link($t1,$t3);

is (keys %{$t1->{outputs}}, 1, 'one listener');
is (ref($t1->{outputs}->{$link->id()}), 'Games::3D::Link', 'listener on t1 ok');
is (ref($link->{outputs}->{$t3->id()}), 'Games::3D::Thingy', 'listener on link ok');
is (keys %{$link->{outputs}}, 1, 'one listener on link');
is ($t1->{outputs}->{1}, $link, 'listener on t1 ok');

$link->link($t2,$t3);

is (keys %{$t1->{outputs}}, 1, 'one listener');
is (ref($t1->{outputs}->{1}), 'Games::3D::Link', 'listener on t1 ok');
is (keys %{$t2->{outputs}}, 1, 'one listener');
is (ref($t2->{outputs}->{1}), 'Games::3D::Link', 'listener on t1 ok');
is ($t2->{outputs}->{1}, $link, 'listener on t1 ok');
is (keys %{$link->{outputs}}, 1, 'one listener on link');
is (ref($link->{outputs}->{$t3->id()}), 'Games::3D::Thingy', 'listener on link ok');

$link->and_gate(0);	# OR gate

$t3->state(STATE_OFF);

# inactivate link

$t1->signal($t1,SIGNAL_DEACTIVATE);
is ($link->is_active(), 0, 'inactive now');
is ($t3->is_active(), 1, "didn't get releayed");
is ($t3->state(), STATE_OFF, 't3 off (signal not relayed)');

$t1->signal($t1,SIGNAL_FLIP);
is ($t3->state(), STATE_OFF, 't3 is still off (link inactive)');


#############################################################################

# needs an app
#$t2->state(STATE_ON);
#
#is (join(" ",$link->delay(0,50,0)), '0 2000 0', "0 s delay, 2 seconds, 0 rand");
#is ($link->count(2), 2, "twice");
#$t1->output($t1,STATE_FLIP);
#sleep(1);
#is ($t2->state(), STATE_ON, 'flipping twice is still on');
#
#is ($link->count(3), 3, "three times");
#$t1->output($t1,STATE_FLIP);
#sleep(1);
#is ($t2->state(), STATE_OFF, 'flipping three times is off');

