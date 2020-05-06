"
I represent a named relationship from one card (the source) to another (the target).
I support filtering operations to retrieve relations.

"
Class {
	#name : #CardRelation,
	#superclass : #Object,
	#instVars : [
		'name',
		'source',
		'target',
		'deck'
	],
	#category : #'IMAD-Cards-Model'
}

{ #category : #comparing }
CardRelation >> <= aRelation [
	^ self source name < aRelation source name
		or: [ self source name = aRelation source name
				and: [ self name < aRelation name
						or: [ self name = aRelation name
								and: [ self target name <= aRelation target name ] ] ] ]
]

{ #category : #comparing }
CardRelation >> = anObject [
	"Answer whether the receiver and anObject represent the same object.
	NB: Do NOT also compare if the decks are equal, or this will lead to infinite recursion!"

	self == anObject
		ifTrue: [ ^ true ].
	self class = anObject class
		ifFalse: [ ^ false ].
	^ self name = anObject name
		and:
			[ self source = anObject source and: [ self target = anObject target ] ]
]

{ #category : #initialization }
CardRelation >> assertInvariant [
	"NB: duplicated code with Card>>#assertInvariant"

	"super assertInvariant."

	self assert: self deck isNotNil description: 'deck must be defined'.
	self
		assert: (self deck isKindOf: CardDeck)
		description: 'deck must be a CardDeck'.
	self assert: self name isNotNil description: 'name must be defined'.
	self assert: self name isString description: 'name must be a string'.
	self
		assert: self name notEmpty
		description: 'name must not be an empty string'.
	self
		assert: (source isKindOf: Card)
		description: 'source must be a Card'.
	self
		assert: (target isKindOf: Card)
		description: 'target must be a Card'
]

{ #category : #accessing }
CardRelation >> deck [
	^ deck
]

{ #category : #accessing }
CardRelation >> deck: aCardDeck [
	deck := aCardDeck.
	self assertInvariant
]

{ #category : #accessing }
CardRelation >> hasSource: aCard [
	^ source = aCard
]

{ #category : #accessing }
CardRelation >> hasTarget: aCard [
	^ target = aCard
]

{ #category : #initialization }
CardRelation >> initializeDeck: aDeck name: aSymbol source: aSourceCard target: aTargetCard [
	deck := aDeck.
	name := aSymbol.
	source := aSourceCard.
	target := aTargetCard.
	self assertInvariant
]

{ #category : #accessing }
CardRelation >> isNamed: aSymbol [
	^ name = aSymbol
]

{ #category : #accessing }
CardRelation >> name [
	^ name
]

{ #category : #accessing }
CardRelation >> name: aSymbol [
	name := aSymbol.
	self deck announcer announce: RelationsUpdated
]

{ #category : #printing }
CardRelation >> printOn: aStream [
	aStream
		nextPutAll: self name;
		nextPutAll: ' : '.
	self source printOn: aStream.
	aStream
		nextPutAll: ' -> '.
	self target printOn: aStream
]

{ #category : #accessing }
CardRelation >> source [
	^ source
]

{ #category : #accessing }
CardRelation >> source: aCard [
	source := aCard.
	self deck announcer announce: RelationsUpdated
]

{ #category : #accessing }
CardRelation >> target [
	^ target
]

{ #category : #accessing }
CardRelation >> target: aCard [
	target := aCard.
	self deck announcer announce: RelationsUpdated
]
