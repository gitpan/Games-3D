#!/usr/bin/perl -w

use Test::More tests => 25;
use strict;

BEGIN
  {
  $| = 1;
  unshift @INC, '../blib/lib';
  unshift @INC, '../blib/arch';
  unshift @INC, '.';
  chdir 't' if -d 't';
  use_ok ('Games::3D::Area', qw/GAMES_3D_SPHERE GAMES_3D_CUBE/);
  }

can_ok ('Games::3D::Area', qw/ 
  new _init x y z pos rotation
  size width height length shape
  /);

my $area = Games::3D::Area->new ( );

is (ref($area), 'Games::3D::Area', 'new worked');

is ($area->x(), 0, 'X is 0');
is ($area->y(), 0, 'Y is 0');
is ($area->z(), 0, 'Z is 0');
is (join(",",$area->pos()), '0,0,0', 'pos is 0,0,0');
is (join(",",$area->rotation()), '0,0,0', 'rot is 0,0,0');
is ($area->shape(), GAMES_3D_CUBE, 'shaped like a cube');

is ($area->x(12), 12, 'X is 12');
is ($area->x(), 12, 'X is 12');
is ($area->y(34), 34, 'Y is 34');
is ($area->y(), 34, 'Y is 34');
is ($area->x(56), 56, 'X is 56');
is ($area->x(), 56, 'X is 56');

is (join(",",$area->size()), '1,1,1', 'size is 0,0,0');
is ($area->width(), 1, 'w is 1');
is ($area->length(), 1, 'l is 1');
is ($area->height(), 1, 'h is 1');

is ($area->width(12), 12, 'w is 12');
is ($area->width(), 12, 'w is 12');
is ($area->length(34), 34, 'l is 34');
is ($area->length(), 34, 'l is 34');
is ($area->height(56), 56, 'h is 56');
is ($area->height(), 56, 'h is 56');


