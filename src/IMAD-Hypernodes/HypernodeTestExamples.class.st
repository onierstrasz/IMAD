"
I provide some simple examples of Hypernode graphs to test basic functionality.
"
Class {
	#name : #HypernodeTestExamples,
	#superclass : #Object,
	#category : #'IMAD-Hypernodes-IMAD-Hypernodes'
}

{ #category : #accessing }
HypernodeTestExamples >> addComplexPropertiesToNode [
	<gtExample>
	<todo: 'test generated node equals self'>
	| node |
	node := self emptyNode.
	node set: #tags to: {'foo' . 'bar'} asOrderedCollection.
	node set: #nested to: self nestedProperties asDictionary.
	^ node
]

{ #category : #accessing }
HypernodeTestExamples >> addPropertyAbcToNode [
	<gtExample>
	| node key value |
	node := self emptyNode.
	self assert: node properties size equals: 0.
	key := 'abc'.
	value := 'xyz'.
	self assert: (node properties includesKey: key) not.
	node set: key to: value.
	self assert: node properties size equals: 1.
	self assert: (node properties includesKey: key).
	self assert: (node get: key) equals: value.
	^ node
]

{ #category : #accessing }
HypernodeTestExamples >> emptyNode [
	<gtExample>
	| root |
	root := Hypernode new.
	self assert: root nodes isEmpty.
	self assert: root isLeaf.
	self assert: root reachableNodes size equals: 1.
	"self assert: root isTree."
	root assertGeneratedValueEqualsSelf.
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
	c := root addNode.
	c node set: #name to: 'c'.
	c position: b position + (100 @ 0).
	d := root addNode.
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
	a := root addNode.
	a node set: #name to: 'a'.
	b := root addNode.
	b node set: #name to: 'b'.
	root addLink: a -> b.
	self assert: a node isLeaf.
	self assert: b node isLeaf.
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
HypernodeTestExamples >> nestedProperties [
	^ {(#a -> 1).
	(#b -> 2).
	(#c
		->
			{(#x -> 'hello').
			(#y -> {'hi' . 'there'} asOrderedCollection)} asDictionary)}
]

{ #category : #accessing }
HypernodeTestExamples >> simpleRecursiveNode [
	"A degenerate hypernode that contains itself as well as a link from itself to itself"

	<gtExample>
	| root |
	root := self emptyNode.
	root addNode: root.
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
	root addNode: self twoLevelGraph.
	root addNode: self twoLevelGraph.
	root addNode: self twoLevelGraph.
	self assert: root reachableNodes size equals: 22.
	self
		assert: (root reachableNodes select: #isLeaf) size
		equals: 12.
	self assert: root reachableEdges size equals: 6.
	"self assert: root isTree."
	root assertGeneratedValueEqualsSelf.
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
	root addNode: self flatGraphTwoNodes.
	root addNode: self flatGraphTwoNodes.
	self assert: root reachableNodes size equals: 7.
	self
		assert: (root reachableNodes select: #isLeaf) size
		equals: 4.
	self assert: root reachableEdges size equals: 2.
	"self assert: root isTree."
	root assertGeneratedValueEqualsSelf.
	^ root
]
