"
I ama widget that holds a bunch of stateful buttons that represent tags that should be present or absent in the Cards displayed in the CardDeckGUI.

I generate a CardFilter  from the buttons to make the actual selection.
"
Class {
	#name : #TagFilterPane,
	#superclass : #BlElement,
	#instVars : [
		'announcer',
		'isEmpty'
	],
	#category : #'IMAD-Cards-View'
}

{ #category : #accessing }
TagFilterPane >> announcer [
	^ announcer
]

{ #category : #accessing }
TagFilterPane >> exampleWithTags [
	<gtExample>
	| aDeck aCard aNode aTagFilterPane |
	aDeck := CardDeck new.
	aCard := Card new
		name: 'Foobar';
		yourself.
	{'dog' . 'cat' . 'rabbit'} do: [ :word | aCard addTag: word ].
	aDeck addCard: aCard.
	aTagFilterPane := TagFilterPane new.
	aTagFilterPane updateTagFilterButtonsForDeck: aDeck.
	^ aTagFilterPane
]

{ #category : #accessing }
TagFilterPane >> filter [
	"Extract the buttons that have been clicked, and generate a conjunction of tag filters and negation filters."

	| activeButtons tagFilter |
	^ isEmpty
		ifTrue: [ TrueFilter new ]
		ifFalse: [ activeButtons := self children asOrderedCollection
				select: [ :each | (each userData at: #state) ~= #off ].
			activeButtons isEmpty
				ifTrue: [ TrueFilter new ]
				ifFalse: [ (activeButtons
						collect: [ :each | 
							tagFilter := each label asString asTagFilter.
							(each userData at: #state) = #negated
								ifTrue: [ tagFilter := tagFilter not ]
								ifFalse: [ self assert: (each userData at: #state) = #on ].
							tagFilter ]) reduce: [ :a :b | a & b ] ] ]
]

{ #category : #accessing }
TagFilterPane >> filterButtonForTag: aTagString [
	"State is #off, #on or #negated"

	| tooltip offLook onLook negatedLook tooltipLook button |
	button := BrButton new.
	tooltip := 'Ignore'.
	tooltipLook := BrGlamorousWithTooltipLook2
		content: [ self tooltipWithText: tooltip ].
	button userData at: #state put: #off.
	offLook := BrGlamorousButtonWithLabelLook + tooltipLook.
	onLook := (BrGlamorousButtonLabelLook new
		bold;
		yourself)
		+ (BrGlamorousButtonExteriorLook new backgroundPaint: Color lightGreen)
		+ BrGlamorousButtonRectangularLook new + tooltipLook.
	negatedLook := (BrGlamorousButtonLabelLook new
		bold;
		yourself)
		+ (BrGlamorousButtonExteriorLook new backgroundPaint: Color pink)
		+ BrGlamorousButtonRectangularLook new + tooltipLook.
	^ button
		look: offLook;
		label: aTagString;
		action: [ :e | 
			(button userData at: #state) = #off
				ifTrue: [ button userData at: #state put: #on.
					tooltip := 'Must be present'.
					e look: onLook ]
				ifFalse: [ (button userData at: #state) = #on
						ifTrue: [ button userData at: #state put: #negated.
							tooltip := 'Must be absent'.
							e look: negatedLook ]
						ifFalse: [ (button userData at: #state) = #negated
								ifTrue: [ button userData at: #state put: #off.
									tooltip := 'Ignore'.
									e look: offLook ] ] ].
			announcer announce: TagFilterUpdated ]
]

{ #category : #accessing }
TagFilterPane >> initialize [
	super initialize.
	announcer := Announcer new.
	self
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical fitContent ];
		padding: (BlInsets all: 5);
		margin:
			(BlInsets
				top: 0
				right: 5
				bottom: 0
				left: 5);
		border: (BlBorder paint: Color veryLightGray width: 1);
		layout: BlLinearLayout horizontal;
		yourself.
	self updateTagFilterButtonsForDeck: CardDeck new
]

{ #category : #accessing }
TagFilterPane >> tooltipWithText: aString [
	"From TCardModelElement"
	^ BrLabel new
		look: BrGlamorousLabelLook new glamorousRegularFontAndSize;
		padding: (BlInsets all: 5);
		alignCenter;
		text: aString asRopedText;
		yourself.
]

{ #category : #accessing }
TagFilterPane >> updateTagFilterButtonsForDeck: aDeck [
	<todo: 'We need a way to maintain the state between updates. It should be possible to set all the buttons based on the current filter state.'>
	self removeChildren.
	isEmpty := aDeck tags isEmpty.
	isEmpty
		ifTrue: [ self
				addChild: (BlTextElement new text: ('No tags found' asRopedText fontSize: 12)) ]
		ifFalse: [ self
				addChildren: (aDeck tags collect: [ :each | self filterButtonForTag: each ]) ]
]
