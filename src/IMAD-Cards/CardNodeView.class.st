"
I provide a dedicated view for a ${class:Card}$ instance.
"
Class {
	#name : #CardNodeView,
	#superclass : #BlElement,
	#instVars : [
		'card',
		'isEditable'
	],
	#category : #'IMAD-Cards-View'
}

{ #category : #accessing }
CardNodeView >> beEditable [
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
CardNodeView >> beText [
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
CardNodeView >> card [
	^ card
]

{ #category : #accessing }
CardNodeView >> card: aCard [
	card := aCard.
	self updateCard
]

{ #category : #accessing }
CardNodeView >> contextMenu [
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
CardNodeView >> initialize [
	<todo:
		'The tooltip is overriding the fixed width and appearing much wider than I want it to. How to fix?'>
	super initialize.
	card := Card new.
	isEditable := false.
	self
		layout: BlFrameLayout new;
		geometry: (BlRectangle cornerRadius: 4);
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
					((BrGlamorousWithContextMenuLook content: [ self contextMenu ])
						useSecondaryMouseButton;
						modifiersMatcher: #isEmpty;
						yourself)
				+
					((BrGlamorousWithContextMenuLook content: [ self contextMenu ])
						usePrimaryMouseButton;
						modifiersMatcher: #isCmd;
						yourself)
				+
					(BrGlamorousWithTooltipLook2
						content: [ self
								tooltipWithWrappingText: self card name , ': ' , self card description ]).
	self updateCard.
	self graph beNode.
	self addEventHandler: BlNoCtrlEventsPullHandler new.
	self addEventHandler: EdgeBuilder new.
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
CardNodeView >> tooltipWithText: aString [
	"From TCardModelElement"
	^ BrLabel new
		look: BrGlamorousLabelLook new glamorousRegularFontAndSize;
		padding: (BlInsets all: 5);
		alignCenter;
		text: aString asRopedText;
		yourself.
]

{ #category : #accessing }
CardNodeView >> tooltipWithWrappingText: aString [
	| tooltip |
	tooltip := BlElement new
		layout: BlLinearLayout vertical;
		constraintsDo: [ :c | 
			c padding: (BlInsets all: 5).
			c vertical fitContent.
			c horizontal exact: 200 ].
	tooltip
		addChild:
			(BrEditor new
				look: BrGlamorousRegularEditorLook new;
				text: aString;
				yourself).
	^ tooltip
]

{ #category : #accessing }
CardNodeView >> updateCard [
	card name = card defaultName
		ifTrue: [ self beEditable ]
		ifFalse: [ self beText ].
	self graph model: card
]
