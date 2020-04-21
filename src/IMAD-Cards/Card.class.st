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
		'deck',
		'properties'
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

{ #category : #gt }
Card >> asElement [
	| element |
	element := CardElement new.
	element card: self.
	^ element
]

{ #category : #initialization }
Card >> assertInvariant [
	self assert: self deck isNotNil.
	self assert: properties isNotNil.
	self assert: self name isNotNil.
	
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
	self assertInvariant.
]

{ #category : #accessing }
Card >> defaultDescription [
	^ 'To do'
]

{ #category : #accessing }
Card >> defaultName [
	^ 'Unknown'
]

{ #category : #accessing }
Card >> description [
	^ self get: #description
]

{ #category : #accessing }
Card >> description: aString [
	self set: #description to: aString

]

{ #category : #generation }
Card >> generateOn: aStream [
	aStream
		nextPutAll: 'Card new';
		cr.
	properties
		associationsDo: [ :each | 
			aStream
				nextPutAll: '  set: ';
				print: each key;
				nextPutAll: ' to: ';
				print: each value;
				nextPutAll: ';'.
			aStream cr ].
	aStream
		nextPutAll: '  yourself'
]

{ #category : #accessing }
Card >> get: propertySymbol [
	<todo: 'Should return a dedicated Null object if absent'>
	^ properties at: propertySymbol ifAbsent: nil
]

{ #category : #gt }
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
	properties := Dictionary new.
	self name: self defaultName.
	self description: self defaultDescription.
]

{ #category : #initialization }
Card >> invariant [
	self assert: self deck isNotNil.
	self assert: properties isNotNil.
	self assert: self name isNotNil.

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

{ #category : #accessing }
Card >> name [
	^ self get: #name
]

{ #category : #accessing }
Card >> name: aString [
	self set: #name to: aString

]

{ #category : #printing }
Card >> printOn: aStream [
	<todo: 'Add more information (kind of card, domain ...)'>
	aStream
		nextPutAll: self name
]

{ #category : #accessing }
Card >> properties [
	"For CardElement"
	^ properties
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

{ #category : #accessing }
Card >> set: propertySymbol to: aValue [
	^ properties at: propertySymbol put: aValue
]

{ #category : #querying }
Card >> sourceFilter: aCard [
	^ CRSourceFilter new source: aCard
]

{ #category : #querying }
Card >> targetFilter: aCard [
	^ CRTargetFilter new target: aCard
]
