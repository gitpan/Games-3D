#!/usr/bin/perl -w

use Test::More tests => 14;
use strict;

BEGIN
  {
  $| = 1;
  unshift @INC, '../blib/lib';
  unshift @INC, '../blib/arch';
  unshift @INC, '.';
  chdir 't' if -d 't';
  use_ok ('Games::3D::Marker');
  }

can_ok ('Games::3D::Marker', qw/ 
  new _init x y z pos
  /);
  

my $obj = Games::3D::Marker->new ( );

is (ref($obj), 'Games::3D::Marker', 'new worked');
is ($obj->id(), 1, 'id is 1');

is ($obj->x(), 0, 'X is 0');
is ($obj->y(), 0, 'Y is 0');
is ($obj->z(), 0, 'Z is 0');
is (join(",",$obj->pos()), '0,0,0', 'center is 0,0,0');

is ($obj->x(12), 12, 'X is 12');
is ($obj->x(), 12, 'X is 12');
is ($obj->y(34), 34, 'Y is 34');
is ($obj->y(), 34, 'Y is 34');
is ($obj->x(56), 56, 'X is 56');
is ($obj->x(), 56, 'X is 56');

