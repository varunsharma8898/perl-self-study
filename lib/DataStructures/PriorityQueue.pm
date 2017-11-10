package DataStructures::PriorityQueue;
###############################################################################
# PriorityQueue:
#   Perl implementation of priority queue algorithm
#   It uses HeapSort (max heap) algo internally.
#   Worst Case complexity: O(n log n)
###############################################################################

use strict;
use warnings;
no warnings 'unintialized';

use ArraySort::HeapSort;

###############################################################################
# new
###############################################################################
sub new {
	my ($class, $options) = @_;
	my $self = {};
	bless $self, $class;

	$self->{_proxy} = ArraySort::HeapSort->new();

	return $self;
}

###############################################################################
# insertElement
#
# Inserts element according to its priority into a max-heap.
###############################################################################
sub insertElement {
	my ($self, $maxHeap, $element) = @_;
	
}

###############################################################################
# get the highest priority from max-heap.
###############################################################################
sub getMaxPriorityElement {
	
}

###############################################################################
# remove the Highest Priority element from max-heap and return it.
###############################################################################
sub extractMaxPriorityElement {
	
}

###############################################################################
# increase the priority of an element and adjust max-heap accordingly.
###############################################################################
sub increasePriority {
	
}

1;
