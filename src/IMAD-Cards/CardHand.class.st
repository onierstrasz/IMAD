"
I represent a subset of a Deck of Cards.
Usually I am the result of applying a Filter to a Deck (or Hand).
"
Class {
	#name : #CardHand,
	#superclass : #AbstractCardSet,
	#instVars : [
		'deck',
		'filter'
	],
	#category : #'IMAD-Cards-Model'
}

{ #category : #accessing }
CardHand >> cards [
	^ cards
]

{ #category : #accessing }
CardHand >> cards: aCardCollection [
	cards := aCardCollection
]

{ #category : #accessing }
CardHand >> deck [
	^ deck
]

{ #category : #accessing }
CardHand >> deck: aDeck [
	deck := aDeck.
	self invalidateCards 
]

{ #category : #accessing }
CardHand >> deck: aDeck filter: aFilter [
	deck := aDeck.
	filter := aFilter.
	self updateCards
]

{ #category : #accessing }
CardHand >> filter [
	^ filter
]

{ #category : #accessing }
CardHand >> filter: aFilter [
	filter := aFilter.
	self invalidateCards
]

{ #category : #initialization }
CardHand >> initialize [
	super initialize.
	deck := CardDeck new.
	filter := TrueFilter
]

{ #category : #accessing }
CardHand >> invalidateCards [
	self cards: nil
]

{ #category : #accessing }
CardHand >> updateCards [
	self assert: deck notNil description: 'deck should not be nil'.
	self assert: filter notNil description: 'filter should not be nil'.
	self cards: (self deck cards select: [ :card | self filter matches: card ])
]
