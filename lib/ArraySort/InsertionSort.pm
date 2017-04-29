package ArraySort::InsertionSort;
################################################################################
# ArraySort::InsertionSort:
#   Perl implementation of bubble sort algorithm to sort an array.
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

	return $self->_insertionSort([ @$arrayRef ]);
}

################################################################################
# sort
################################################################################
sub _insertionSort {
	my ($self, $arrayRef) = @_;
	for (my $i = 1; $i < scalar @$arrayRef; $i++) {
		my $j   = $i - 1;
		my $key = $arrayRef->[$i];
		while ($arrayRef->[$j] > $key && $j >= 0) {
			$arrayRef->[$j + 1] = $arrayRef->[$j];
			$j--;
		}
		$arrayRef->[$j + 1] = $key;
	}

	return $arrayRef;
}

1;
