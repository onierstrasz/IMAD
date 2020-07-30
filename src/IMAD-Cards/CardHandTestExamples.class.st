"
I test that a CardHand is properly synchronized with its CardDeck.

The Deck has cards with tags 'a' and 'b'.
The Hand is defined by the filter 'a' & not 'b'.

Adding a Card or Relation to a Hand adds it to the Deck.
Adding a Card or Relation to a Deck might add it to the Hand.
The Filter will need to be reevaluated.
Deleting a Card or Relation from a Deck deletes it from the Hand.
Deleting a Card or Relation  from a Hand also deletes it from the Deck.
"
Class {
	#name : #CardHandTestExamples,
	#superclass : #Object,
	#instVars : [
		'deck',
		'hand'
	],
	#category : #'IMAD-Cards-Examples'
}

{ #category : #accessing }
CardHandTestExamples >> addCardToHand [
	<gtExample>
	self assert: (hand cardsNamed: 'a3') isEmpty.
	self assert: (deck cardsNamed: 'a3') isEmpty.
	hand
		addCard:
			(Card new
				name: 'a3';
				addTag: 'a';
				yourself).
	self assert: (hand cardsNamed: 'a3') equals: 1.
	self assert: (deck cardsNamed: 'a3') equals: 1.
	^ hand
]

{ #category : #'as yet unclassified' }
CardHandTestExamples >> exampleDeck [
	<storedCardDeck>
	<gtExample>
	^ CardDeck new
		name: 'CardHandTestExample Deck';
		description:
			'I test that a CardHand is properly synchronized with its CardDeck.

Adding a Card or Relation to a Hand adds it to the Deck.
Adding a Card or Relation to a Deck might add it to the Hand.
The Filter will need to be reevaluated.
Deleting a Card or Relation from a Deck deletes it from the Hand.
Deleting a Card or Relation  from a Hand also deletes it from the Deck.';
		set: #storageClassName to: 'CardHandTestExamples';
		set: #storageMethodName to: 'exampleDeck';
		addCard:
			(Card new
				name: 'a1';
				description: 'To do';
				addTag: 'a';
				yourself);
		addCard:
			(Card new
				name: 'a2';
				description: 'To do';
				addTag: 'a';
				yourself);
		addCard:
			(Card new
				name: 'ab1';
				description: 'To do';
				addTag: 'a';
				addTag: 'b';
				yourself);
		addCard:
			(Card new
				name: 'ab2';
				description: 'To do';
				addTag: 'a';
				addTag: 'b';
				yourself);
		addCard:
			(Card new
				name: 'b1';
				description: 'To do';
				addTag: 'b';
				yourself);
		addCard:
			(Card new
				name: 'b2';
				description: 'To do';
				addTag: 'b';
				yourself);
		yourself
]

{ #category : #accessing }
CardHandTestExamples >> handHasFourCards [
	<gtExample>
	self assert: hand cards size equals: 2.
	self assert: (hand cardsNamed: 'a1') size equals: 1.
	self assert: (hand cardsNamed: 'a2') size equals: 1.
	self assert: (hand cardsNamed: 'ab1') isEmpty.
	self assert: (hand cardsNamed: 'b1') isEmpty.
	self assert: (hand cardsNamed: 'c1') isEmpty.
	^ hand
]

{ #category : #accessing }
CardHandTestExamples >> initialize [
	deck := self exampleDeck.
	hand := CardHand new
		deck: deck
		filter: 'a' asTagFilter & ('b' asTagFilter not)
]
