"
I ama widget that holds a bunch of stateful buttons that represent tags that should be present or absent in the Cards displayed in the CardDeckGUI.

I generate a CardFilter  from the buttons to make the actual selection.
"
Class {
	#name : #TagFilterPane,
	#superclass : #BlElement,
	#instVars : [
		'announcer',
		'hand'
	],
	#category : #'IMAD-Cards-View'
}

{ #category : #accessing }
TagFilterPane >> activeButtons [
	^ self isEmpty
		ifTrue: [ OrderedCollection new ]
		ifFalse: [ self children asOrderedCollection
				select: [ :each | (each userData at: #state) ~= #off ] ]
]

{ #category : #accessing }
TagFilterPane >> announcer [
	^ announcer
]

{ #category : #accessing }
TagFilterPane >> exampleDeckWithTags [
	<gtExample>
	^ TagFilterPane new
		updateTagFilterButtonsForDeck:
			(CardDeck new
				addCard:
					(Card new
						name: 'Foobar';
						addTags: {'dog' . 'cat' . 'rabbit'} yourself));
		yourself
]

{ #category : #accessing }
TagFilterPane >> exampleHandWithTags [
	<gtExample>
	<todo:
		'Should set the dog and minx tag buttons to on and negated'>
	| pane aHand |
	aHand := CardHand new
		deck:
			(CardDeck new
				addCard:
					(Card new
						name: 'Foobar';
						addTags: {'dog' . 'cat' . 'rabbit'};
						yourself));
		filter: 'dog' asTagFilter & 'minx' asTagFilter not;
		yourself.
	pane := TagFilterPane new.
	pane updateTagFilterButtonsForHand: aHand.
	self
		assert: pane tagStateDictionary
		equals:
			{('dog' -> #on).
			('minx' -> #negated)} asDictionary.
	^ pane
]

{ #category : #accessing }
TagFilterPane >> filter [
	"Extract the buttons that have been clicked, and generate a conjunction of tag filters and negation filters."

	^ self activeButtons
		inject: TrueFilter new
		into: [ :filterComposition :button | 
			| tagFilter |
			tagFilter := button label asString asTagFilter.
			(button userData at: #state) = #negated
				ifTrue: [ tagFilter := tagFilter not ]
				ifFalse: [ self assert: (button userData at: #state) equals: #on ].
			filterComposition & tagFilter ]
]

{ #category : #accessing }
TagFilterPane >> filterButtonForTag: aTagString [
	^ self filterButtonForTag: aTagString withState: #off
]

{ #category : #accessing }
TagFilterPane >> filterButtonForTag: aTagString withState: aState [
	"State is #off, #on or #negated"

	| tooltip offLook onLook negatedLook tooltipLook button |
	button := BrButton new.
	tooltip := 'Ignore'.
	tooltipLook := BrGlamorousWithTooltipLook2
		content: [ self tooltipWithText: tooltip ].
	button userData at: #state put: aState.
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
TagFilterPane >> hand [
	^ hand
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
TagFilterPane >> isEmpty [
	^ self hand tags isEmpty
]

{ #category : #accessing }
TagFilterPane >> tagStateDictionary [
	"Return a dictionary of tag states. This corresponds to a filter with only an intersection of postive and negative tags, not a union."

	^ self activeButtons
		inject: Dictionary new
		into: [ :dict :button | 
			self halt.
			dict at: button label put: (button userData at: #state).
			dict ]
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
	self updateTagFilterButtonsForHand: aDeck asHand
]

{ #category : #accessing }
TagFilterPane >> updateTagFilterButtonsForHand: aHand [
	<todo:
		'We need a way to maintain the state between updates. It should be possible to set all the buttons based on the current filter state.'>
	| dicts |
	self removeChildren.
	hand := aHand.
	dicts := hand filter tagDictionaries.
	self isEmpty
		ifTrue: [ self
				addChild: (BlTextElement new text: ('No tags found' asRopedText fontSize: 12)) ]
		ifFalse: [ | dict |
			self
				assert: dicts size = 1
				description:
					'For the moment we assume that filters are only intersections, not unions, so there should only be a single dictionary for a conjuction of tags and negated tags'.
			dict := dicts first.
			self
				addChildren:
					(aHand tags
						collect: [ :tag | 
							(dict keys includes: tag)
								ifTrue:
									[ self filterButtonForTag: tag withState: (dict at: tag) ]
								ifFalse: [ self filterButtonForTag: tag ] ]) ]
]
