"
I represent a Finite State Automaton
"
Class {
	#name : #FSA,
	#superclass : #Object,
	#instVars : [
		'nodes',
		'start',
		'edges',
		'current',
		'edgeMap'
	],
	#category : #'ASA-GtExperiments'
}

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

{ #category : #'public interface' }
FSA >> go: target [
	self assertIsNode: target.
	self assert: (self next includes: target).
	current := target
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
	^ self next isEmpty
]

{ #category : #testing }
FSA >> isLive [
	^ self isDead not
]

{ #category : #accessing }
FSA >> next [
	^ edgeMap at: current
]

{ #category : #accessing }
FSA >> nodes [
	^ nodes
]

{ #category : #accessing }
FSA >> start [
	^ start
]
