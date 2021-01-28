"
I provide some simple examples of Hypernode graphs to test basic functionality.
"
Class {
	#name : #HypernodeTestExamples,
	#superclass : #Object,
	#category : #'IMAD-Hypernodes-IMAD-Hypernodes'
}

{ #category : #accessing }
HypernodeTestExamples >> addPropertyAbcToNode [
	<gtExample>
	| root key value |
	root := self emptyNode.
	self assert: root properties size equals: 0.
	key := #abc.
	value := 'xyz'.
	self assert: (root properties includesKey: key) not.
	root set: key to: value.
	self assert: root properties size equals: 1.
	self assert: (root properties includesKey: key).
	self assert: (root get: key) equals: value.
	^ root
]

{ #category : #accessing }
HypernodeTestExamples >> emptyNode [
	<gtExample>
	| root |
	root := Hypernode root.
	self assert: root isRoot.
	self assert: root nodes isEmpty.
	self assert: root isLeaf.
	self assert: root reachableNodes size equals: 1.
	"self assert: root isTree."
	root assertGeneratedValueEqualsSelf.
	^ root
]

{ #category : #accessing }
HypernodeTestExamples >> emptyRootWithComplexPropertiesEqualsSelf [
	<gtExample>
	| root |
	root := self emptyNode.
	root set: #tags to: {'foo' . 'bar'} asOrderedCollection.
	root set: #nested to: self nestedProperties.
	root assertInvariant.
	root assertGeneratedValueEqualsSelf.
	^ root
]

{ #category : #accessing }
HypernodeTestExamples >> flatGraphFindTwoNodes [
	<gtExample>
	| root a b |
	root := self flatGraphTwoNodes.
	a := root contextForNodeNamed: 'a'.
	self assert: a name equals: 'a'.
	b := root nodeNamed: 'b'.
	self assert: b name equals: 'b'.
	^ root
]

{ #category : #accessing }
HypernodeTestExamples >> flatGraphFourNodesFiveLinks [
	<gtExample>
	| root a b c d |
	root := self flatGraphWithPositionedNodes.
	a := root contexts first.
	b := root contexts second.
	self assert: (root hasLink: a -> b).
	c := root addNewNodeContext.
	c node set: #name to: 'c'.
	c position: b position + (100 @ 0).
	d := root addNewNodeContext.
	d position: b position + (0 @ 100).
	d node set: #name to: 'd'.
	root addLink: b -> c.
	root addLink: b -> d.
	root addLink: a -> d.
	root addLink: d -> c.
	^ root
]

{ #category : #accessing }
HypernodeTestExamples >> flatGraphFourNodesOneDeleted [
	<gtExample>
	| root a b c d |
	root := self flatGraphFourNodesFiveLinks.
	a := root contexts first.
	b := root contexts second.
	c := root contexts third.
	d := root contexts fourth.
	self assert: (root hasLink: a -> b).
	self assert: (root hasLink: a -> d).
	self assert: (root hasLink: b -> c).
	self assert: (root hasLink: b -> d).
	self assert: (root hasLink: d -> c).
	self assert: (root hasContext: b).
	root deleteContext: b.
	self assert: (root hasContext: b) not.
	self assert: (root hasLink: a -> b) not.
	self assert: (root hasLink: a -> d).
	self assert: (root hasLink: b -> c) not.
	self assert: (root hasLink: b -> d) not.
	self assert: (root hasLink: d -> c).
	^ root
]

{ #category : #accessing }
HypernodeTestExamples >> flatGraphTwoNodes [
	"Root node with connected subnodes a and b"

	<gtExample>
	| root a b |
	root := self emptyNode.
	"a := root addNewNodeContext."
	
	a := root addNode name: 'a'; yourself.
	b := root addNode name: 'b'; yourself.
	root addLink: a -> b.
	
	self assert: a node isLeaf.
	self assert: a name equals: 'a'.
	self assert: b node isLeaf.
	self assert: b name equals: 'b'.
	self assert: (a == b) not.
	
	self assert:  (root hasContext: a).
	self assert:  (root hasNode: a node).
	self assert:  (root hasContext: b).
	self assert:  (root hasNode: b node).
	
	self assert: (root hasLink: a -> b).
	self assert: root reachableNodes size equals: 3.
	self assert: (root reachableNodes select: #isLeaf) size equals: 2.
	self assert: root reachableEdges size equals: 1.
	"self assert: root isDAG."
	"self assert: root isTree."
	root assertGeneratedValueEqualsSelf.
	root allNodes do: [ :node | self assert: root == node root ].
	^ root
]

{ #category : #accessing }
HypernodeTestExamples >> flatGraphTwoNodesLinkDeletedAndRestored [
	<gtExample>
	| root a b |
	root := self flatGraphTwoNodes.
	a := root nodeNamed: 'a'.
	b := root nodeNamed: 'b'.
	self assert: (root hasLink: a -> b).
	root deleteLink: a -> b.
	self assert: (root hasLink: a -> b) not.
	root addLink: a -> b.
	self assert: (root hasLink: a -> b).
	^ root
]

{ #category : #accessing }
HypernodeTestExamples >> flatGraphWithNodeProperties [
	<gtExample>
	| root a b |
	root := self flatGraphTwoNodes.
	a := root nodes first.
	a set: #nested to: self nestedProperties.
	root assertGeneratedValueEqualsSelf.
	^ root
]

{ #category : #accessing }
HypernodeTestExamples >> flatGraphWithPositionedNodes [
	"Check that stored positions are restored."
	<gtExample>
	| root a b storedA storedB p1 p2 |
	root := self flatGraphTwoNodes.
	a := root contexts first.
	b := root contexts second.
	p1 := 50@50.
	a position: p1.
	p2 := 150@50.
	b position: p2.
	self assert: a position equals: p1.
	self assert: b position equals: p2.
	storedA := root generatedValue contexts first.
	storedB := root generatedValue contexts second.
	self assert: storedA position equals: p1.
	self assert: storedB position equals: p2.
	^ root
]

{ #category : #accessing }
HypernodeTestExamples >> fourNodeTree [
	<gtExample>
	| root a b c d |
	root := Hypernode root.
	a := root addNode name: 'a'; yourself.
	b := root addNode name: 'b'; yourself.
	c := root addNode name: 'c'; yourself.
	d := root addNode name: 'd'; yourself.
	root
		addLink: a -> b;
		addLink: b -> c;
		addLink: b -> d.
	^ root
]

{ #category : #accessing }
HypernodeTestExamples >> fourNodeTreeMiddleNodeDeleted [
	"This case resulted in a broken element dictionary"

	<gtExample>
	| root a b c d |
	root := self fourNodeTree.
	a := root contextForNodeNamed: 'a'.
	b := root contextForNodeNamed: 'b'.
	c := root contextForNodeNamed: 'c'.
	d := root contextForNodeNamed: 'd'.
	root deleteContext: b.
	^ root
]

{ #category : #accessing }
HypernodeTestExamples >> nestedProperties [
	<gtExample>
	^ {(#a -> 1).
	(#b -> 2).
	(#c
		->
			({(#x -> 'hello').
			(#y -> {'hi' . 'there'} asOrderedCollection)} as: KeyedTree))}
		as: KeyedTree
]

{ #category : #accessing }
HypernodeTestExamples >> simpleRecursiveNode [
	"A degenerate hypernode that contains itself as well as a link from itself to itself"

	<gtExample>
	| root |
	root := self emptyNode.
	root addContextForNode: root.
	root addLink: root -> root.
	self assert: root reachableNodes size equals: 1.
	self assert: root reachableEdges size equals: 1.
	root assertGeneratedValueEqualsSelf.
	^ root
]

{ #category : #accessing }
HypernodeTestExamples >> threeLevelGraph [
	<gtExample>
	| root |
	root := self emptyNode.
	root addContextForNode: self twoLevelGraph.
	root addContextForNode: self twoLevelGraph.
	root addContextForNode: self twoLevelGraph.
	root beRootForAllNodes.
	root allNodes do: [ :node | self assert: root == node root ].
	self assert: root reachableNodes size equals: 22.
	self assert: (root reachableNodes select: #isLeaf) size equals: 12.
	self assert: root reachableEdges size equals: 6.
	"self assert: root isTree."
	root assertGeneratedValueEqualsSelf.
	^ root
]

{ #category : #accessing }
HypernodeTestExamples >> threeLevelGraphAllNodesGenerateSameGraph [
	"Every node should generate the same graph, since they all have the same root. (Not true for a graph with multiple subroots.)"

	<gtExample>
	| root |
	root := self threeLevelGraph.
	root allNodes do: [ :node | self assert: root == node root ].
	root allNodes do: [ :node | self assert: node = node generatedValue ].
	root allNodes do: [ :node | self assert: root = node root generatedValue ].
	^ root
]

{ #category : #accessing }
HypernodeTestExamples >> threeNodeChain [
	<gtExample>
	| root a b c d |
	root := Hypernode root.
	a := root addNode name: 'a'; yourself.
	b := root addNode name: 'b'; yourself.
	c := root addNode name: 'c'; yourself.
	root
		addLink: a -> b;
		addLink: b -> c.
	^ root
]

{ #category : #accessing }
HypernodeTestExamples >> threeNodeChainMiddleNodeDeleted [
	"Ensure the right node is deleted"
	<gtExample>
	| root a b c |
	root := self threeNodeChain.
	a := root contextForNodeNamed: 'a'.
	b := root contextForNodeNamed: 'b'.
	c := root contextForNodeNamed: 'c'.
	self assert: a name equals: 'a'.
	self assert: b name equals: 'b'.
	self assert: c name equals: 'c'.
	root deleteContext: b.
	self assert: (root hasContext: a).
	self assert: (root hasContext: b) not.
	self assert: (root hasContext: c).
	^ root
]

{ #category : #accessing }
HypernodeTestExamples >> threeNodeChainSecondLinkDeleted [
	"Ensure the right link is deleted"

	<gtExample>
	| root a b c |
	root := self threeNodeChain.
	a := root contextForNodeNamed: 'a'.
	b := root contextForNodeNamed: 'b'.
	c := root contextForNodeNamed: 'c'.
	self assert: a name equals: 'a'.
	self assert: b name equals: 'b'.
	self assert: c name equals: 'c'.
	root deleteLink: b -> c.
	self assert: (root hasLink: a -> b).
	self assert: (root hasLink: b -> c) not.
	^ root
]

{ #category : #accessing }
HypernodeTestExamples >> threeNodeCycle [
	<gtExample>
	| root a b c |
	root := self emptyNode.
	a := root addNodeWithPosition: 10@10.
	b := root addNodeWithPosition: 100@10.
	c := root addNodeWithPosition: 45@60.
	root addLink: a -> b.
	root addLink: b -> c.
	root addLink: c -> a.
	self assert: root reachableNodes size equals: 4.
	root assertGeneratedValueEqualsSelf.
	^ root
]

{ #category : #accessing }
HypernodeTestExamples >> twoLevelGraph [
	<gtExample>
	| root |
	root := self emptyNode.
	root addContextForNode: self flatGraphTwoNodes.
	root addContextForNode: self flatGraphTwoNodes.
	root beRootForAllNodes.
	root allNodes do: [ :node | self assert: root == node root ].
	self assert: root reachableNodes size equals: 7.
	self assert: (root reachableNodes select: #isLeaf) size equals: 4.
	self assert: root reachableEdges size equals: 2.
	"self assert: root isTree."
	root assertGeneratedValueEqualsSelf.
	^ root
]
