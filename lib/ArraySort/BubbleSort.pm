package ArraySort::BubbleSort;
################################################################################
# ArraySort::BubbleSort:
#   Perl implementation of bubble sort algorithm to sort an array.
#   Worst Case complexity O(n2).
#   Tend to be worse than Insertion sort for large n.
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
	return $self->_bubbleSort([ @$arrayRef ]);
}

################################################################################
# _bubbleSort
################################################################################
sub _bubbleSort {
	my ($self, $arrayRef) = @_;

	for (my $i = 0; $i < scalar @$arrayRef; $i++) {
		for (my $j = $i + 1; $j < scalar @$arrayRef; $j++) {
			if ($arrayRef->[$i] > $arrayRef->[$j]) {
				($arrayRef->[$i], $arrayRef->[$j]) = ($arrayRef->[$j], $arrayRef->[$i]);
			}
		}
	}

	return $arrayRef;
}

1;
