#!/usr/bin/perl -w

use Test::More tests => 8;
use strict;

BEGIN
  {
  $| = 1;
  use blib;
  chdir 't' if -d 't';
  use_ok ('Games::3D::World'); 
  }

can_ok ('Games::3D::World', qw/ 
  new load_from_file save_to_file reload
  load_templates save_templates
  ID reset_ID
  update render register unregister
  things thinkers
  /);

# create world
my $world = Games::3D::World->new ( );

is ($world->things(), 0, 'empty');
is (ref($world), 'Games::3D::World', 'new worked');
is ($world->id(), 0, 'world has ID 0');

is ($world->update(0), $world, 'updated');

my $rendered = 0;
is ($world->render(0, sub { $rendered++ }), $world, 'rendered');

is ($rendered, 0, 'none so far');

