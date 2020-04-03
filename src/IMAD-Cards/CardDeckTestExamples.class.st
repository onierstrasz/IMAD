"
I contain basic example to test the functionality of Cards and CardElements.

"
Class {
	#name : #CardDeckTestExamples,
	#superclass : #Object,
	#instVars : [
		'cardOneName'
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
	deck add: card.
	
	self assert: (deck cardsNamed: cardOneName) size equals: 1.
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
	cardOneName := 'Card1'
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
