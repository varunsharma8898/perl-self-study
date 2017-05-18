package Utilities;

use strict;
use warnings;
no warnings 'uninitialized'; ## no critic (ProhibitNoWarnings)

use Data::Dumper;
use Exporter;
use List::Util 'min';

use base qw(Exporter);

## no critic (ProhibitAutomaticExportation)
our @EXPORT = qw(
	ArrayDifference
	GetStackTrace
	GetTotalTimeSpent
	InList
	TrimWhitespace
	Unindent
	UniqueElements
);

$Data::Dumper::Sortkeys = 1;

###############################################################################
# GetStackTrace:
#	Returns the stack trace (similar to Carp's longmess and caller() builtin)
#
# Usage:
#	print ReturnStackTrace();
#
# Args:
#	$args:
#		TOPTOBOTTOM: from top (most recent) of stack to bottom.
#		BOTTOMTOTOP: from bottom (least recent) of stack to top.
#
# Side Effects:
#	None.
# 
# Returns:
#	A String.
###############################################################################
sub GetStackTrace {
	my ($args) = @_;

	require Devel::StackTrace;
	my $trace = Devel::StackTrace->new();

	my $returnvalue = "\n";

	if (exists $args->{TOPTOBOTTOM} && $args->{TOPTOBOTTOM}) {
		# from top (most recent) of stack to bottom.
		while (my $frame = $trace->next_frame()) {
			$returnvalue .= "Has args \n" if ($frame->hasargs());
		}
	}
	elsif (exists $args->{BOTTOMTOTOP} && $args->{BOTTOMTOTOP}) {
		# from bottom (least recent) of stack to top.
		while (my $frame = $trace->prev_frame()) {
			print "Sub: " . $frame->subroutine() . "\n";
		}
	}
	else {
		$returnvalue .= $trace->as_string(); # like carp
	}

	return $returnvalue;
}

###############################################################################
# InList:
#	Finds out if a list contains a specified element.
#
# Usage:
#	if (InList($element, @array)) {
#		# do something
#	}
#
# Args:
#	$element: element to look for
#	@array: list
#
# Side Effects:
#	None.
# 
# Returns:
#	1 or 0.
###############################################################################
sub InList { ## no critic (RequireArgUnpacking)

	# Not unpacking the @_ here for performace reasons
	my $element = shift @_;

	# Return nothing if InList not used properly
	if (!$element || !scalar @_) {
		return;
	}

	my $match = 0;
	for (@_) {
		if ($_ eq $element) {
			$match = 1;
			last;
		}
	}

	return $match;
}

###############################################################################
# UniqueElements:
#	Returns unique elements in a list
#
# Usage:
#	my @uniqueelements = UniqueElements(@array);
#
# Args:
#	A List.
#
# Side Effects:
#	None.
# 
# Returns:
#	A List.
###############################################################################
sub UniqueElements { ## no critic (RequireArgUnpacking)

	# Not unpacking the @_ here for performace reasons

	my %seen;
	return grep { !$seen{$_}++ } @_;
}

###############################################################################
# ArrayDifference:
#	Returns the elements from first arrayref that are not present in the second
#
# Usage:
#	my @diff = ArrayDifference(\@first, \@second);
#
# Args:
#	$firstref: an arrayref
#	$secondref: an arrayref
#
# Side Effects:
#	None.
# 
# Returns:
#	A List.
###############################################################################
sub ArrayDifference {
	my ($firstref, $secondref) = @_;

	return if (ref $firstref ne 'ARRAY' || ref $secondref ne 'ARRAY');

	my %secondhash = map { $_ => 1 } @$secondref;
	my @diff  = grep { not $secondhash{$_} } @$firstref;

	return @diff;
}

###############################################################################
# Unindent:
#	Unindents a string; works with multiline strings as well.
#
# Usage:
#	my $unindented_string = Unindent($string);
#
# Args:
#	$string: a string
#
# Side Effects:
#	None.
# 
# Returns:
#	A string.
###############################################################################
sub Unindent {
	my ($string) = @_;

	my $min = min map {
		m/^([ \t]*)/; length $1 || ()
	} split "\n", $string;

	$string =~ s/^[ \t]{0,$min}//gm if ($min);

	return $string;
}

###############################################################################
# TrimWhitespace:
#	Trims leading as well as trailing whitespaces from a string.
#
# Usage:
#	my $trimmed_string = TrimWhitespace($string);
#
# Args:
#	$string: a string
#
# Side Effects:
#	None.
# 
# Returns:
#	A string.
###############################################################################
sub TrimWhitespace {
	my ($string) = @_;
	$string =~ s/^\s+|\s+$//g;
	return $string;
}

###############################################################################
# GetTotalTimeSpent:
#	Returns the total time spent in seconds (including compile time) since the 
#	beginning of the script till the call to this sub.
#
# Usage:
#	print GetTotalTimeSpent();
#
# Args:
#	None.
#
# Side Effects:
#	None.
# 
# Returns:
#	A string - time in seconds.
###############################################################################
sub GetTotalTimeSpent {
	my ($args) = @_;
	return time - $^T;
}

1;
