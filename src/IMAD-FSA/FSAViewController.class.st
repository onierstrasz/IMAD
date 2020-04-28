"
I am a view of an FSA.

I also handle update events.

I color the current state of the FSA as a green node in the view.
I gather mouse click events from the view, and interpret them as transition requests.
If the model accepts the transition as valid, I update the view.
If the FSA is dead, I color the current state as red instead of green.
"
Class {
	#name : #FSAViewController,
	#superclass : #Object,
	#instVars : [
		'fsa',
		'mondrian',
		'colouredNodes',
		'nodeMap'
	],
	#category : #'IMAD-FSA'
}

{ #category : #ui }
FSAViewController >> borderCircleWithLabel: aString [
	^ BlElement new
		layout: BlFrameLayout new;
		border: (BlBorder paint: Color black);
		geometry: BlCircle new;
		size: self defaultNodeSize;
		addChild:
			(BlTextElement new
				text: aString asRopedText;
				constraintsDo: [ :c | 
					c frame horizontal alignCenter.
					c frame vertical alignCenter ];
				yourself);
		yourself
]

{ #category : #ui }
FSAViewController >> clearFSAstateColors [
	colouredNodes do: [ :each | each background: Color white ].
	colouredNodes := OrderedCollection new
]

{ #category : #events }
FSAViewController >> clickOn: aNodeElement [
	| node |
	node := aNodeElement graph model.
	(fsa isTarget: node)
		ifTrue: [ fsa go: node ]
		ifFalse: [ self inform: node asString , ' is not a valid target' ]
]

{ #category : #defaults }
FSAViewController >> deadColor [
	^ Color red
]

{ #category : #defaults }
FSAViewController >> defaultNodeSize [
	^ 20@20
]

{ #category : #ui }
FSAViewController >> directedCurvedEdge [
	^ BlParabollaArcElement new
		zIndex: 0;
		curvatureFraction: 0.2;
		border: (BlBorder paint: Color gray width: 2);
		toHead:
			(BlArrowheadSimpleArrow new
				border:
					(BlBorder builder
						paint: Color gray;
						width: 2;
						build))
]

{ #category : #ui }
FSAViewController >> directedEdge [
	^ BlParabollaArcElement new
		zIndex: 0;
		curvatureFraction: 0;
		border: (BlBorder paint: Color gray width: 2);
		toHead:
			(BlArrowheadSimpleArrow new
				border:
					(BlBorder builder
						paint: Color gray;
						width: 2;
						build))
]

{ #category : #acccessing }
FSAViewController >> fsa [
	^ fsa
]

{ #category : #initialization }
FSAViewController >> handleClickEvents [
	self viewNodes
		do: [ :aNode | aNode when: BlClickEvent do: [ self clickOn: aNode ] ]
]

{ #category : #utilities }
FSAViewController >> inform: aString [
	<todo:
		'instead post this information inside the content pane (make hidden with a checkbox)'>
	| aSpace aText |
	aText := BlRopedText string: aString.
	aSpace := BlSpace new.
	aSpace title: aString.
	aSpace extent: 500 @ 50.
	aSpace addChild: (BlTextElement new text: aText).
	aSpace withHalos.
	aSpace show
]

{ #category : #accessing }
FSAViewController >> initialize [
	super initialize.
	colouredNodes := OrderedCollection new.
	nodeMap := IdentityDictionary new
]

{ #category : #initialization }
FSAViewController >> initializeNodeMap [
	"build a dictionary mapping model nodes to view nodes"

	mondrian root children
		do: [ :each | 
			each graph isNode
				ifTrue: [ nodeMap at: each graph model put: each ] ]
]

{ #category : #defaults }
FSAViewController >> liveColor [
	^ (Color green darker alpha: 1)
]

{ #category : #defaults }
FSAViewController >> nextColor [
	^ Color orange
]

{ #category : #ui }
FSAViewController >> paintMondrianGraph [
	mondrian nodes
		shape: [ :x | self borderCircleWithLabel: x asString ];
		with: self fsa nodes.
	mondrian edges
		shape: [ :edge | self directedCurvedEdge ];
		fromNearestTightCircle;
		toNearestTightCircle;
		connectToAll: [ :x | self fsa following: x ].
	mondrian layout circle.
	^ mondrian
]

{ #category : #ui }
FSAViewController >> setFSAstateColors [
	| currentNode |
	currentNode := nodeMap at: fsa current.
	colouredNodes add: currentNode.
	currentNode
		background:
			(fsa isLive
				ifTrue: [ self liveColor ]
				ifFalse: [ self deadColor ]).
	fsa isLive
		ifTrue: [ fsa next
				do: [ :each | 
					| node |
					node := nodeMap at: each.
					colouredNodes add: node.
					node background: self nextColor ] ]
]

{ #category : #events }
FSAViewController >> update: anFSA [
	"Called when the FSA is changed"
	self clearFSAstateColors.
	self setFSAstateColors
]

{ #category : #initialization }
FSAViewController >> viewForFSA: anFSA with: aMondrian [
	fsa := anFSA.
	mondrian := aMondrian.
	self paintMondrianGraph.
	self initializeNodeMap.
	self setFSAstateColors.
	self handleClickEvents.
	self fsa addDependent: self.
]

{ #category : #initialization }
FSAViewController >> viewNodes [
	^ mondrian root children select: [ :each | each graph isNode ]
]
