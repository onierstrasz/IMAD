"
I represent a subset of a Deck of Cards defined by a Filter.

The subsets of cards and relations are computed lazily. If either the Deck or the Filter is changed, the cards and relations subsets are invalidated.

If the Deck is modified (Cards or Relations updated) then the cards and relations are invalidated, and recomputed by their (lazy) accessors.

"
Class {
	#name : #VirtualHand,
	#superclass : #AbstractCardSet,
	#instVars : [
		'deck',
		'filter'
	],
	#category : #'IMAD-Cards-Model'
}

{ #category : #cards }
VirtualHand >> addCard: aCard [
	aCard addTags: self filter positiveTags.
	deck addCard: aCard.
	self invalidateCardsAndRelations
]

{ #category : #accessing }
VirtualHand >> addRelation: aSymbol from: aSourceCard to: aTargetCard [
	self deck addRelation: aSymbol from: aSourceCard to: aTargetCard
]

{ #category : #accessing }
VirtualHand >> asElement [
	^ VirtualHandGUI new
		hand: self;
		yourself
]

{ #category : #accessing }
VirtualHand >> cards [
	cards ifNil: [ self updateCards ].
	^ cards
]

{ #category : #accessing }
VirtualHand >> cards: aCardCollection [
	cards := aCardCollection
]

{ #category : #accessing }
VirtualHand >> cardsNil [
	"For testing purposes."
	^ cards isNil
]

{ #category : #relations }
VirtualHand >> containsRelation: aRelation [
	^ (self cards includes: aRelation source)
		and: [ self cards includes: aRelation target ]
]

{ #category : #accessing }
VirtualHand >> deck [
	^ deck
]

{ #category : #accessing }
VirtualHand >> deck: aDeck [
	self unsubscribe.
	deck := aDeck.
	self subscribe.
	self invalidateCardsAndRelations
]

{ #category : #initialization }
VirtualHand >> deck: aDeck filter: aFilter [
	self deck: aDeck.
	self filter: aFilter
]

{ #category : #accessing }
VirtualHand >> deleteCard: aCard [
	self deck deleteCard: aCard
]

{ #category : #accessing }
VirtualHand >> deleteRelation: rel [
	self deck deleteRelation: rel
]

{ #category : #accessing }
VirtualHand >> example [
	"Toy example for testing"

	<gtExample>
	^ VirtualHand new
		name: 'testHand';
		deck: CardDeck new example;
		filter: 'a' asTagFilter & 'b' asTagFilter not yourself
]

{ #category : #accessing }
VirtualHand >> filter [
	^ filter
]

{ #category : #accessing }
VirtualHand >> filter: aFilter [
	filter := aFilter.
	self invalidateCardsAndRelations
]

{ #category : #initialization }
VirtualHand >> initialize [
	super initialize.
	deck := CardDeck new.
	filter := TrueFilter new.
	self subscribe
]

{ #category : #accessing }
VirtualHand >> invalidateCardsAndRelations [
	self cards: nil.
	self relations: nil
]

{ #category : #accessing }
VirtualHand >> relations [
	relations ifNil: [ self updateRelations ].
	^ relations
]

{ #category : #accessing }
VirtualHand >> relations: aRelation [
	relations := aRelation
]

{ #category : #announcements }
VirtualHand >> subscribe [
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
VirtualHand >> tags [
	^ (super tags asSet
		addAll: self filter tags;
		yourself) asOrderedCollection
]

{ #category : #accessing }
VirtualHand >> unsubscribe [
	self deck announcer unsubscribe: self
]

{ #category : #accessing }
VirtualHand >> updateCards [
	self assert: deck isNotNil description: 'deck should not be nil'.
	self assert: filter isNotNil description: 'filter should not be nil'.
	self cards: (self deck cards select: [ :card | self filter matches: card ])
]

{ #category : #accessing }
VirtualHand >> updateRelations [
	self assert: deck isNotNil description: 'deck should not be nil'.
	self assert: filter isNotNil description: 'filter should not be nil'.
	self
		relations:
			(deck relations
				select: [ :rel | 
					(self cards includes: rel source)
						and: [ self cards includes: rel target ] ])
]
