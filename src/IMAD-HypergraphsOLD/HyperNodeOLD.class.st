Class {
	#name : #HyperNodeOLD,
	#superclass : #Object,
	#instVars : [
		'parent',
		'children'
	],
	#category : #'IMAD-HypergraphsOLD'
}

{ #category : #accessing }
HyperNodeOLD class >> root [
	"Create an empty root node of a Hypergraph"

	^ self new
]

{ #category : #accessing }
HyperNodeOLD >> add: aHypernode [
	aHypernode parent: self.
	self children add: aHypernode
]

{ #category : #accessing }
HyperNodeOLD >> addNode [
	| aNode |
	aNode := HyperNodeOLD new.
	self add: aNode.
	^ aNode
]

{ #category : #accessing }
HyperNodeOLD >> allLeaves [
	| leaves |
	leaves := self leaves.
	leaves addAll: (self children flatCollect: #allLeaves).
	^ leaves
]

{ #category : #accessing }
HyperNodeOLD >> allSubgraphs [
	| subgraphs |
	subgraphs := self subgraphs.
	subgraphs addAll: (self children flatCollect: #allSubgraphs).
	^ subgraphs
]

{ #category : #accessing }
HyperNodeOLD >> children [
	^ children
]

{ #category : #accessing }
HyperNodeOLD >> depth [
	^ self isRoot
		ifTrue: [ 0 ]
		ifFalse: [ 1 + self parent depth ]
]

{ #category : #accessing }
HyperNodeOLD >> initialize [
	super initialize.
	parent := nil.
	children := OrderedCollection new
]

{ #category : #accessing }
HyperNodeOLD >> isLeaf [
	^ children isEmpty
]

{ #category : #accessing }
HyperNodeOLD >> isRoot [
	^ self parent = nil
]

{ #category : #accessing }
HyperNodeOLD >> isSubgraph [
	^ children notEmpty
]

{ #category : #accessing }
HyperNodeOLD >> leaves [
	^ children select: #isLeaf
]

{ #category : #accessing }
HyperNodeOLD >> parent [
	^ parent
]

{ #category : #accessing }
HyperNodeOLD >> parent: aHyperNode [
	<todo:
		'If I am not a root, then I should remove myself from my current parent first'>
	self assert: self isRoot.
	parent := aHyperNode
]

{ #category : #accessing }
HyperNodeOLD >> size [
	^ self children inject: 1 into: [ :sum :each | sum + each size ] 
]

{ #category : #accessing }
HyperNodeOLD >> subgraphs [
	^ children select: #isSubgraph
]

{ #category : #accessing }
HyperNodeOLD >> withAllSubgraphs [
	^ self allSubgraphs
		add: self;
		yourself
]
