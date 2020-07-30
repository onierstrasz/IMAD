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
			{('Edit tags' -> [ self parent addChild: self popupTagger ]).
			('Rename card'
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
CardNodeView >> exampleWithTags [
	<gtExample>
	| aDeck aCard aNode |
	aDeck := CardDeck new.
	aCard := Card new
		name: 'Foobar';
		yourself.
	{'dog' . 'cat' . 'rabbit'} do: [ :word | aCard addTag: word ].
	aDeck addCard: aCard.
	aNode := CardNodeView new
		card: aCard;
		yourself.
	^ aNode
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
					((BrGlamorousWithContextMenuLook content: [ self popupTagger ])
						useSecondaryMouseButton;
						modifiersMatcher: #isCmd;
						yourself)
				+
					((BrGlamorousWithContextMenuLook
						content: [ |element| 
						element:= self card buildDescriptionPane.
						(element childNamed: #doc) fitContent; hExact: 300.
						element constraintsDo: [:c|
						c horizontal fitContent.
						c vertical fitContent].
						 element asScrollableElement ])
						usePrimaryMouseButton;
						modifiersMatcher: #isAlt yourself)
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
CardNodeView >> popupTagger [
	<todo: 'Most be a popup, not a child!'>
	| tagger |
	tagger := BlElement new
		layout: BlLinearLayout vertical;
		constraintsDo: [ :c | 
			c horizontal exact: 100.
			c vertical fitContent ].
	tagger addChild: card buildTagHeader.
	card announcer
		when: TagsUpdated
		do: [ tagger removeChildren.
			tagger addChild: card buildTagHeader ].
	^ tagger
	"self addChild: tagger"
]

{ #category : #accessing }
CardNodeView >> tooltipWithWrappingText: aString [
	| tooltip |
	tooltip := BlElement new
		layout: BlLinearLayout vertical;
		constraintsDo: [ :c | 
			c padding: (BlInsets all: 5).
			c vertical fitContent.
			c horizontal fitContent ].
	tooltip
		addChild:
			(BrEditor new
				look: BrGlamorousRegularEditorLook new;
				text: aString;
				hExact: 200;
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
