"
I am a view of an FSA.

I also handle update events.

I color the current state of the FSA as a green node in the view.
I gather mouse click events from the view, and interpret them as transition requests.
If the model accepts the transition as valid, I update the view.
If the FSA is dead, I color the current state as red instead of green.
"
Class {
	#name : #FSAView,
	#superclass : #BlElement,
	#instVars : [
		'fsa',
		'contents',
		'fsaCurrentState',
		'viewNodes'
	],
	#category : #'IMAD-FSA'
}

{ #category : #ui }
FSAView >> borderCircleWithLabel: aString [
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
FSAView >> buildContentPane [
	| mondrian |
	mondrian := GtMondrian new.
	mondrian nodes
		shape: [ :x | self borderCircleWithLabel: x asString ];
		with: self fsa nodes.
	mondrian edges
		shape: [ :edge | self directedCurvedEdge ];
		fromNearestTightCircle;
		toNearestTightCircle;
		connectToAll: [ :x | self fsa following: x ].
	mondrian layout circle.
	self handleClickEvents: mondrian root.
	self setFSAstateColor.
	self fsa addDependent: self.
	^ mondrian asElement
]

{ #category : #'view updates' }
FSAView >> clearFSAstateColor [
	self currentNode background: Color white
]

{ #category : #'view updates' }
FSAView >> clickOn: aNodeElement [
	| node |
	node := aNodeElement graph model.
	(fsa isTarget: node)
		ifTrue: [ fsa go: node ]
		ifFalse: [ self inform: node asString , ' is not a valid target' ]
]

{ #category : #acccessing }
FSAView >> currentNode [
	^ viewNodes detect: [ :each | each graph model = fsaCurrentState ]
]

{ #category : #defaults }
FSAView >> deadColor [
	^ Color red
]

{ #category : #defaults }
FSAView >> defaultNodeSize [
	^ 20@20
]

{ #category : #ui }
FSAView >> directedCurvedEdge [
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
FSAView >> directedEdge [
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
FSAView >> fsa [
	^ fsa
]

{ #category : #acccessing }
FSAView >> fsa: anFSA [
	fsa := anFSA.
	fsaCurrentState := fsa current.
	self updateContent 
]

{ #category : #'ui requests' }
FSAView >> handleClickEvents: aView [
	viewNodes := aView children select: [ :each | each graph isNode ].
	viewNodes
		do: [ :aNode | aNode when: BlClickEvent do: [ self clickOn: aNode ] ].
]

{ #category : #'ui requests' }
FSAView >> inform: aString [
	| aSpace aText |
	aText := BlRopedText string: aString.
	aSpace := BlSpace new.
	aSpace title: aString.
	aSpace extent: 500 @ 50.
	aSpace addChild: (BlTextElement new text: aText).
	aSpace withHalos.
	aSpace show
]

{ #category : #initialization }
FSAView >> initialize [
	super initialize.
	self
		layout: BlLinearLayout vertical;
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical matchParent ]
]

{ #category : #defaults }
FSAView >> liveColor [
	^ (Color green darker alpha: 1)
]

{ #category : #'view updates' }
FSAView >> setFSAstateColor [
	self currentNode
		background:
			(fsa isLive
				ifTrue: [ self liveColor ]
				ifFalse: [ self deadColor ])
]

{ #category : #'view updates' }
FSAView >> update: anFSA [
	self clearFSAstateColor.
	fsaCurrentState := fsa current.
	self setFSAstateColor
]

{ #category : #'view updates' }
FSAView >> updateContent [
	"Called when the fsa is set."
	contents ifNotNil: #removeFromParent.
	contents := self buildContentPane.
	self addChildFirst: contents
]
