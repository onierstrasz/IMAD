"
I am a holder of information about a domain concept in a domain model.
I provide a UI to enter, edit and manipulate this information.

I have a title, a description, and other properties.

NB: properties should just hold (flat?) values, so the deck of a card should not be modeled as a property.


"
Class {
	#name : #Card,
	#superclass : #CardModelEntity,
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
	deck := aCardDeck.
	self assertInvariant
]

{ #category : #querying }
Card >> hasA: relSymbol [
	^ (self deck relationsMatching:
		(self relFilter: relSymbol)
		& (self selfSourceFilter)) isNotEmpty

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
		& (self sourceFilter: aCard)
		& (self selfTargetFilter)) isNotEmpty
]

{ #category : #querying }
Card >> isA: relSymbol [
	^ (self deck relationsMatching:
		(self relFilter: relSymbol)
		& (self selfTargetFilter)) isNotEmpty

]

{ #category : #printing }
Card >> printOn: aStream [
	<todo: 'Add more information (kind of card, domain ...)'>
	aStream
		nextPutAll: self name
]

{ #category : #querying }
Card >> relFilter: aSymbol [
	^ CRRelNameFilter new name: aSymbol
]

{ #category : #querying }
Card >> selfSourceFilter [
	^ self sourceFilter: self.
]

{ #category : #querying }
Card >> selfTargetFilter [
	^ self targetFilter: self.
]

{ #category : #properties }
Card >> set: propertyKey to: aValue [
	propertyKey = 'name'
		ifTrue: [ self assertUniqueName: aValue ].
	super set: propertyKey to: aValue.
	self deck ifNotNil: [ :d | d announcer announce: CardsUpdated new ]
]

{ #category : #querying }
Card >> sourceFilter: aCard [
	^ CRSourceFilter new source: aCard
]

{ #category : #querying }
Card >> sourceRelations [
	^ self deck relationsMatching: self selfSourceFilter
]

{ #category : #printing }
Card >> storeOn: aStream [
	aStream
		nextPutAll: 'Card new';
		cr.
	self storePropertiesOn: aStream.
	aStream
		nextPutAll: '  yourself'
]

{ #category : #querying }
Card >> targetFilter: aCard [
	^ CRTargetFilter new target: aCard
]

{ #category : #querying }
Card >> targetRelations [
	^ self deck relationsMatching: self selfTargetFilter
]
