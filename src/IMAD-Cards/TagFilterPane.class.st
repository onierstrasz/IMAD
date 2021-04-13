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
	| pane aHand |
	aHand := VirtualHand new
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

	<todod: 'fix assignment of look in return statement!'>
	| tooltipLook button buttonLooks nextState |
	button := BrButton new.
	button userData at: #state put: aState.
	tooltipLook := BrGlamorousWithTooltipAptitude2
		content: [ self
				tooltipWithText:
					({(#off -> 'Ignore').
					(#on -> 'Must be present').
					(#negated -> 'Must be absent')} asDictionary
						at: (button userData at: #state)) ].
	buttonLooks := {(#off
		-> (BrGlamorousButtonWithLabelAptitude + tooltipLook)).
	(#on
		->
			((BrGlamorousButtonLabelAptitude new
				bold;
				yourself)
				+ (BrGlamorousButtonExteriorAptitude new backgroundPaint: Color lightGreen)
				+ BrGlamorousButtonRectangularAptitude new + tooltipLook)).
	(#negated
		->
			((BrGlamorousButtonLabelAptitude new
				bold;
				yourself)
				+ (BrGlamorousButtonExteriorAptitude new backgroundPaint: Color pink)
				+ BrGlamorousButtonRectangularAptitude new + tooltipLook))}
		asDictionary.
	nextState := {(#off -> #on).
	(#on -> #negated).
	(#negated -> #off)} asDictionary.
	^ button
		look: (buttonLooks at: aState);
		label: aTagString;
		action: [ :e | 
			| newState |
			newState := nextState at: (button userData at: #state).
			button userData at: #state put: newState.
			e look: (buttonLooks at: newState).
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
			dict at: button label asString put: (button userData at: #state).
			dict ]
]

{ #category : #accessing }
TagFilterPane >> tooltipWithText: aString [
	"From TCardModelElement"
	^ BrLabel new
		look: BrGlamorousLabelAptitude new glamorousRegularFontAndSize;
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
					(aHand deck tags
						collect: [ :tag | 
							(dict keys includes: tag)
								ifTrue:
									[ self filterButtonForTag: tag withState: (dict at: tag) ]
								ifFalse: [ self filterButtonForTag: tag ] ]) ]
]
