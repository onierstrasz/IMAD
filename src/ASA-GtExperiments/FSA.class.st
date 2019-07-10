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

{ #category : #tests }
FSA class >> eg4nodes [
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

{ #category : #ui }
FSA >> borderCircleWithLabel: aString [
	^ BlElement new
		layout: BlFrameLayout new;
		border: (BlBorder paint: Color black);
		geometry: BlCircle new;
		size: self defaultNodeSize;
		"when: BlClickEvent do: [ self inform: 'Click' ];"
		addChild:
			(BlTextElement new
				text: aString asRopedText;
				constraintsDo: [ :c | 
					c frame horizontal alignCenter.
					c frame vertical alignCenter ];
				yourself);
		yourself
]

{ #category : #accessing }
FSA >> current [
	^ current
]

{ #category : #ui }
FSA >> defaultNodeSize [
	^ 20@20
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
	current := target
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
	^ self next isEmpty
]

{ #category : #testing }
FSA >> isLive [
	^ self isDead not
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
	"FSA eg1 view"

	| mondrian |
	"TO DO:
	- highlight the current node (bold circle)
	- display edges as arrows"
	mondrian := GtMondrian new.
	mondrian nodes
		shape: [ :x | self borderCircleWithLabel: x asString ];
		with: self nodes.
	mondrian edges connectToAll: [ :x | self following: x ].
	mondrian layout circle.
	^ mondrian
]
