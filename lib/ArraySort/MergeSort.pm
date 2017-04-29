package ArraySort::MergeSort;
################################################################################
# ArraySort::MergeSort:
#   Perl implementation of merge sort algorithm to sort an array.
#   Worst Case complexity O(n log n).
################################################################################

use strict;
use warnings;
no warnings 'uninitialized';

use base 'ArraySort';

################################################################################
# sort
################################################################################
sub sort {
	my ($self, $arrayRef) = @_;
	if (ref $arrayRef ne 'ARRAY') {
		$self->{logger}->logdie("Incorrect input, arrayref expected.");
		return;
	}
	return [] if !scalar @$arrayRef;
	return $self->_mergeSort([@$arrayRef]);
}

################################################################################
# _mergeSort
################################################################################
sub _mergeSort {
	my ($self, $arrayRef) = @_;

	return if scalar @$arrayRef < 2;

	my $mid        = int(@$arrayRef / 2);
	my @leftArray  = @$arrayRef[0 .. $mid - 1];
	my @rightArray = @$arrayRef[$mid .. $#$arrayRef];

	$self->_mergeSort(\@leftArray);
	$self->_mergeSort(\@rightArray);

	$self->_merge($arrayRef, \@leftArray, \@rightArray);
	#$self->_mergeDetailed($arrayRef, \@leftArray, \@rightArray);

	return $arrayRef;
}

################################################################################
# _merge
#   If there isn't anything from left array, pop first element from right array.
#   If there isn't anything from right array, pop first element from left array.
#   If there is something in both arrays, compare and copy elements from both
#   arrays.
################################################################################
sub _merge {
	my ($self, $arrayRef, $leftArrayRef, $rightArrayRef) = @_;
	for (@$arrayRef) {
		$_ = !@$leftArrayRef
			? shift @$rightArrayRef
			: !@$rightArrayRef
				? shift @$leftArrayRef
				: $leftArrayRef->[0] <= $rightArrayRef->[0]
					? shift @$leftArrayRef
					: shift @$rightArrayRef;
	}
}

################################################################################
# _mergeDetailed
#   Easy to understand code as opposed to _merge.
#   First loop over both the arrays, compare and copy elements to main array.
#   Then fill over remaining positions of the array left by previous step.
################################################################################
sub _mergeDetailed {
	my ($self, $arrayRef, $leftArrayRef, $rightArrayRef) = @_;

	my ($i, $j, $k) = (0, 0, 0);
	while ($i < @$leftArrayRef && $j < @$rightArrayRef) {
		if ($leftArrayRef->[$i] < $rightArrayRef->[$j]) {
			$arrayRef->[$k++] = $leftArrayRef->[$i++];
		}
		else {
			$arrayRef->[$k++] = $rightArrayRef->[$j++];
		}
	}

	while ($i < @$leftArrayRef) {
		$arrayRef->[$k++] = $leftArrayRef->[$i++];
	}

	while ($j < @$rightArrayRef) {
		$arrayRef->[$k++] = $rightArrayRef->[$j++];
	}
}

1;
