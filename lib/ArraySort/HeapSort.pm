package ArraySort::HeapSort;
###############################################################################
# ArraySort::HeapSort:
#   Perl implementation of heap sort algorithm to sort an array.
#   Worst Case complexity: O(n log n)
###############################################################################

use strict;
use warnings;
no warnings 'uninitialized';

use base 'ArraySort';

###############################################################################
# sort
###############################################################################
sub sort {
	my ($self, $arrayRef) = @_;
	if (ref $arrayRef ne 'ARRAY') {
		$self->{logger}->logdie("Incorrect input, arrayref expected.");
		return;
	}
	return [] if !scalar @$arrayRef;
	return $self->_heapSort([@$arrayRef]);
}

################################################################################
# _heapSort
################################################################################
sub _heapSort {
	my ($self, $arrayRef) = @_;
	$self->_buildMaxHeap($arrayRef);
	for (my $i = $#$arrayRef ; $i > 0 ; $i--) {

		# Move the first element (which is largest in the heap) to $i index
		($arrayRef->[0], $arrayRef->[$i]) = ($arrayRef->[$i], $arrayRef->[0]);

		$self->_maxHeapify($arrayRef, $i - 1, 0);    # most imp thing here is maxIndex=($i-1)
	}
	return $arrayRef;
}

################################################################################
# _buildMaxHeap
################################################################################
sub _buildMaxHeap {
	my ($self, $arrayRef) = @_;
	my $maxIndex = $#$arrayRef;
	for (my $i = int($maxIndex / 2) ; $i >= 0 ; $i--) {
		$self->_maxHeapify($arrayRef, $maxIndex, $i);
	}
}

################################################################################
# _maxHeapify
################################################################################
sub _maxHeapify {
	my ($self, $arrayRef, $maxIndex, $i) = @_;
	my $left  = 2 * $i + 1;
	my $right = $left + 1;
	my $largest;

	if ($left <= $maxIndex && $arrayRef->[$left] > $arrayRef->[$i]) {
		$largest = $left;
	}
	else {
		$largest = $i;
	}

	if ($right <= $maxIndex && $arrayRef->[$right] > $arrayRef->[$largest]) {
		$largest = $right;
	}

	if ($largest != $i) {

		# swap largest child element with parent index
		($arrayRef->[$largest], $arrayRef->[$i]) = ($arrayRef->[$i], $arrayRef->[$largest]);
		$self->_maxHeapify($arrayRef, $maxIndex, $largest);
	}

}

1;
