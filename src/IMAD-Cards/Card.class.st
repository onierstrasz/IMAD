"
I am a holder of information about a domain concept in a domain model.
I provide a UI to enter, edit and manipulate this information.

I have a title, a description, and other properties.



"
Class {
	#name : #Card,
	#superclass : #Object,
	#instVars : [
		'name',
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
Card >> initialize [
	<todo: 'Should properties be an IdentityDictionary?'>
	super initialize.
	properties := Dictionary new.
	self name: self defaultName.
	self description: self defaultDescription.
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
Card >> set: propertySymbol to: aValue [
	^ properties at: propertySymbol put: aValue
]
