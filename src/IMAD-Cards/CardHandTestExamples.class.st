"
I test that a CardHand is properly synchronized with its CardDeck.

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
CardHandTestExamples >> deck [
	^ deck
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
		yourself
]

{ #category : #accessing }
CardHandTestExamples >> initialize [
	deck := self exampleDeck
]
