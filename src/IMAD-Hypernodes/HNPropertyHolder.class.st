"
I am an object that holds a list of properties.

"
Class {
	#name : #HNPropertyHolder,
	#superclass : #Object,
	#instVars : [
		'properties'
	],
	#category : #'IMAD-Hypernodes-IMAD-Hypernodes'
}

{ #category : #comparing }
HNPropertyHolder >> = anObject [
	"Answer whether the receiver and anObject represent the same object."

	self == anObject
		ifTrue: [ ^ true ].
	self class = anObject class
		ifFalse: [ ^ false ].
	^ self properties = anObject properties
]

{ #category : #invariant }
HNPropertyHolder >> assertInvariant [
	self
		assert: properties isNotNil
		description: 'properties must be defined'
]

{ #category : #properties }
HNPropertyHolder >> get: propertyKey [
	"self assert: (properties includesKey: propertyKey) description: 'key ', propertyKey asString, ' has not been defined'."
	^ properties at: propertyKey ifAbsent: nil
]

{ #category : #accessing }
HNPropertyHolder >> get: propertyKey ifAbsent: defaultValue [
	^ properties at: propertyKey ifAbsent: defaultValue
]

{ #category : #accessing }
HNPropertyHolder >> get: propertyKey ifAbsentPut: aBlock [
	^ properties at: propertyKey ifAbsentPut: aBlock
]

{ #category : #comparing }
HNPropertyHolder >> hash [
	^ super hash bitXor: self properties hash
]

{ #category : #initialization }
HNPropertyHolder >> initialize [
	super initialize.
	properties := Dictionary new
]

{ #category : #properties }
HNPropertyHolder >> properties [
	^ properties
]

{ #category : #properties }
HNPropertyHolder >> properties: aDictionary [
	"NB: Only used for method storage"

	properties := aDictionary
]

{ #category : #properties }
HNPropertyHolder >> set: propertyKey to: aValue [
	self properties at: propertyKey put: aValue
	"self announcer announce: PropertiesUpdated new"
]

{ #category : #storing }
HNPropertyHolder >> storePropertiesOn: aStream [
	properties isNotEmpty
		ifTrue: [ aStream nextPutAll: '  properties: '.
			properties storeOn: aStream.
			aStream
				nextPutAll: ';';
				cr ]
]
