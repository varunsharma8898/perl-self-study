#!/usr/bin/perl

use strict;
use warnings;

use Benchmark;
use Cwd;
use File::Basename;
use File::Spec;
use Test::Unit::Lite;
use Test::Unit::TestRunner;

BEGIN {
	chdir dirname(__FILE__) or die "$!";
	chdir '..' or die "$!";

	unshift @INC, map { /(.*)/; $1 } split(/:/, $ENV{PERL5LIB}) if defined $ENV{PERL5LIB} and ${^TAINT};

	my $cwd = ${^TAINT} ? do { local $_ = getcwd; /(.*)/; $1 } : '.';
	unshift @INC, File::Spec->catdir($cwd, 'inc');
	unshift @INC, File::Spec->catdir($cwd, 'lib');
	unshift @INC, File::Spec->catdir($cwd, 't/tlib');
}

local $SIG{__WARN__} = sub { require Carp; Carp::confess("Warning: $_[0]") };

if (@ARGV) {
	for my $t (@ARGV) {
		my $start = Benchmark->new;
		print "Testing $t\n";

		Test::Unit::TestRunner->new->start($t);
		my $end = Benchmark->new;
		my $td  = timediff($end, $start);
		print "\nTime: " . timestr($td);
		print "\n" . '-' x 80 . "\n";
	}
}
else {
	my $start = Benchmark->new;
	all_tests;
	my $end = Benchmark->new;
	my $td  = timediff($end, $start);
	print "\nTime: " . timestr($td);
	print "\n" . '-' x 80 . "\n";
}

###############################################################################
# How to run tests:
#   cd <working_dir>
#   perl t/testRunner.pl SampleTest     # for a single test
# or
#   perl t/testRunner.pl                # for all tests
###############################################################################
