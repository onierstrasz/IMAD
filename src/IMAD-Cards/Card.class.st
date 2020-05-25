"
I am a holder of information about a domain concept in a domain model.
I provide a UI to enter, edit and manipulate this information.

I have a name, a description, and other properties.
My name is unique within a Card Deck.

NB: properties should just hold (flat?) values, so the deck of a card should not be modeled as a property.


"
Class {
	#name : #Card,
	#superclass : #CardModelNamedEntity,
	#instVars : [
		'deck'
	],
	#category : #'IMAD-Cards-Model'
}

{ #category : #initialization }
Card >> assertInvariant [
	"NB: We can only assert the invariant after a card has been added to a deck.
	A new Card is detached and will not satisfy the invariant."

	super assertInvariant.
	self assert: self deck isNotNil description: 'deck must be defined'.
	self
		assert: (self deck isKindOf: CardDeck)
		description: 'deck must be a CardDeck'
]

{ #category : #initialization }
Card >> assertUniqueName: aString [
	self deck
		ifNotNil: [ :d | 
			self
				assert: ((d cards collect: #name) includes: aString) not
				description: 'cards must be uniquely named' ]
]

{ #category : #relations }
Card >> become: relation of: aSourceCard [
	"Convenience method"
	self deck addRelation: relation from: aSourceCard to: self
]

{ #category : #accessing }
Card >> deck [
	^ deck
]

{ #category : #accessing }
Card >> deck: aCardDeck [
	deck := aCardDeck
]

{ #category : #querying }
Card >> hasA: relSymbol [
	^ (self deck relationsMatching:
		(self relFilter: relSymbol)
		& (self sourceFilter)) isNotEmpty

]

{ #category : #initialization }
Card >> initialize [
	super initialize.
	"self assertInvariant"
]

{ #category : #querying }
Card >> is: relSymbol of: aCard [
	^ (self deck relationsMatching:
		(self relFilter: relSymbol)
		& (aCard sourceFilter)
		& (self targetFilter)) isNotEmpty
]

{ #category : #querying }
Card >> isA: relSymbol [
	^ (self deck relationsMatching:
		(self relFilter: relSymbol)
		& (self targetFilter)) isNotEmpty

]

{ #category : #printing }
Card >> printOn: aStream [
	aStream
		nextPutAll: self name
]

{ #category : #querying }
Card >> relFilter: aSymbol [
	^ CRRelNameFilter new name: aSymbol
]

{ #category : #querying }
Card >> relations [
	^ self sourceRelations
		addAll: self targetRelations;
		yourself
]

{ #category : #accessing }
Card >> remove [
	self deck removeCard: self.
	self deck: nil
]

{ #category : #relations }
Card >> removeRelations [
	self relations do: [ :each | each remove ]
]

{ #category : #properties }
Card >> set: propertyKey to: aValue [
	propertyKey = 'name'
		ifTrue: [ self assertUniqueName: aValue ].
	super set: propertyKey to: aValue.
	self deck ifNotNil: [ :d | d announcer announce: CardsUpdated new ]
]

{ #category : #querying }
Card >> sourceFilter [
	^ CRSourceFilter new source: self.
]

{ #category : #querying }
Card >> sourceRelations [
	^ self deck relationsMatching: self sourceFilter
]

{ #category : #printing }
Card >> storeOn: aStream [
	aStream
		nextPutAll: 'Card new';
		cr.
	self storeNameAndDescriptionOn: aStream.
	self storePropertiesOn: aStream.
	aStream nextPutAll: '  yourself'
]

{ #category : #querying }
Card >> targetFilter [
	^ CRTargetFilter new target: self
]

{ #category : #querying }
Card >> targetRelations [
	^ self deck relationsMatching: self targetFilter
]
