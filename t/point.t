#!/usr/bin/perl -w

use Test::More tests => 13;
use strict;

BEGIN
  {
  $| = 1;
  unshift @INC, '../blib/lib';
  unshift @INC, '../blib/arch';
  unshift @INC, '.';
  chdir 't' if -d 't';
  use_ok ('Games::3D::Point');
  }

can_ok ('Games::3D::Point', qw/ 
  new _init x y z pos
  /);

my $point = Games::3D::Point->new ( );

is (ref($point), 'Games::3D::Point', 'new worked');

is ($point->x(), 0, 'X is 0');
is ($point->y(), 0, 'Y is 0');
is ($point->z(), 0, 'Z is 0');
is (join(",",$point->pos()), '0,0,0', 'center is 0,0,0');

is ($point->x(12), 12, 'X is 12');
is ($point->x(), 12, 'X is 12');
is ($point->y(34), 34, 'Y is 34');
is ($point->y(), 34, 'Y is 34');
is ($point->x(56), 56, 'X is 56');
is ($point->x(), 56, 'X is 56');

