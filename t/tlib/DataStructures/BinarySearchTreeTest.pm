package DataStructures::BinarySearchTreeTest;
use strict;
use warnings;
no warnings 'uninitialized';

use Log::Log4perl;
use Test::Trap;

use DataStructures::BinarySearchTree;

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

	$self->{theTree} = undef;
	return $self;
}

################################################################################
# set_up and tear_down
################################################################################
sub set_up {
	my $self = shift;

	$self->{theTree} = DataStructures::BinarySearchTree->new();

	for my $key (4, 5, 3, 1, 2, 8, 10, 7, 6, 9, 11) {
		$self->{theTree}->insertNode($key);
	}
}

sub tear_down { }

################################################################################
# test_insertNode
################################################################################
sub test_insertNode {
	my $self = shift;
	$self->{logger}->info("test_insertNode started.");

	my $rootNode = $self->{theTree}->getRootNode();
	$self->assert($rootNode);
	$self->assert_equals("DataStructures::BinarySearchTree::Node", ref $rootNode);
	$self->assert_equals(4,                                        $rootNode->{key});
	$self->assert_equals(3,                                        $rootNode->{leftChild}->{key});
	$self->assert_equals(5,                                        $rootNode->{rightChild}->{key});

	trap {
		$self->{theTree}->inOrderTraverseTree($rootNode);
	};
	$self->assert_equals(" 1 2 3 4 5 6 7 8 9 10 11", $trap->stdout);

	trap {
		$self->{theTree}->preOrderTraverseTree($rootNode);
	};
	$self->assert_equals(" 4 3 1 2 5 8 7 6 10 9 11", $trap->stdout);

	trap {
		$self->{theTree}->postOrderTraverseTree($rootNode);
	};
	$self->assert_equals(" 2 1 3 6 7 9 11 10 8 5 4", $trap->stdout);

	$self->{logger}->info("test_insertNode completed successfully.");
}

################################################################################
# test_findNode
################################################################################
sub test_findNode {
	my $self = shift;
	$self->{logger}->info("test_findNode started.");

	my $rootNode = $self->{theTree}->getRootNode();
	my $someNode = $self->{theTree}->findNode($rootNode->{key});
	$self->assert($rootNode);
	$self->assert($someNode);
	$self->assert($someNode == $rootNode);
	$self->assert_equals($rootNode->{key}, $someNode->{key});

	$someNode = $self->{theTree}->findNode(10);
	$self->assert($someNode);
	$self->assert_equals(10, $someNode->{key});
	$self->assert_equals(9,  $someNode->{leftChild}->{key});
	$self->assert_equals(11, $someNode->{rightChild}->{key});

	$self->{logger}->info("test_findNode completed successfully.");
}

################################################################################
# test_findMinimum
################################################################################
sub test_findMinimum {
	my $self = shift;
	$self->{logger}->info("test_findMinimum started.");

	my $rootNode = $self->{theTree}->getRootNode();
	my $someNode = $self->{theTree}->findMinimum($rootNode);
	$self->assert($someNode);
	$self->assert_equals(1, $someNode->{key});

	$rootNode = $self->{theTree}->findNode(8);
	$someNode = $self->{theTree}->findMinimum($rootNode);
	$self->assert($someNode);
	$self->assert_equals(6, $someNode->{key});

	$self->{logger}->info("test_findMinimum completed successfully.");
}

################################################################################
# test_remove_lonely_root_node
################################################################################
sub test_remove_lonely_root_node {
	my $self = shift;
	$self->{logger}->info("test_remove_lonely_root_node started.");

	my $bst = DataStructures::BinarySearchTree->new();
	$bst->insertNode(1);
	$bst->removeNode($bst->getRootNode());
	$self->assert_null($bst->getRootNode());

	$self->{logger}->info("test_remove_lonely_root_node completed successfully.");
}

################################################################################
# test_removeNode_with_no_children
################################################################################
sub test_removeNode_with_no_children {
	my $self = shift;
	$self->{logger}->info("test_removeNode_with_no_children started.");

	my $rootNode = $self->{theTree}->getRootNode();

	$self->{theTree}->removeNode($self->{theTree}->findNode(11));
	trap {
		$self->{theTree}->inOrderTraverseTree($rootNode);
	};
	$self->assert_equals(" 1 2 3 4 5 6 7 8 9 10", $trap->stdout);

	$self->{logger}->info("test_removeNode_with_no_children completed successfully.");
}

################################################################################
# test_removeNode_with_one_child
################################################################################
sub test_removeNode_with_one_child {
	my $self = shift;
	$self->{logger}->info("test_removeNode_with_one_child started.");

	my $rootNode = $self->{theTree}->getRootNode();

	$self->{theTree}->removeNode($self->{theTree}->findNode(7));
	trap {
		$self->{theTree}->inOrderTraverseTree($rootNode);
	};
	$self->assert_equals(" 1 2 3 4 5 6 8 9 10 11", $trap->stdout);
	$self->{theTree}->removeNode($self->{theTree}->findNode(5));
	trap {
		$self->{theTree}->inOrderTraverseTree($rootNode);
	};
	$self->assert_equals(" 1 2 3 4 6 8 9 10 11", $trap->stdout);

	$self->{logger}->info("test_removeNode_with_one_child completed successfully.");
}

################################################################################
# test_removeNode_with_both_children
################################################################################
sub test_removeNode_with_both_children {
	my $self = shift;
	$self->{logger}->info("test_removeNode_with_both_children started.");

	my $rootNode = $self->{theTree}->getRootNode();

	$self->{theTree}->removeNode($self->{theTree}->findNode(8));
	trap {
		$self->{theTree}->inOrderTraverseTree($rootNode);
	};
	$self->assert_equals(" 1 2 3 4 5 6 7 9 10 11", $trap->stdout);

	$self->{theTree}->removeNode($self->{theTree}->findNode(7));
	trap {
		$self->{theTree}->inOrderTraverseTree($rootNode);
	};
	$self->assert_equals(" 1 2 3 4 5 6 8 9 10 11", $trap->stdout);

	$self->{theTree}->removeNode($self->{theTree}->findNode(5));
	trap {
		$self->{theTree}->inOrderTraverseTree($rootNode);
	};
	$self->assert_equals(" 1 2 3 4 6 8 9 10 11", $trap->stdout);

	$self->{logger}->info("test_removeNode_with_both_children completed successfully.");
}

1;
