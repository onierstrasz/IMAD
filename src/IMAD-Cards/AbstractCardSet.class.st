"
I represent the abstract parent of model entities that contains sets of cards, namely Decks and Hands.

Todo: push up shared methods from CardDeck, or make them abstract here and implement them in CardHand.
"
Class {
	#name : #AbstractCardSet,
	#superclass : #AbstractCardModelNamedEntity,
	#instVars : [
		'cards',
		'relations'
	],
	#category : #'IMAD-Cards-Model'
}

{ #category : #accessing }
AbstractCardSet >> addCard: aCard [
	self subclassResponsibility
]

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
	"Mainly needed for testing purposes"

	^ self cards select: [ :each | each name = aString ]
]

{ #category : #relations }
AbstractCardSet >> relations [
	^ relations
]

{ #category : #querying }
AbstractCardSet >> relationsMatching: aFilter [
	^ relations select: [:rel | aFilter matches: rel].
]

{ #category : #cards }
AbstractCardSet >> size [
	^ self cards size
]

{ #category : #accessing }
AbstractCardSet >> tags [
	^ (self cards flatCollect: #tags) asSet asOrderedCollection
]
