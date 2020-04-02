"
I contain basic example to test the functionality of Cards and CardElements.

"
Class {
	#name : #CardExamples,
	#superclass : #Object,
	#instVars : [
		'cardOneName'
	],
	#category : #'IMAD-Cards-Examples'
}

{ #category : #accessing }
CardExamples >> addCardOneToDeck [
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
CardExamples >> emptyDeck [
	<gtExample>
	| deck |
	deck := Deck new.
	self assert: deck isEmpty.
	^ deck
]

{ #category : #accessing }
CardExamples >> initialize [
	super initialize.
	cardOneName := 'Card1'
]

{ #category : #accessing }
CardExamples >> updateCardOneDescription [
	<gtExample>
	"Check that updates to a GtDocument view of a Card's description are propagated back to the Card."
	| deck card gtDoc newDescription |
	deck := self addCardOneToDeck.
	card := deck cardNamed: cardOneName.
	newDescription := 'An updated description.'.
	self assert: card description equals: card defaultDescription.
	
	gtDoc := card asElement testingDictAt: #gtDocForDescription.
	gtDoc text: newDescription.
	gtDoc mayRequestDocumentUpdate.
	self assert: card description equals: newDescription.

	^ deck
]
