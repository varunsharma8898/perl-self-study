package ArraySortFactory;

use strict;
use warnings;
no warnings 'uninitialized';

use Carp qw(croak);

################################################################################
# createArraySorter
################################################################################
sub createArraySorter {
	my ($class, $options) = @_;
	if (!$options || !exists $options->{algo}) {
		croak "Options not passed";
	}

	my $sortObj;
	if ($options->{algo} eq 'merge') {
		require ArraySort::MergeSort;
		$sortObj = ArraySort::MergeSort->new();
	}
	elsif ($options->{algo} eq 'insertion') {
		require ArraySort::InsertionSort;
		$sortObj = ArraySort::InsertionSort->new();
	}
	elsif ($options->{algo} eq 'bubble') {
		require ArraySort::BubbleSort;
		$sortObj = ArraySort::BubbleSort->new();
	}
	elsif ($options->{algo} eq 'heap') {
		require ArraySort::HeapSort;
		$sortObj = ArraySort::HeapSort->new();
	}
	elsif ($options->{algo} eq 'quick') {
		require ArraySort::QuickSort;
		$sortObj = ArraySort::QuickSort->new();
	}
	else {
		require ArraySort;
		$sortObj = ArraySort->new();
	}

	return $sortObj;
}

1;
