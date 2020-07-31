"
I test that a CardHand is properly synchronized with its CardDeck.

The Deck has cards with tags 'a' and 'b'.
The Hand is defined by the filter 'a' & not 'b'.
!Tests:
Adding a Card to a Hand adds it to the Deck, and ensures that the Card has the tags it needs to pass the Hand's Filter. The hand should automatically set all the positive tags (need to ask a filter for all its positive tags)

${method:name=CardHandTestExamples>>#addCardToHand}$

Adding a Relation to a Hand adds it to the Deck. (The source and target already must be in the Hand.)
${method:name=CardHandTestExamples>>#addRelationToHand}$

Adding a Card or Relation to a Deck might add it to the Hand. The Filter will need to be reevaluated.
${method:name=CardHandTestExamples>>#addCardToDeck}$

${method:name=CardHandTestExamples>>#addRelationToDeck}$

Deleting a Card or Relation from a Deck deletes it from the Hand.
${method:name=CardHandTestExamples>>#deleteCardFromDeck}$

${method:name=CardHandTestExamples>>#deleteRelationFromDeck}$

Deleting a Card or Relation  from a Hand also deletes it from the Deck.
${method:name=CardHandTestExamples>>#deleteCardFromHand}$

${method:name=CardHandTestExamples>>#deleteRelationFromHand}$

Adding a tag to a card or removing it may remove it from the hand (and add it to another hand) -- need test with two hands

${method:name=CardHandTestExamples>>#addTagToCard}$

${method:name=CardHandTestExamples>>#deleteTagFromCard}$


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
CardHandTestExamples >> addCardToDeck [
	"Adding a Card or Relation to a Deck might add it to the Hand. The Filter will need to be reevaluated.
	Adding a new Card directly to a deck should trigger a CardsUpdated event, causing the Hand to invalidate (and recompute) its Cards."

	<gtExample>
	self assert: (hand cardsNamed: 'a3') isEmpty.
	self assert: (deck cardsNamed: 'a3') isEmpty.
	deck
		addCard:
			(Card new
				name: 'a3';
				addTag: 'a';
				yourself).
	deck
		addCard:
			(Card new
				name: 'b3';
				addTag: 'b';
				yourself).
	self assert: (hand cardsNamed: 'a3') size equals: 1.
	self assert: (deck cardsNamed: 'a3') size equals: 1.
	self assert: (hand cardsNamed: 'b3') size equals: 0.
	self assert: (deck cardsNamed: 'b3') size equals: 1.
	^ hand
]

{ #category : #accessing }
CardHandTestExamples >> addCardToHand [
	"Adding a Card to a Hand adds it to the Deck, and ensures that the Card has the tags it needs to pass the Hand's Filter. The hand should automatically set all the positive tags (need to ask a filter for all its positive tags)"

	<gtExample>
	self assert: (hand cardsNamed: 'a3') isEmpty.
	self assert: (deck cardsNamed: 'a3') isEmpty.

	"The tag 'a' should be automatically added"
	
	hand
		addCard:
			(Card new
				name: 'a3';
				"addTag: 'a';"
				yourself).
				
				
				
	self assert: (hand cardsNamed: 'a3') size equals: 1.
	self assert: (deck cardsNamed: 'a3') size equals: 1.
	^ hand
]

{ #category : #accessing }
CardHandTestExamples >> addRelationToDeck [

"Adding a Card or Relation to a Deck might add it to the Hand.
The Filter will need to be reevaluated."

	<gtExample>
	self notYetImplemented

]

{ #category : #accessing }
CardHandTestExamples >> addRelationToHand [
	
	
"Adding a Relation to a Hand adds it to the Deck. (The source and target already must be in the Hand.)"
	


	<gtExample>
	self notYetImplemented

]

{ #category : #accessing }
CardHandTestExamples >> addTagToCard [
	"Adding a tag to a card or removing it may remove it from the hand (and add it to another hand) -- need test with two hands"

	<gtExample>
	self notYetImplemented
]

{ #category : #accessing }
CardHandTestExamples >> deleteCardFromDeck [
"Deleting a Card or Relation from a Deck deletes it from the Hand."


	<gtExample>
	self notYetImplemented

]

{ #category : #accessing }
CardHandTestExamples >> deleteCardFromHand [
"Deleting a Card or Relation  from a Hand also deletes it from the Deck."


	<gtExample>
	self notYetImplemented

]

{ #category : #accessing }
CardHandTestExamples >> deleteRelationFromDeck [
	"Deleting a Card or Relation from a Deck deletes it from the Hand."

	<gtExample>
	self notYetImplemented
]

{ #category : #accessing }
CardHandTestExamples >> deleteRelationFromHand [
	"Deleting a Card or Relation  from a Hand also deletes it from the Deck."

	<gtExample>
	self notYetImplemented
]

{ #category : #accessing }
CardHandTestExamples >> deleteTagFromCard [
	"Adding a tag to a card or removing it may remove it from the hand (and add it to another hand) -- need test with two hands"

	<gtExample>
	self notYetImplemented

]

{ #category : #accessing }
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
				name: 'ac1';
				description: 'To do';
				addTag: 'a';
				addTag: 'c';
				yourself);
		addCard:
			(Card new
				name: 'ac2';
				description: 'To do';
				addTag: 'a';
				addTag: 'c';
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
		addCard:
			(Card new
				name: 'c1';
				description: 'To do';
				addTag: 'c';
				yourself);
		addCard:
			(Card new
				name: 'c2';
				description: 'To do';
				addTag: 'c';
				yourself);
		addRelation: 'a-ab' fromCardNamed: 'a1' toCardNamed: 'ab1';
		addRelation: 'a-a' fromCardNamed: 'a1' toCardNamed: 'a2';
		addRelation: 'a-b' fromCardNamed: 'a1' toCardNamed: 'b1';
		addRelation: 'a-ac' fromCardNamed: 'a1' toCardNamed: 'ac1';
		addRelation: 'a-ac' fromCardNamed: 'a1' toCardNamed: 'ac2';
		addRelation: 'ab-c' fromCardNamed: 'ab1' toCardNamed: 'c2';
		addRelation: 'ab-ab'
			fromCardNamed: 'ab1'
			toCardNamed: 'ab2';
		addRelation: 'b-b' fromCardNamed: 'b1' toCardNamed: 'b2';
		addRelation: 'b-c' fromCardNamed: 'b1' toCardNamed: 'c1';
		yourself
]

{ #category : #accessing }
CardHandTestExamples >> handHasFourCards [
	<gtExample>
	self assert: hand cards size equals: 4.
	self assert: (hand cardsNamed: 'a1') size equals: 1.
	self assert: (hand cardsNamed: 'a2') size equals: 1.
	self assert: (hand cardsNamed: 'ac1') size equals: 1.
	self assert: (hand cardsNamed: 'ac2') size equals: 1.
	self assert: (hand cardsNamed: 'ab1') isEmpty.
	self assert: (hand cardsNamed: 'b1') isEmpty.
	self assert: (hand cardsNamed: 'c1') isEmpty.
	^ hand
]

{ #category : #accessing }
CardHandTestExamples >> handHasThreeRelations [
	<gtExample>
	self assert: hand relations size equals: 3.
	self
		assert: (hand relationsMatching: 'a-a' asRelNameFilter) size
		equals: 1.
	self
		assert: (hand relationsMatching: 'a-ac' asRelNameFilter) size
		equals: 2.
	^ hand
]

{ #category : #accessing }
CardHandTestExamples >> initialize [
	deck := self exampleDeck.
	hand := CardHand new
		deck: deck
		filter: 'a' asTagFilter & ('b' asTagFilter not)
]
