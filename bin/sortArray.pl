#!/usr/bin/perl
use strict;
use warnings;
no warnings ('uninitialized', 'experimental::smartmatch');

use lib 'lib';

use Benchmark;
use Data::Dumper;
use Getopt::Long;

$Data::Dumper::Sortkeys = 1;

my $options = {};

GetOptions(
	$options,
	'help',
	'algo=s',
	'array=s',
	'random=s',
	'verbose'
);

Usage() && exit if ($options->{help});
Usage() && exit if (!$options->{array} && !$options->{random});
Usage() && exit if (
	!$options->{algo}
	|| $options->{algo} !~ /(merge|insertion|bubble)/i
);

$options->{algo} = lc $options->{algo};
print "\nUsing $options->{algo} sort\n";

my @array = ();
if ($options->{array}) {
	@array = map { int($_) } split(/,/, $options->{array});
}
else {
	for (0 .. $options->{random}) {
		push @array, int(rand(10000));
	}
}

###########################################################
# TODO: This should be ideally moved to a factory class.
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
else {
	require ArraySort::ArraySort;
	$sortObj = ArraySort::ArraySort->new();
}
###########################################################

my $start       = Benchmark->new();
my $sortedArray = $sortObj->sort(\@array);
my $end         = Benchmark->new();

my @sortedArray = sort { $a <=> $b } @array;

# Only dump data if array is not too big
if (scalar @array < 100 || $options->{verbose}) {
	print "\nActual Array = " . Dumper(\@array);
	print "\nSorted Array = " . Dumper($sortedArray);
}

if (@sortedArray ~~ @$sortedArray) {
	print "sorted arrays are equal\n";
}
else {
	print "sorted arrays not equal\n";
}

my $td = timediff($end, $start);
print "\nTime: " . timestr($td) . "\n";

###########################################################
# Usage
###########################################################
sub Usage {
	my ($msg) = @_;
	print $msg . qq{
	$0 <your-stuff> --help
	Options:
	--help   : Usage
	--algo   : Algorithm to use to sort
	           Possible vals: merge/insertion/bubble
	--array  : Comma-separated list
	--random : Number of random elements generated and sorted
	           One of --array or --random is required.
	--verbose : dumps arrays
	};
	print "\n";
}

