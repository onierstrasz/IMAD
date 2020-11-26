Class {
	#name : #HypernodeExamples,
	#superclass : #Object,
	#category : #'IMAD-Hypernodes-IMAD-Hypernodes'
}

{ #category : #accessing }
HypernodeExamples >> emptyNode [
	<gtExample>
	| root |
	root := Hypernode new.
	self assert: root nodes isEmpty.
	self assert: root isLeaf.
	self assert: root withReachableNodes size equals: 1.
	self assert: root reachableEdges size equals: 0.
	^ root
]

{ #category : #accessing }
HypernodeExamples >> flatGraphTwoNodes [
	"Root node with connected subnodes a and b"

	<gtExample>
	| root a b |
	root := self emptyNode.
	a := root addNode.
	b := root addNode.
	root addLink: a -> b.
	self assert: a isLeaf.
	self assert: b isLeaf.
	self assert: root withReachableNodes size equals: 3.
	self assert: (root withReachableNodes select: #isLeaf) size equals: 2.
	self assert: root reachableEdges size equals: 1.
	^ root
]

{ #category : #accessing }
HypernodeExamples >> simpleRecursiveNode [
	"A degenerate hypernode that contains itself as well as a link from itself to itself"

	<gtExample>
	| root |
	root := self emptyNode.
	root addNode: root.
	root addLink: root -> root.
	self assert: root reachableNodes size equals: 1.
	self assert: root reachableEdges size equals: 1.
	^ root
]

{ #category : #accessing }
HypernodeExamples >> threeLevelGraph [
	<gtExample>
	| root |
	root := self emptyNode.
	root addNode: self twoLevelGraph.
	root addNode: self twoLevelGraph.
	root addNode: self twoLevelGraph.
	self assert: root withReachableNodes size equals: 22.
	self
		assert: (root withReachableNodes select: #isLeaf) size
		equals: 12.
	self assert: root reachableEdges size equals: 6.
	^ root
]

{ #category : #accessing }
HypernodeExamples >> twoLevelGraph [
	<gtExample>
	| root |
	root := self emptyNode.
	root addNode: self flatGraphTwoNodes.
	root addNode: self flatGraphTwoNodes.
	self assert: root withReachableNodes size equals: 7.
	self
		assert: (root withReachableNodes select: #isLeaf) size
		equals: 4.
	self assert: root reachableEdges size equals: 2.
	^ root
]
