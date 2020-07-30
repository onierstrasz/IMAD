"
I represent a subset of a Deck of Cards defined by a Filter.

The subsets of cards and relations are computed lazily. If either the Deck or the Filter is changed, the cards and relations subsets are invalidated.

If the Deck is modified (Cards or Relations updated) then the cards and relations are invalidated.

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
CardHand >> addCard: aCard [
	deck addCard: aCard.
	
]

{ #category : #accessing }
CardHand >> cards [
	cards ifNil: [ self updateCards ].
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
	self invalidateCardsAndRelations 
]

{ #category : #accessing }
CardHand >> deck: aDeck filter: aFilter [
	deck := aDeck.
	filter := aFilter
]

{ #category : #accessing }
CardHand >> filter [
	^ filter
]

{ #category : #accessing }
CardHand >> filter: aFilter [
	filter := aFilter.
	self invalidateCardsAndRelations
]

{ #category : #initialization }
CardHand >> initialize [
	super initialize.
	deck := CardDeck new.
	filter := TrueFilter.
	self subscribe
]

{ #category : #accessing }
CardHand >> invalidateCardsAndRelations [
	self cards: nil.
	self relations: nil
]

{ #category : #accessing }
CardHand >> relations [
	relations ifNil: [ self updateRelations ].
	^ relations
]

{ #category : #accessing }
CardHand >> relations: aRelation [
	relations := aRelation
]

{ #category : #initialization }
CardHand >> subscribe [
	self deck announcer
		when: CardsUpdated
		do: [ self invalidateCardsAndRelations ].
	self deck announcer
		when: RelationsUpdated
		do: [ self invalidateCardsAndRelations ]
]

{ #category : #accessing }
CardHand >> updateCards [
	self assert: deck notNil description: 'deck should not be nil'.
	self assert: filter notNil description: 'filter should not be nil'.
	self cards: (self deck cards select: [ :card | self filter matches: card ])
]

{ #category : #accessing }
CardHand >> updateRelations [

	self assert: deck notNil description: 'deck should not be nil'.
	self assert: filter notNil description: 'filter should not be nil'.
	
	self notYetImplemented


]
