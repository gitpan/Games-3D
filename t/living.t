#!/usr/bin/perl -w

use Test::More tests => 32;
use strict;

BEGIN
  {
  $| = 1;
  unshift @INC, '../blib/lib';
  unshift @INC, '../blib/arch';
  unshift @INC, '.';
  chdir 't' if -d 't';
  use_ok ('Games::3D::Living');
  }

can_ok ('Games::3D::Physical', qw/ 
  new _init x y z pos
  size width height length shape
  /);
  

my $obj = Games::3D::Living->new ( );

is (ref($obj), 'Games::3D::Living', 'new worked');

is ($obj->x(), 0, 'X is 0');
is ($obj->y(), 0, 'Y is 0');
is ($obj->z(), 0, 'Z is 0');
is (join(",",$obj->pos()), '0,0,0', 'center is 0,0,0');

use Games::3D::Area qw/GAMES_3D_CUBE/;

is ($obj->shape(), GAMES_3D_CUBE, 'shaped like a cube');
is ($obj->mass(), 100,'weights 100');

is ($obj->x(12), 12, 'X is 12');
is ($obj->x(), 12, 'X is 12');
is ($obj->y(34), 34, 'Y is 34');
is ($obj->y(), 34, 'Y is 34');
is ($obj->x(56), 56, 'X is 56');
is ($obj->x(), 56, 'X is 56');

is (join(",",$obj->size()), '1,1,1', 'size is 0,0,0');
is ($obj->width(), 1, 'w is 1');
is ($obj->length(), 1, 'l is 1');
is ($obj->height(), 1, 'h is 1');

is ($obj->width(12), 12, 'w is 12');
is ($obj->width(), 12, 'w is 12');
is ($obj->length(34), 34, 'l is 34');
is ($obj->length(), 34, 'l is 34');
is ($obj->height(56), 56, 'h is 56');
is ($obj->height(), 56, 'h is 56');

is ($obj->mass(12), 12, 'mass is 12');
is ($obj->mass(), 12, 'mass is 12');

$obj = Games::3D::Living->new ( mass => 90 );
is (ref($obj), 'Games::3D::Living', 'new worked');
is ($obj->mass(), 90, 'mass is 90');

is ($obj->is_dead(), 0, 'is alive');
is ($obj->is_knocked_out(), 0, 'is fully aware');
is ($obj->health(), 100, 'fully alive');
