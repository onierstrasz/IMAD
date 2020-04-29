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

{ #category : #comparing }
Card >> = anObject [
	"Answer whether the receiver and anObject represent the same object."

	self == anObject
		ifTrue: [ ^ true ].
	self class = anObject class
		ifFalse: [ ^ false ].
	^ self properties = anObject properties
]

{ #category : #deprecated }
Card >> asElement [
	| element |
	element := CardElement new.
	element entity: self.
	^ element
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
	self assert: self invariant
]

{ #category : #generation }
Card >> generateOn: aStream [
	aStream
		nextPutAll: 'Card new';
		cr.
	self genPropertiesOn: aStream.
	aStream
		nextPutAll: '  yourself'
]

{ #category : #deprecated }
Card >> gtLiveFor: aView [
	<gtView>
	^ aView explicit
		title: 'Live';
		priority: 0;
		stencil: [ self ]
]

{ #category : #querying }
Card >> hasA: relSymbol [
	^ (self deck relationsMatching:
		(self relFilter: relSymbol)
		& (self selfSourceFilter)) isNotEmpty

]

{ #category : #initialization }
Card >> initialize [
	<todo: 'Should properties be an IdentityDictionary?'>
	super initialize.
]

{ #category : #initialization }
Card >> invariant [
	^ self deck isNotNil
		and: [ self properties isNotNil and: [ self name isNotNil ] ]
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

{ #category : #querying }
Card >> sourceFilter: aCard [
	^ CRSourceFilter new source: aCard
]

{ #category : #querying }
Card >> targetFilter: aCard [
	^ CRTargetFilter new target: aCard
]
