Class {
	#name : #HyperNode,
	#superclass : #Object,
	#instVars : [
		'parent',
		'children'
	],
	#category : #'IMAD-Hypergraphs'
}

{ #category : #accessing }
HyperNode class >> root [
	"Create an empty root node of a Hypergraph"

	^ self new
]

{ #category : #accessing }
HyperNode >> add: aHypernode [
	aHypernode parent: self.
	self children add: aHypernode
]

{ #category : #accessing }
HyperNode >> addNode [
	| aNode |
	aNode := HyperNode new.
	self add: aNode.
	^ aNode
]

{ #category : #accessing }
HyperNode >> allLeaves [
	| leaves |
	leaves := self leaves.
	leaves addAll: (self children flatCollect: #allLeaves).
	^ leaves
]

{ #category : #accessing }
HyperNode >> allSubgraphs [
	| subgraphs |
	subgraphs := self subgraphs.
	subgraphs addAll: (self children flatCollect: #allSubgraphs).
	^ subgraphs
]

{ #category : #accessing }
HyperNode >> children [
	^ children
]

{ #category : #accessing }
HyperNode >> depth [
	^ self isRoot
		ifTrue: [ 0 ]
		ifFalse: [ 1 + self parent depth ]
]

{ #category : #accessing }
HyperNode >> initialize [
	super initialize.
	parent := nil.
	children := OrderedCollection new
]

{ #category : #accessing }
HyperNode >> isLeaf [
	^ children isEmpty
]

{ #category : #accessing }
HyperNode >> isRoot [
	^ self parent = nil
]

{ #category : #accessing }
HyperNode >> isSubgraph [
	^ children notEmpty
]

{ #category : #accessing }
HyperNode >> leaves [
	^ children select: #isLeaf
]

{ #category : #accessing }
HyperNode >> parent [
	^ parent
]

{ #category : #accessing }
HyperNode >> parent: aHyperNode [
	<todo:
		'If I am not a root, then I should remove myself from my current parent first'>
	self assert: self isRoot.
	parent := aHyperNode
]

{ #category : #accessing }
HyperNode >> size [
	^ self children inject: 1 into: [ :sum :each | sum + each size ] 
]

{ #category : #accessing }
HyperNode >> subgraphs [
	^ children select: #isSubgraph
]

{ #category : #accessing }
HyperNode >> withAllSubgraphs [
	^ self allSubgraphs
		add: self;
		yourself
]
