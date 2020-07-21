"
I provide a dedicated view for a ${class:Card}$ instance.
"
Class {
	#name : #CardElement,
	#superclass : #BlElement,
	#traits : 'TCardModelElement',
	#classTraits : 'TCardModelElement classTrait',
	#instVars : [
		'card',
		'isEditable'
	],
	#category : #'IMAD-Cards-View'
}

{ #category : #accessing }
CardElement >> beEditable [
	isEditable := true.
	self removeChildren.
	self
		addChild:
			(card buildLabel
				constraintsDo: [ :c | 
					c frame horizontal alignCenter.
					c frame vertical alignCenter ];
				yourself)
]

{ #category : #accessing }
CardElement >> beText [
	isEditable := false.
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
				yourself)
]

{ #category : #accessing }
CardElement >> card [
	^ card
]

{ #category : #accessing }
CardElement >> card: aCard [
	card := aCard.
	self updateCard
]

{ #category : #accessing }
CardElement >> contextMenu [
	| menu |
	menu := BrGlamorousSimpleContextMenuContent new
		items:
			{('Rename card'
				-> [ isEditable
						ifFalse: [ self beEditable ] ]).
			('Inspect card' -> [ card inspect ]).
			('Delete card'
				-> [ menu anchor: BlElement new.
					card delete ])};
		yourself.
	^ menu
]

{ #category : #accessing }
CardElement >> initialize [
	<todo:
		'
- edges
    - implement a better layout along the shortest path between the centers
    - add space between multiple edges along same path
    - add tooltip with name

'>
	super initialize.
	card := Card new.
	isEditable := false.
	self
		layout: BlFrameLayout new;
		geometry: BlRectangle new;
		background: Color white;
		constraintsDo: [ :c | 
			c horizontal fitContent.
			c vertical fitContent ];
		padding: (BlInsets all: 5).
	self
		viewModel: (BrInteractiveModel with: BrHoverModel new);
		look:
			(BrInteractiveCommonLook new
				default: [ :elt | elt border: (BlBorder paint: Color black width: 1) ];
				hovered: [ :elt | elt border: (BlBorder paint: Color blue width: 1) ])
				+
					(VariableClickMenuLook content: [ self contextMenu ])
						useSecondaryMouseButton
				+
					((VariableClickMenuLook content: [ self contextMenu ])
						testModifier: #isCmd;
						yourself)
										+
					(BrGlamorousWithTooltipLook2 content: (self tooltipWithText: self card name)).
	self updateCard.
	self graph beNode.
	self addEventHandler: BlNoCtrlEventsPullHandler new.
	self addEventHandler: EdgeCreationHandler new.
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
	card name = card defaultName
		ifTrue: [ self beEditable ]
		ifFalse: [ self beText ].
	self graph model: card
]
