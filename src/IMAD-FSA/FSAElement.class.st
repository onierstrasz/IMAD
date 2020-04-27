"
I am a view of an FSA.

I also handle update events.

I color the current state of the FSA as a green node in the view.
I gather mouse click events from the view, and interpret them as transition requests.
If the model accepts the transition as valid, I update the view.
If the FSA is dead, I color the current state as red instead of green.
"
Class {
	#name : #FSAElement,
	#superclass : #BlElement,
	#instVars : [
		'fsa',
		'contents',
		'view',
		'fsaCurrentState',
		'viewNodes'
	],
	#category : #'IMAD-FSA'
}

{ #category : #ui }
FSAElement >> borderCircleWithLabel: aString [
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
FSAElement >> buildContentPane [
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
FSAElement >> clearFSAstateColor [
	self currentNode background: Color white
]

{ #category : #'view updates' }
FSAElement >> clickOn: aNodeElement [
	| node |
	node := aNodeElement graph model.
	(fsa isTarget: node)
		ifTrue: [ fsa go: node ]
		ifFalse: [ self inform: node asString , ' is not a valid target' ]
]

{ #category : #acccessing }
FSAElement >> currentNode [
	^ viewNodes detect: [ :each | each graph model = fsaCurrentState ]
]

{ #category : #defaults }
FSAElement >> deadColor [
	^ Color red
]

{ #category : #defaults }
FSAElement >> defaultNodeSize [
	^ 20@20
]

{ #category : #ui }
FSAElement >> directedCurvedEdge [
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
FSAElement >> directedEdge [
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
FSAElement >> fsa [
	^ fsa
]

{ #category : #acccessing }
FSAElement >> fsa: anFSA [
	fsa := anFSA.
	fsaCurrentState := fsa current.
	self updateContent 
]

{ #category : #'ui requests' }
FSAElement >> handleClickEvents: aView [
	view := aView.
	viewNodes := view children select: [ :each | each graph isNode ].
	viewNodes
		do: [ :aNode | aNode when: BlClickEvent do: [ self clickOn: aNode ] ].
]

{ #category : #'ui requests' }
FSAElement >> inform: aString [
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
FSAElement >> initialize [
	super initialize.
	self
		layout: BlLinearLayout vertical;
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical matchParent ]
]

{ #category : #defaults }
FSAElement >> liveColor [
	^ (Color green darker alpha: 1)
]

{ #category : #'view updates' }
FSAElement >> setFSAstateColor [
	self currentNode
		background:
			(fsa isLive
				ifTrue: [ self liveColor ]
				ifFalse: [ self deadColor ])
]

{ #category : #'view updates' }
FSAElement >> update: anFSA [
	self clearFSAstateColor.
	fsaCurrentState := fsa current.
	self setFSAstateColor
]

{ #category : #'view updates' }
FSAElement >> updateContent [
	"Called when the fsa is set."
	contents ifNotNil: #removeFromParent.
	contents := self buildContentPane.
	self addChildFirst: contents
]
