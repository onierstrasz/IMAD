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
HypernodeTestExamples >> flatGraphTwoNodes [
	"Root node with connected subnodes a and b"

	<todo: 'fix Hysenbug https://github.com/onierstrasz/IMAD/issues/32'>
	<gtExample>
	| root a b |
	root := self emptyNode.
	a := root addNode.
	"a set: #name to: 'a'."
	b := root addNode.
	"b set: #name to: 'b'."
	root addLink: a -> b.
	self assert: a isLeaf.
	self assert: b isLeaf.
	self assert: (a == b) not.
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
	p1 := 10@10.
	a position: p1.
	p2 := 50@50.
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
	a := root addNode.
	b := root addNode.
	c := root addNode.
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
