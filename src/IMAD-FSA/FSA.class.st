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

{ #category : #creation }
FSA class >> nodes: aCollection edges: anotherCollection start: anObject [
	^ FSA new
		initializeNodes: aCollection
		edges: anotherCollection
		start: anObject;
		yourself
]

{ #category : #ui }
FSA >> asElement [
	| element |
	element := FSAElement new.
	element fsa: self.
	^ element
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
FSA >> gtLiveFor: aView [
	<gtView>
	^ aView explicit
		title: 'FSA';
		priority: 10;
		stencil: [ self ]
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
