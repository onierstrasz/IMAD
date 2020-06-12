Class {
	#name : #CardElement,
	#superclass : #CardDeckElement,
	#instVars : [
		'card',
		'xyz'
	],
	#category : #'IMAD-Cards-View'
}

{ #category : #accessing }
CardElement >> card: aCard [
	card := aCard.
	self updateCard
]

{ #category : #accessing }
CardElement >> initialize [
	<todo:
		'
- cards
    - right click to open menu
    - double click on background to add a Card
    - click on Card name to edit its name
- edges
    - implement a better layout along the shortest path between the centers
    - add space between multiple edges along same path
    - add tooltip with name
    - double click on edge to edit

'>
	super initialize.
	card := Card new.
	self
		layout: BlFrameLayout new;
		border: (BlBorder paint: Color black);
		geometry: BlRectangle new;
		background: Color white;
		constraintsDo: [ :c | 
			c horizontal fitContent.
			c vertical fitContent ];
		padding: (BlInsets all: 5).
	self updateCard.
	self graph beNode.
	self addEventHandler: BlNoCtrlEventsPullHandler new.
	self addEventHandler: EdgeCreationHandler new.
	self
		addEventHandler:
			(BlEventHandler
				on: BlClickEvent
				do: [ :evt | 
					evt modifiers isCmd
						ifTrue: [ "here we could replace the text by an editable label ..." ] ]).
	self
		addEventHandler:
			(BlEventHandler
				on: BlDoubleClickEvent
				do: [ :evt | 
					evt consumed: true.
					card inspect ]).
	^ self
]

{ #category : #accessing }
CardElement >> updateCard [
	self removeChildren.
	self
		addChild:
			((BlTextElement new
				text:
				(card name asRopedText
				fontSize: 12;
				glamorousCodeFont;
				yourself))
				constraintsDo: [ :c | 
					c frame horizontal alignCenter.
					c frame vertical alignCenter ];
				yourself).
	self graph model: card.
]
