"
I represent a deck of cards.
I keep track of the cards and the relations between them.

TO DO:
The implementations of cards and relations are naive to start (collections). To scale up, we will need dictionaries to quickly look up cards and their relationships.
"
Class {
	#name : #CardDeck,
	#superclass : #Object,
	#instVars : [
		'cards',
		'relations'
	],
	#category : #'IMAD-Cards-Model'
}

{ #category : #accessing }
CardDeck >> addCard: aCard [
	cards add: aCard.
	aCard deck: self.
]

{ #category : #accessing }
CardDeck >> addCardNamed: cardName description: cardDescription [
	self addCard: (
		Card new
			name: cardName;
			description: cardDescription;
			yourself
		)
]

{ #category : #relations }
CardDeck >> addRelation: aSymbol from: aSourceCard to: aTargetCard [
	| rel |
	rel := CardRelation new.
	rel name: aSymbol;
		source: aSourceCard;
		target: aTargetCard.
	relations add: rel.
	^ rel
]

{ #category : #relations }
CardDeck >> addRelation: aSymbol fromCardNamed: sourceName toCardNamed: targetName [
	"Convenience method"
 	self addRelation: aSymbol from: (self cardNamed: sourceName) to: (self cardNamed: targetName)
]

{ #category : #accessing }
CardDeck >> cardNamed: aString [
	| result |
	result := cards select: [:each | each name = aString].
	self assert: result size equals: 1.
	^ result at: 1
]

{ #category : #relations }
CardDeck >> cardNamed: targetName become: aSymbol ofCardNamed: sourceName [
	"Convenience method"
 	self addRelation: aSymbol from: (self cardNamed: sourceName) to: (self cardNamed: targetName)
]

{ #category : #accessing }
CardDeck >> cards [
	^ cards
]

{ #category : #accessing }
CardDeck >> cardsNamed: aString [
	^ cards select: [:each | each name = aString]
]

{ #category : #gt }
CardDeck >> gtCardsFor: aView [
	<gtView>
	^ aView forward
		title: 'Cards';
		priority: 1;
		object: [ cards ];
		view: #gtItemsFor:
]

{ #category : #gt }
CardDeck >> gtRelationsFor: aView [
	<gtView>
	^ aView forward
		title: 'Relations';
		priority: 2;
		object: [ relations ];
		view: #gtItemsFor:
]

{ #category : #relations }
CardDeck >> hasRelation: aSymbol [
	^ (self relationsMatching:(CRRelNameFilter new name: aSymbol)) isNotEmpty
]

{ #category : #initialization }
CardDeck >> initialize [
	<todo: 'Instead of OrderedCollections, we will need more clever implementations for cards and relations.'>
	super initialize.
	cards := OrderedCollection new.
	relations := OrderedCollection new.
]

{ #category : #querying }
CardDeck >> isEmpty [
	^ cards isEmpty
]

{ #category : #gt }
CardDeck >> listTodos [
	<gtExample>
	^ #todo: gtPragmas & 'IMAD-Card' gtPackageMatches
]

{ #category : #relations }
CardDeck >> relations [
	<todo: 'hide this behind a Facade?'>
	^ relations
]

{ #category : #querying }
CardDeck >> relationsMatching: aFilter [
	^ relations select: [:rel | aFilter matches: rel].
]

{ #category : #accessing }
CardDeck >> size [
	^ cards size
]
