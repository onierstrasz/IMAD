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

{ #category : #accessing }
AbstractCardSet >> addRelation: aSymbol from: aSourceCard to: aTargetCard [
	self subclassResponsibility
]

{ #category : #relations }
AbstractCardSet >> addRelation: aSymbol fromCardNamed: sourceName toCardNamed: targetName [
	"Convenience method"
 	self addRelation: aSymbol from: (self cardNamed: sourceName) to: (self cardNamed: targetName)
]

{ #category : #accessing }
AbstractCardSet >> asElement [
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

{ #category : #accessing }
AbstractCardSet >> deleteCard: aCard [
	self subclassResponsibility
]

{ #category : #accessing }
AbstractCardSet >> deleteCardNamed: aString [
	self deleteCard: (self cardNamed: aString)
]

{ #category : #accessing }
AbstractCardSet >> deleteRelation: rel [
	self subclassResponsibility
]

{ #category : #accessing }
AbstractCardSet >> deleteRelation: aSymbol fromCardNamed: sourceName toCardNamed: targetName [
	| matches |
	matches := self
		relations: aSymbol
		fromCardNamed: sourceName
		toCardNamed: targetName.
	matches do: [ :rel | self deleteRelation: rel ]
]

{ #category : #'gt-extensions' }
AbstractCardSet >> gtLiveFor: aView [
	<gtView>
	^ aView explicit
		title: 'Live';
		priority: 5;
		stencil: [ self asElement ]
]

{ #category : #accessing }
AbstractCardSet >> hasCardNamed: aString [
	^ (self cardsNamed: aString) notEmpty
]

{ #category : #accessing }
AbstractCardSet >> hasRelation: aSymbol fromCardNamed: sourceName toCardNamed: targetName [
	"For testing"

	^ (self
		relations: aSymbol
		fromCardNamed: sourceName
		toCardNamed: targetName) size = 1
]

{ #category : #relations }
AbstractCardSet >> relations [
	^ relations
]

{ #category : #accessing }
AbstractCardSet >> relations: aSymbol fromCardNamed: sourceName toCardNamed: targetName [
	"NB: result could be empty, or could be multiple relations"

	| source target |
	source := self cardNamed: sourceName.
	target := self cardNamed: targetName.
	^ self
		relationsMatching:
			aSymbol asRelNameFilter & source sourceFilter & target targetFilter
]

{ #category : #querying }
AbstractCardSet >> relationsMatching: aFilter [
	^ self relations select: [:rel | aFilter matches: rel].
]

{ #category : #cards }
AbstractCardSet >> size [
	^ self cards size
]

{ #category : #accessing }
AbstractCardSet >> tags [
	^ (self cards flatCollect: #tags) asSet asOrderedCollection
]
