
# This is just the version number and the documentation

package Games::3D;

# (C) by Tels <http://bloodgate.com/>

use strict;

use vars qw/$VERSION/;

$VERSION = '0.05';

1;

__END__

=pod

=head1 NAME

Games::3D - a package containing 3D points, vectors, areas, objects and links

=head1 SYNOPSIS

	use Games::3D::Point;

	my $origin = Games::3D::Point->new();

	my $point = Games::3D::Point->new ( x => 1, y => 0, z => -1);

=head1 EXPORTS

Exports nothing.

=head1 DESCRIPTION

This package is just the basis documentation for all the classes contained
under Games::3D. It does not need to be used, unless you want to require a
specific version of this package.

=head2 Signals and Links

Here follows an in-depth description of what the signals and links provided
by that package do and how you can use them in actual games.

=head1 METHODS

This package defines no methods.

=head1 BUGS

None known yet.

=head1 AUTHORS

(c) 2003, 2004 Tels <http://bloodgate.com/>

=head1 SEE ALSO

L<Games::Irrlicht>

L<GAMES::3D::Thingy>, L<GAMES::3D::Link>, L<GAMES::3D::Signal>.

=cut

