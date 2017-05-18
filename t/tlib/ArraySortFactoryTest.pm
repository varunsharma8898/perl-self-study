package ArraySortFactoryTest;
use strict;
use warnings;
no warnings 'uninitialized';

use Log::Log4perl;
use Test::Trap;

use ArraySortFactory;

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

	return $self;
}

################################################################################
# set_up and tear_down
################################################################################
sub set_up    { }
sub tear_down { }

################################################################################
# test_sorter_creation
################################################################################
sub test_sorter_creation {
	my $self = shift;

	$self->{logger}->info("test_sorter_creation started.");
	my $test_cases = {
		bubble    => "ArraySort::BubbleSort",
		heap      => "ArraySort::HeapSort",
		insertion => "ArraySort::InsertionSort",
		merge     => "ArraySort::MergeSort",
		quick     => "ArraySort::QuickSort",
		default   => "ArraySort",
	};

	for my $algo (keys %$test_cases) {
		my $sorter = ArraySortFactory->createArraySorter({ algo => $algo });
		$self->assert($sorter);
		$self->assert_equals($test_cases->{$algo}, ref $sorter);
	}

	$self->{logger}->info("test_sorter_creation completed successfully.");
}

################################################################################
# test_sorter_creation_negative
################################################################################
sub test_sorter_creation_negative {
	my $self = shift;
	my $sorter;
	$self->{logger}->info("test_sorter_creation_negative started.");

	trap {
		$sorter = ArraySortFactory->createArraySorter();
	};
	my $dieMsg = $trap->die;
	$self->assert($dieMsg);
	$self->assert_null($sorter);
	$self->assert_matches(qr/Options not passed/, $dieMsg);

	$self->{logger}->info("test_sorter_creation_negative completed successfully.");
}

1;
