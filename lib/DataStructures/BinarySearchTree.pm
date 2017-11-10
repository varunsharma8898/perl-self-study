package DataStructures::BinarySearchTree;

use strict;
use warnings;
no warnings 'uninitialized';

use DataStructures::BinarySearchTree::Node;

################################################################################
# new
################################################################################
sub new {
	my ($class, $args) = @_;

	my $self = {root => undef};

	bless $self, $class;
	return $self;
}

################################################################################
# getRootNode
################################################################################
sub getRootNode {
	my $self = shift;
	return $self->{root};
}

################################################################################
# insertNode
################################################################################
sub insertNode {
	my ($self, $key) = @_;
	my $newNode = DataStructures::BinarySearchTree::Node->new($key);

	# No root present, this is the first element in the tree
	if (!$self->{root}) {
		$self->{root} = $newNode;
	}
	else {
		my $focusNode  = $self->{root};
		my $parentNode = $self->{root};
		while (1) {
			$parentNode = $focusNode;
			if ($key < $focusNode->{key}) {
				$focusNode = $focusNode->{leftChild};
				if (!$focusNode) {
					$parentNode->{leftChild} = $newNode;
					$newNode->{parent}       = $parentNode;
					return;
				}
			}
			else {
				$focusNode = $focusNode->{rightChild};
				if (!$focusNode) {
					$parentNode->{rightChild} = $newNode;
					$newNode->{parent}        = $parentNode;
					return;
				}
			}
		}
	}
}

################################################################################
# removeNode
################################################################################
sub removeNode {
	my ($self, $nodeToRemove) = @_;

	my $rootNode = $self->getRootNode();

	# If the node to remove doesn't have any children,
	# just remove its link from parent node.
	if (!$nodeToRemove->{leftChild} && !$nodeToRemove->{rightChild}) {

		# No parent, means root node
		if (!$nodeToRemove->{parent}) {
			$self->{root} = undef;
		}
		else {
			if ($self->isLeftChild($nodeToRemove)) {
				$nodeToRemove->{parent}->{leftChild} = undef;
			}
			else {
				$nodeToRemove->{parent}->{rightChild} = undef;
			}
		}
	}

	# If the node to remove has one child only,
	# simply replace the node with its child
	if ($nodeToRemove->{leftChild} && !$nodeToRemove->{rightChild}) {
		$self->replaceNode($nodeToRemove, $nodeToRemove->{leftChild});
	}
	elsif (!$nodeToRemove->{leftChild} && $nodeToRemove->{rightChild}) {
		$self->replaceNode($nodeToRemove, $nodeToRemove->{rightChild});
	}

	# If the node to remove has both its children present,
	# find a node with minimum key from the right sub-tree
	# and use it replace the node.
	if ($nodeToRemove->{leftChild} && $nodeToRemove->{rightChild}) {
		my $nextMinimumNode = $self->findMinimum($nodeToRemove->{rightChild});



		#######
		# This is the most frustating part, pay attention to the code.
		# INCOMPLETE for now - tests fail.
		#######
		if ($nextMinimumNode->{parent} != $nodeToRemove) {
#			$nextMinimumNode->{parent}->{leftChild} = $nextMinimumNode->{rightChild} if ($self->isLeftChild($nextMinimumNode));
			$self->replaceNode($nextMinimumNode, $nextMinimumNode->{rightChild});
			$nextMinimumNode->{rightChild} = $nodeToRemove->{rightChild};
			$nextMinimumNode->{rightChild}->{parent} = $nodeToRemove->{rightChild};
		}
		$self->replaceNode($nodeToRemove, $nextMinimumNode);
		$nextMinimumNode->{leftChild} = $nodeToRemove->{leftChild};
		$nextMinimumNode->{rightChild} = $nodeToRemove->{rightChild};
	}
}

sub replaceNode {
	my ($self, $nodeToReplace, $replacementNode) = @_;
	if ($nodeToReplace->{parent}) {
		if ($self->isLeftChild($nodeToReplace)) {
			$nodeToReplace->{parent}->{leftChild} = $replacementNode;
		}
		else {
			$nodeToReplace->{parent}->{rightChild} = $replacementNode;
		}
	}
	else {
		$self->{root} = $replacementNode;
	}

	$replacementNode->{parent} = $nodeToReplace->{parent} if ($replacementNode);
}

################################################################################
# findNode
################################################################################
sub findNode {
	my ($self, $key) = @_;
	my $focusNode = $self->getRootNode();
	while ($focusNode->{key} != $key) {
		return if (!$focusNode);

		if ($key < $focusNode->{key}) {
			$focusNode = $focusNode->{leftChild};
		}
		else {
			$focusNode = $focusNode->{rightChild};
		}
	}
	return $focusNode;
}

################################################################################
# findMinimum
################################################################################
sub findMinimum {
	my ($self, $rootNode) = @_;
	my $minimum = $rootNode;
	if ($rootNode->{leftChild}) {
		$minimum = $self->findMinimum($rootNode->{leftChild});
	}
	return $minimum;
}

################################################################################
# isLeftChild
################################################################################
sub isLeftChild {
	my ($self, $node) = @_;
	return $node->{parent}->{leftChild} == $node;
}

################################################################################
# inOrderTraverseTree
################################################################################
sub inOrderTraverseTree {
	my ($self, $focusNode) = @_;
	if ($focusNode) {
		$self->inOrderTraverseTree($focusNode->{leftChild});
		print " " . $focusNode->{key};
		$self->inOrderTraverseTree($focusNode->{rightChild});
	}
}

################################################################################
# preOrderTraverseTree
################################################################################
sub preOrderTraverseTree {
	my ($self, $focusNode) = @_;
	if ($focusNode) {
		print " " . $focusNode->{key};
		$self->preOrderTraverseTree($focusNode->{leftChild});
		$self->preOrderTraverseTree($focusNode->{rightChild});
	}
}

################################################################################
# postOrderTraverseTree
################################################################################
sub postOrderTraverseTree {
	my ($self, $focusNode) = @_;
	if ($focusNode) {
		$self->postOrderTraverseTree($focusNode->{leftChild});
		$self->postOrderTraverseTree($focusNode->{rightChild});
		print " " . $focusNode->{key};
	}
}

################################################################################
# printPretty
################################################################################
sub printPretty {
	my $self = shift;
	$self->_printPretty($self->{root}, "\n");
}

################################################################################
# _printPretty
################################################################################
sub _printPretty {
	my ($self, $focusNode, $prefix) = @_;
	if ($focusNode) {
		print $prefix . "├── " . $focusNode->{key};
		$self->_printPretty($focusNode->{leftChild},  $prefix . "│  (L) ");
		$self->_printPretty($focusNode->{rightChild}, $prefix . "│  (R) ");
	}
}

1;
