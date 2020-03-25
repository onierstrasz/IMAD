"
I represent the logic of a Finite State Automaton.

To see a graphical view, send the view message to an instance, for example: 
	
	FSA eg4nodes view

	FSA eg10nodes view

"
Class {
	#name : #FSA,
	#superclass : #Model,
	#instVars : [
		'nodes',
		'start',
		'edges',
		'current',
		'edgeMap'
	],
	#category : #'IMAD-FSA'
}

{ #category : #tests }
FSA class >> eg10nodes [
	<gtExample>
	^ self
		nodes: (0 to: 10)
		edges:
			((0 to: 10)
				flatCollect: [ :x | 
					{(x -> (x * 3 \\ 10)).
					(x -> (x // 2))} ]) asOrderedCollection removeDuplicates
		start: 10
]

{ #category : #tests }
FSA class >> eg4nodes [
	<gtExample>
	^ self
		nodes: (1 to: 4)
		edges: { 1->2. 1->3. 2->3. 3->2. 3->4 }
		start: 1

]

{ #category : #creation }
FSA class >> nodes: aCollection edges: anotherCollection start: anObject [
	^ FSA new
		initializeNodes: aCollection
		edges: anotherCollection
		start: anObject;
		yourself
]

{ #category : #initialization }
FSA >> assertInvariant [
	self assert: nodes isCollection.
	self assert: edges isCollection.
	self assertIsNode: start.
	self edgeSources do: [ :each | self assertIsNode: each ].
	self edgeSinks do: [ :each | self assertIsNode: each ].

]

{ #category : #initialization }
FSA >> assertIsNode: anObject [
	self assert: (nodes includes: anObject)
]

{ #category : #accessing }
FSA >> current [
	^ current
]

{ #category : #accessing }
FSA >> edgeSinks [
	^ edgeMap values flatten
]

{ #category : #accessing }
FSA >> edgeSources [
	^ edgeMap keys
]

{ #category : #accessing }
FSA >> edges [
	^ edges
]

{ #category : #accessing }
FSA >> following: aNode [
	^ edgeMap at: aNode
]

{ #category : #'public interface' }
FSA >> go: target [
	self assertIsNode: target.
	self assert: (self next includes: target).
	current := target.
	self changed
]

{ #category : #ui }
FSA >> gtElement: aView [
	<gtView>
	^ aView explicit
		title: 'Element';
		stencil: [ self view ]
]

{ #category : #initialization }
FSA >> initialize [
	edgeMap := Dictionary new
]

{ #category : #initialization }
FSA >> initializeEdgeMap [
	nodes do: [  : each | 
		edgeMap at: each put: OrderedCollection new ].
	edges do: [ : each |
		self assertIsNode: each key.
		self assertIsNode: each value.
		(edgeMap at: each key) addLast: each value. ]
		
]

{ #category : #initialization }
FSA >> initializeNodes: aCollection edges: anotherCollection start: anObject [
	nodes := aCollection.
	edges := anotherCollection.
	start := anObject.
	current := start.
	self initializeEdgeMap.
	self assertInvariant.
]

{ #category : #testing }
FSA >> isDead [
	^ (self next isEmpty)
	or: [ self next size = 1 and: [ self next first == self current  ] ]
]

{ #category : #testing }
FSA >> isLive [
	^ self isDead not
]

{ #category : #'public interface' }
FSA >> isTarget: target [
	self assertIsNode: target.
	^ self next includes: target
]

{ #category : #accessing }
FSA >> next [
	^ self following: current
]

{ #category : #accessing }
FSA >> nodes [
	^ nodes
]

{ #category : #accessing }
FSA >> start [
	^ start
]

{ #category : #ui }
FSA >> view [
	"FSA eg4nodes view"

	^ FSAviewBuilder new viewFor: self

	"| mondrian controller |
	mondrian := GtMondrian new.
	mondrian nodes
		shape: [ :x | self borderCircleWithLabel: x asString ];
		with: self nodes.
	mondrian edges
		shape: [ :edge | self directedCurvedEdge ];
		fromNearestTightCircle;
		toNearestTightCircle;
		connectToAll: [ :x | self following: x ].
	mondrian layout circle.
	controller := FSAcontroller forModel: self andView: mondrian root.
	self addDependent: controller.
	^ mondrian"
]
