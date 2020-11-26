Class {
	#name : #HypernodeExamples,
	#superclass : #Object,
	#category : #'IMAD-Hypernodes-IMAD-Hypernodes'
}

{ #category : #accessing }
HypernodeExamples >> emptyNode [
	<gtExample>
	|eg|
	eg := Hypernode new.
	self assert: eg nodes isEmpty.
	self assert: eg isLeaf.
	^ eg
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
	self assert: root reachableNodes size equals: 2.
	self assert: root reachableEdges size equals: 1.
	^ root
]

{ #category : #accessing }
HypernodeExamples >> nestedGraph [
	<gtExample>
	| root |
	root := self emptyNode.
	root addNode: self flatGraphTwoNodes.
	root addNode: self flatGraphTwoNodes.
	self assert: root reachableNodes size equals: 6.
	self assert: root reachableEdges size equals: 2.
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
