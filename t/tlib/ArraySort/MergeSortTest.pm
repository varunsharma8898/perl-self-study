package ArraySort::MergeSortTest;

use strict;
use warnings;
no warnings 'uninitialized';

use Log::Log4perl;
use Test::Trap;

use ArraySort::MergeSort;

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
	$self->{arraySort} = ArraySort::MergeSort->new();
	return $self;
}

################################################################################
# set_up and tear_down
################################################################################
sub set_up    { }
sub tear_down { }

################################################################################
# test_sort
################################################################################
sub test_sort {
	my $self = shift;
	$self->{logger}->info("test_sort started.");
	my $sortedArray = $self->{arraySort}->sort([]);
	$self->assert($sortedArray);
	$self->assert_equals("ARRAY", ref $sortedArray);
	$self->assert_equals(0,       scalar @$sortedArray);

	my @array = qw(11 9 5 8 4 7 3 1 2);
	my $sortedArrayStr = join " ", sort { $a <=> $b } @array;

	$sortedArray = $self->{arraySort}->sort(\@array);

	$self->assert($sortedArray);
	$self->assert_equals("ARRAY",       ref $sortedArray);
	$self->assert_equals(scalar @array, scalar @$sortedArray);
	$self->assert_equals($sortedArrayStr, join " ", @$sortedArray);

	$self->{logger}->info("test_sort completed successfully.");
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

	my $sortedArray = $self->{arraySort}->sort(\@hugeArray);

	$self->assert($sortedArray);
	$self->assert_equals("ARRAY",           ref $sortedArray);
	$self->assert_equals(scalar @hugeArray, scalar @$sortedArray);
	$self->assert_equals($sortedArrayStr, join " ", @$sortedArray);

	$self->{logger}->info("test_sort_huge_array completed successfully.");
}

################################################################################
# test_sort_incorrect_inputs
################################################################################
sub test_sort_incorrect_inputs {
	my $self = shift;
	my $sortedArray;
	$self->{logger}->info("test_sort_incorrect_inputs started.");

	trap {
		$sortedArray = $self->{arraySort}->sort();
	};
	my $dieMsg = $trap->die;
	$self->assert($dieMsg);
	$self->assert_null($sortedArray);
	$self->assert_matches(qr/Incorrect input, arrayref expected/, $dieMsg);

	trap {
		$sortedArray = $self->{arraySort}->sort({});
	};
	$dieMsg = $trap->die;
	$self->assert($dieMsg);
	$self->assert_null($sortedArray);
	$self->assert_matches(qr/Incorrect input, arrayref expected/, $dieMsg);

	trap {
		$sortedArray = $self->{arraySort}->sort(1, 2, 3);
	};
	$dieMsg = $trap->die;
	$self->assert($dieMsg);
	$self->assert_null($sortedArray);
	$self->assert_matches(qr/Incorrect input, arrayref expected/, $dieMsg);
	$self->{logger}->info("test_sort_incorrect_inputs completed successfully.");
}

1;
