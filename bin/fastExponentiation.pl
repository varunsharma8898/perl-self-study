#!/usr/bin/perl
###############################################################################
# fastExponentitation.pl :
#
#   Simple script to calculate exponentiation.
#   Brute force algo for this would take (n − 1) multiplications.
#   This one is based on simple recursive logic that n = n/2 + n/2.
#     So if n == even and x = a^(n/2):
#       a^n = x^2
#     and if odd, a^n = a * x^2
#   O(lg n) complexity
###############################################################################

use strict;
use warnings;
no warnings('uninitialized', 'experimental::smartmatch');

use lib 'lib';

use Getopt::Long;

my $options = {};

GetOptions($options, 'help',);

Usage() && exit if ($options->{help});

my ($a, $n) = @ARGV;
print "\na = " . $a;
print "\nn = " . $n;

if ($a && $n) {
	print "\n\n$a raised to power $n = " . power($a, $n);
}

print "\n\n";

###############################################################################
# power
###############################################################################
sub power {
	my ($a, $n) = @_;

	return 1 if $n == 0;

	my $n_by_2 = int($n / 2);
	my $x      = power($a, $n_by_2);

	# if n is even
	if ($n % 2 == 0) {
		return $x * $x;
	}
	else {
		return $a * $x * $x;
	}
}

###############################################################################
# Usage
###############################################################################
sub Usage {
	my ($msg) = @_;
	print $msg . qq{
	$0 <number> <power>
	Options:
	--help   : Usage
	};
	print "\n";
}

