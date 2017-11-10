package DataStructures::BinarySearchTree::Node;

use strict;
use warnings;

sub new {
	my ($class, $key) = @_;
	my $self = {
		key        => $key,
		leftChild  => undef,
		rightChild => undef,
		parent     => undef,
	};
	bless $self, $class;
	return $self;
}

1;