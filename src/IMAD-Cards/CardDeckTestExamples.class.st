"
I contain basic example to test the functionality of Cards and CardElements.

"
Class {
	#name : #CardDeckTestExamples,
	#superclass : #Object,
	#instVars : [
		'cardOneName',
		'cardTwoName'
	],
	#category : #'IMAD-Cards-Examples'
}

{ #category : #accessing }
CardDeckTestExamples >> addCardOneToDeck [
	<gtExample>
	| deck card |
	deck := self emptyDeck.
	self assert: (deck cardsNamed: cardOneName) isEmpty.
	
	card := Card new.
	card name: cardOneName;
		yourself.
	deck addCard: card.
	
	self assert: (deck cardsNamed: cardOneName) size equals: 1.
	self assert: (deck cardNamed: cardOneName) == card.
	^ deck
]

{ #category : #accessing }
CardDeckTestExamples >> addCardTwoWithDeckAPI [
	<gtExample>
	"Test compact interface to add cards"
	| deck card cardTwoDescription |
	cardTwoDescription := 'I am Card2'.
	deck := self addCardOneToDeck.
	deck addCardNamed: cardTwoName description: cardTwoDescription.
	card := (deck cardNamed: cardTwoName).

	self assert: deck size equals: 2.
	self assert: card name equals: cardTwoName.
	self assert: card description equals: cardTwoDescription.
	
	^ deck
	
]

{ #category : #accessing }
CardDeckTestExamples >> connectTwoCards [
	<todo: 'specify relationships'>
	<gtExample>
	"Test compact interface to add cards"
	| deck card1 card2 |
	deck := self addCardTwoWithDeckAPI.
	card1 := deck cardNamed: cardOneName.
	card2 := deck cardNamed: cardTwoName.

	card1 become: #friend of: card2. "can the same relationship be added multiple times?"
	
	self assert: (card2 hasA: #friend).
	self assert: (card1 isA: #friend).
	self assert: (card1 is: #friend of: card2).
	
	self assert: (deck relationships includes: #friend).
	
	^ deck
	

]

{ #category : #accessing }
CardDeckTestExamples >> emptyDeck [
	<gtExample>
	| deck |
	deck := CardDeck new.
	self assert: deck isEmpty.
	^ deck
]

{ #category : #accessing }
CardDeckTestExamples >> getCardOne [
	<gtExample>
	"Check that an added card has the right properties"
	| deck card |
	deck := self addCardOneToDeck.
	card := deck cardNamed: cardOneName.
	self assert: card name equals: cardOneName.
	self assert: card description equals: card defaultDescription.
	
	^ deck
]

{ #category : #accessing }
CardDeckTestExamples >> initialize [
	super initialize.
	cardOneName := 'Card1'.
	cardTwoName := 'Card2'.
	
]

{ #category : #accessing }
CardDeckTestExamples >> updateCardOneDescription [
	<gtExample>
	"Check that updates to a GtDocument view of a Card's description are propagated back to the Card."
	| deck card gtDoc newDescription |
	deck := self getCardOne.
	card := deck cardNamed: cardOneName.
	
	newDescription := 'An updated description.'.
	gtDoc := card asElement testingDictAt: #gtDocForDescription.
	gtDoc text: newDescription.
	gtDoc mayRequestDocumentUpdate.
	
	self assert: card description equals: newDescription.
	^ deck
]
