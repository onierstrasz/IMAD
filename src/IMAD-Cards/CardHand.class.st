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

{ #category : #cards }
CardHand >> addCard: aCard [
	aCard addTags: self filter positiveTags.
	deck addCard: aCard.
	self invalidateCardsAndRelations
]

{ #category : #accessing }
CardHand >> addRelation: aSymbol from: aSourceCard to: aTargetCard [
	self deck addRelation: aSymbol from: aSourceCard to: aTargetCard
]

{ #category : #accessing }
CardHand >> asElement [
	^ CardHandGUI new
		hand: self;
		yourself
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
CardHand >> cardsNil [
	"For testing purposes."
	^ cards isNil
]

{ #category : #relations }
CardHand >> containsRelation: aRelation [
	^ (self cards includes: aRelation source)
		and: [ self cards includes: aRelation target ]
]

{ #category : #accessing }
CardHand >> deck [
	^ deck
]

{ #category : #accessing }
CardHand >> deck: aDeck [
	self unsubscribe.
	deck := aDeck.
	self subscribe.
	self invalidateCardsAndRelations
]

{ #category : #initialization }
CardHand >> deck: aDeck filter: aFilter [
	self deck: aDeck.
	self filter: aFilter
]

{ #category : #accessing }
CardHand >> deleteCard: aCard [
	self deck deleteCard: aCard
]

{ #category : #accessing }
CardHand >> deleteRelation: rel [
	self deck deleteRelation: rel
]

{ #category : #accessing }
CardHand >> example [
	"Toy example for testing"

	<gtExample>
	^ CardHand new
		name: 'testHand';
		deck: CardDeck new example;
		filter: 'a' asTagFilter & 'b' asTagFilter not yourself
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
	filter := TrueFilter new.
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

{ #category : #announcements }
CardHand >> subscribe [
	"NB: specify self as the subscriber so we can ubsubscribe!"

	self deck announcer
		when: CardsUpdated
		do: [ self invalidateCardsAndRelations ]
		for: self.
	self deck announcer
		when: RelationsUpdated
		do: [ self invalidateCardsAndRelations ]
		for: self.
	self deck announcer
		when: TagsUpdated
		do: [ self invalidateCardsAndRelations ]
		for: self
]

{ #category : #accessing }
CardHand >> tags [
	^ (super tags asSet
		addAll: self filter tags;
		yourself) asOrderedCollection
]

{ #category : #accessing }
CardHand >> unsubscribe [
	self deck announcer unsubscribe: self
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
	self
		relations:
			(deck relations
				select: [ :rel | 
					(self cards includes: rel source)
						and: [ self cards includes: rel target ] ])
]
