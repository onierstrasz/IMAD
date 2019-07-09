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
FSA class >> eg1 [
	^ self
		nodes: (1 to: 4)
		edges: { 1->2. 1->3. 2->3. 3->2. 3->4 }
		start: 1

]

{ #category : #tests }
FSA class >> eg1view [
	<gtExample>
	^ self eg1 view

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
	^ self following: current
]

{ #category : #accessing }
FSA >> nodes [
	^ nodes
]

{ #category : #playgrounds }
FSA >> pgCircleGraph [

	"Just a place to store working script"

	GTPlayground openContents: '| eg view |
eg := FSA eg1.
view := GtMondrian new.

view nodes
	shape: [: x |
		BlElement new
			border: (BlBorder paint: Color black);
			geometry: BlCircle new;
			size: 40 @ 40
		];
	with: eg nodes
	.

view edges connectToAll: [ :x | eg following: x ].

view layout circle.
^ view

' label: 'Workspace'.
]

{ #category : #playgrounds }
FSA >> pgmlCircleWithText [

	"Snippet from manuel"

	GTPlayground openContents: 'BlElement
    new
        layout: BlFrameLayout new;
        background: (Color green darker alpha: 1);
        geometry: BlCircle new;
        when: BlClickEvent do: [ self inform: ''Click'' ];
        constraintsDo: [ :c | 
            c horizontal fitContent.
            c vertical matchParent ];
        addChild:
            (BlTextElement new
                text: ''hello world'' asRopedText;
                constraintsDo: [ :c | 
                    c frame horizontal alignCenter.
                    c frame vertical alignCenter.
                    c horizontal fitContent.
                    c vertical fitContent ];
                yourself);
        yourself

' label: 'Circle with text'.
]

{ #category : #accessing }
FSA >> start [
	^ start
]

{ #category : #mondrian }
FSA >> view [
	"FSA eg1 view"
	| view |
	"TO DO:
	- display nodes as circles
	- add labels to circles
	- highlight the current node (bold circle)
	- display edges as arrows"
	view := GtMondrian new.
	"view nodes with: self nodes."
	view nodes
		shape: [: x |
			BlElement new
				border: (BlBorder paint: Color black);
				geometry: BlCircle new;
				size: 10 @ 10
			];
		with: self nodes.
	view edges connectToAll: [ :x | self following: x ].
	view layout circle.
	^ view
]
