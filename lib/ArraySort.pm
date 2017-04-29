package ArraySort;
################################################################################
# ArraySort:
#   Parent module to different sorting algorithms.
################################################################################

use strict;
use warnings;
no warnings 'uninitialized';

use Carp qw(carp croak);;
use Log::Log4perl;

################################################################################
# new
################################################################################
sub new {
	my ($class, $options) = @_;
	$options = {} if (!$options || ref $options ne 'HASH');

	my $self = {
		logger => undef,
	};

	foreach (keys %$self) {
		$self->{$_} = $options->{$_} if exists $options->{$_};
	}

	if (!Log::Log4perl->initialized()) {
		Log::Log4perl::init("config/log4perl.config");
#		$self->{logger} = Log::Log4perl->get_logger();
	}
	$self->{logger} = Log::Log4perl->get_logger(__PACKAGE__);

	bless $self, $class;
	return $self;
}

################################################################################
# sortArray
################################################################################
sub sortArray {
	my ($self, $arrayRef) = @_;
	if (ref $arrayRef ne 'ARRAY') {
		croak "Incorrect input, arrayref expected.";
	}

	my @sortedArray = sort { $a <=> $b } @$arrayRef;
	return \@sortedArray;
}

################################################################################
# sort
################################################################################
sub sort {
	croak "This should not be called directly.";
}

1;
