"
I am a holder of information about a domain concept in a domain model.
I provide a UI to enter, edit and manipulate this information.

I have a title, a description, and other properties.



"
Class {
	#name : #Card,
	#superclass : #Object,
	#instVars : [
		'properties'
	],
	#category : #'IMAD-Cards-Model'
}

{ #category : #accessing }
Card >> asElement [
	| element |
	element := CardElement new.
	element card: self.
	^ element
]

{ #category : #accessing }
Card >> assertInvariant [
	self assert: self deck isNotNil.
	self assert: properties isNotNil.
	self assert: self name isNotNil.
	
]

{ #category : #accessing }
Card >> become: relation of: aSourceCard [
	"Convenience method"
	self deck addRelation: relation from: aSourceCard to: self
]

{ #category : #accessing }
Card >> deck [
	^ self get: #deck
]

{ #category : #accessing }
Card >> deck: aCardDeck [
	self set: #deck to: aCardDeck.
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

{ #category : #accessing }
Card >> get: propertySymbol [
	<todo: 'Should return a dedicated Null object if absent'>
	^ properties at: propertySymbol ifAbsent: nil
]

{ #category : #accessing }
Card >> gtLiveFor: aView [
	<gtView>
	^ aView explicit
		title: 'Live';
		priority: 0;
		stencil: [ self ]
]

{ #category : #accessing }
Card >> hasA: relSymbol [
	^ (self deck relationsMatching: (self relFilter: relSymbol)) isNotEmpty
]

{ #category : #accessing }
Card >> initialize [
	<todo: 'Should properties be an IdentityDictionary?'>
	super initialize.
	properties := Dictionary new.
	self name: self defaultName.
	self description: self defaultDescription.
]

{ #category : #accessing }
Card >> invariant [
	self assert: deck isNotNil.
	self assert: properties isNotNil.
	self assert: self name isNotNil.
	
]

{ #category : #accessing }
Card >> is: relSymbol of: aCard [
	^ (self deck relationsMatching:
		(self relFilter: relSymbol)
		& (self sourceFilter: aCard)
		& (self selfTargetFilter)) isNotEmpty
]

{ #category : #accessing }
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

{ #category : #accessing }
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

{ #category : #accessing }
Card >> relFilter: aSymbol [
	^ CRRelNameFilter new name: aSymbol
]

{ #category : #accessing }
Card >> selfSourceFilter [
	^ CRSourceFilter new source: self.
]

{ #category : #accessing }
Card >> selfTargetFilter [
	^ CRTargetFilter new target: self.
]

{ #category : #accessing }
Card >> set: propertySymbol to: aValue [
	^ properties at: propertySymbol put: aValue
]

{ #category : #accessing }
Card >> sourceFilter: aCard [
	^ CRSourceFilter new source: aCard
]

{ #category : #accessing }
Card >> targetFilter: aCard [
	^ CRTargetFilter new target: aCard
]
