package ArraySortTest;
use strict;
use warnings;
no warnings 'uninitialized';

use Log::Log4perl;
use Test::Trap;

use ArraySort;

use base "Test::Unit::TestCase";

################################################################################
# new
################################################################################
sub new {
	my ($class, $test_name) = @_;
	my $self = $class->SUPER::new($test_name);

	my $conf = "config/log4perl.config";
	Log::Log4perl::init($conf);
	$self->{logger} = Log::Log4perl->get_logger();

	$self->{arraySort} = ArraySort->new();
	return $self;
}

################################################################################
# set_up and tear_down
################################################################################
sub set_up    { }
sub tear_down { }

################################################################################
# test_sortArray
################################################################################
sub test_sortArray {
	my $self = shift;
	$self->{logger}->info("test_sortArray started.");
	my $sortedArray = $self->{arraySort}->sortArray([]);
	$self->assert($sortedArray);
	$self->assert_equals("ARRAY", ref $sortedArray);
	$self->assert_equals(0,       scalar @$sortedArray);

	my @array = qw(11 9 5 8 4 7 3 1 2);
	my $sortedArrayStr = join " ", sort { $a <=> $b } @array;

	$sortedArray = $self->{arraySort}->sortArray(\@array);

	$self->assert($sortedArray);
	$self->assert_equals("ARRAY",       ref $sortedArray);
	$self->assert_equals(scalar @array, scalar @$sortedArray);
	$self->assert_equals($sortedArrayStr, join " ", @$sortedArray);

	$self->{logger}->info("test_sortArray completed successfully.");
}

################################################################################
# test_sortArray_incorrect_inputs
################################################################################
sub test_sortArray_incorrect_inputs {
	my $self = shift;
	my $sortedArray;
	$self->{logger}->info("test_sortArray_incorrect_inputs started.");

	trap {
		$sortedArray = $self->{arraySort}->sortArray();
	};
	my $dieMsg = $trap->die;
	$self->assert($dieMsg);
	$self->assert_null($sortedArray);
	$self->assert_matches(qr/Incorrect input, arrayref expected/, $dieMsg);

	trap {
		$sortedArray = $self->{arraySort}->sortArray({});
	};
	$dieMsg = $trap->die;
	$self->assert($dieMsg);
	$self->assert_null($sortedArray);
	$self->assert_matches(qr/Incorrect input, arrayref expected/, $dieMsg);

	trap {
		$sortedArray = $self->{arraySort}->sortArray(1, 2, 3);
	};
	$dieMsg = $trap->die;
	$self->assert($dieMsg);
	$self->assert_null($sortedArray);
	$self->assert_matches(qr/Incorrect input, arrayref expected/, $dieMsg);
	$self->{logger}->info("test_sortArray_incorrect_inputs completed successfully.");
}

################################################################################
# test_sort_huge_array
################################################################################
sub test_sort_huge_array {
	my $self = shift;
	$self->{logger}->info("test_sort_huge_array started.");

	my @hugeArray;
	for (0 .. 10000) {
		$hugeArray[$_] = int(rand(10000));
	}

	my $sortedArrayStr = join " ", sort { $a <=> $b } @hugeArray;

	my $sortedArray = $self->{arraySort}->sortArray(\@hugeArray);

	$self->assert($sortedArray);
	$self->assert_equals("ARRAY",           ref $sortedArray);
	$self->assert_equals(scalar @hugeArray, scalar @$sortedArray);
	$self->assert_equals($sortedArrayStr, join " ", @$sortedArray);

	$self->{logger}->info("test_sort_huge_array completed successfully.");
}

################################################################################
# test_sort_should_not_be_called
################################################################################
sub test_sort_should_not_be_called {
	my $self = shift;
	$self->{logger}->info("test_sort_should_not_be_called started.");
	my $sortedArray;
	trap {
		$sortedArray = $self->{arraySort}->sort();
	};
	my $dieMsg = $trap->die;
	$self->assert($dieMsg);
	$self->assert_null($sortedArray);
	$self->assert_matches(qr/This should not be called directly/, $dieMsg);

	$self->{logger}->info("test_sort_should_not_be_called completed successfully.");
}

1;
