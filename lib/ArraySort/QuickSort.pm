package ArraySort::QuickSort;
###############################################################################
# ArraySort::QuickSort:
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
	return $self->_quickSort([@$arrayRef], 0, $#$arrayRef);
}

################################################################################
# _quickSort
################################################################################
sub _quickSort {
	my ($self, $arrayRef, $start, $end) = @_;

	if ($start < $end) {
		my $partition = $self->_partition($arrayRef, $start, $end);
	
		$self->_quickSort($arrayRef, $start,     $partition - 1);
		$self->_quickSort($arrayRef, $partition, $end);
	}

	return $arrayRef;
}

################################################################################
# _partition
################################################################################
sub _partition {
	my ($self, $arrayRef, $start, $end) = @_;

	my $i = $start - 1;
	my $key = $arrayRef->[$end];
	for (my $j = $start; $j <= $end - 1; $j++) {    # start till **<=** end-1
		if ($arrayRef->[$j] <= $key) {              # ** <= **
			$i++;
			($arrayRef->[$i], $arrayRef->[$j]) = ($arrayRef->[$j], $arrayRef->[$i]);
		}
	}
	($arrayRef->[$i + 1], $arrayRef->[$end]) = ($arrayRef->[$end], $arrayRef->[$i + 1]);
	return $i + 1;
}

1;
