"
I represent the abstract parent of model entities that contains sets of cards, namely Decks and Hands.

Todo: push up shared methods from CardDeck, or make them abstract here and implement them in CardHand.
"
Class {
	#name : #AbstractCardSet,
	#superclass : #AbstractCardModelNamedEntity,
	#instVars : [
		'cards'
	],
	#category : #'IMAD-Cards-Model'
}

{ #category : #cards }
AbstractCardSet >> cardNamed: aString [
	| result |
	result := self cardsNamed: aString.
	self
		assert: result notEmpty
		description: 'no card exists named ' , aString.
	self
		assert: result size = 1
		description: 'multiple cards exist named ' , aString.
	^ result at: 1
]

{ #category : #cards }
AbstractCardSet >> cards [
	^ cards
]

{ #category : #cards }
AbstractCardSet >> cardsNamed: aString [
	^ self cards select: [:each | each name = aString]
]

{ #category : #cards }
AbstractCardSet >> size [
	^ self cards size
]

{ #category : #accessing }
AbstractCardSet >> tags [
	^ (self cards flatCollect: #tags) asSet asOrderedCollection
]