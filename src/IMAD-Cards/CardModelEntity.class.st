"
I serve as a common superclass for shared behaviour of Card model entities.
(Prehaps I should be better factored out into traits.)
"
Class {
	#name : #CardModelEntity,
	#superclass : #Object,
	#instVars : [
		'properties'
	],
	#category : #'IMAD-Cards-Model'
}

{ #category : #generation }
CardModelEntity >> genPropertiesOn: aStream [
	properties
		associationsDo: [ :each | 
			aStream
				nextPutAll: '  set: ';
				print: each key;
				nextPutAll: ' to: ';
				print: each value;
				nextPutAll: ';'.
			aStream cr ]
]

{ #category : #generation }
CardModelEntity >> genString [
	^ String streamContents: [:s | self generateOn: s]
]

{ #category : #generation }
CardModelEntity >> generateOn: aStream [
	^ self subclassResponsibility
]

{ #category : #accessing }
CardModelEntity >> get: propertySymbol [
	<todo: 'Should return a dedicated Null object if absent'>
	^ properties at: propertySymbol ifAbsent: nil
]

{ #category : #initialization }
CardModelEntity >> initialize [
	<todo: 'Should properties be an IdentityDictionary?'>
	super initialize.
	properties := Dictionary new.
]

{ #category : #accessing }
CardModelEntity >> properties [
	"For CardElement"
	^ properties
]

{ #category : #accessing }
CardModelEntity >> set: propertySymbol to: aValue [
	^ properties at: propertySymbol put: aValue
]
