package Common;
#################################################################################
# Common:
#   This class should be used as base class for all the classed under Selfstudy.
#################################################################################

use strict;
use warnings;
no warnings 'uninitialized';

#################################################################################
# new
#################################################################################
sub new {
	my $class = shift;
	my $self  = {};
	bless $self, $class;
	return $self;
}

#################################################################################
# Proxy Design Pattern:
#   First initilize an object of some _proxy class.
#   Then if any method called using current object does not exist, call it
#   using _proxy object. Use AUTOLOAD to implement this.
#################################################################################
#sub AUTOLOAD {
#	my $self    = shift;
#	my $command = our $AUTOLOAD;
#	$command =~ s/.*://;
#
#	if ($command matches with these subs) {
#		call all these subs through _proxy
#	}
#}

1;