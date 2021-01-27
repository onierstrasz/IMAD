"
I am an object that holds a ${class:name=Dictionary}$ of properties.
Each property consists of a key and a value. The key should normally be a ${class:name=Symbol}$.
The value may be a primitive value, such as a ${class:name=ByteString}$, or  a ${class:name=Number}$ , or it may be an ${class:name=OrderedCollection}$ or ${class:name=Dictionary}$ of values.


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

{ #category : #accessing }
HNPropertyHolder >> checkPropertyKeysAndValues: aDictionary [
	<todo: 'recurse into collections and dictionaries'>
	(aDictionary isKindOf: Dictionary)
		ifFalse: [ ^ false ].
	aDictionary keys
		detect: [ :key | key isSymbol not ]
		ifFound: [ ^ false ].
	aDictionary values
		detect: [ :val | 
			(val isKindOf: ByteString) not
				and: [ (val isKindOf: Number) not
						and: [ (val isKindOf: Dictionary) not
								and: [ (val isKindOf: OrderedCollection) not ] ] ] ]
		ifFound: [ ^ false ].
	^ true
]

{ #category : #properties }
HNPropertyHolder >> get: propertyKey [
	"self assert: (properties includesKey: propertyKey) description: 'key ', propertyKey asString, ' has not been defined'."
	<todo: 'get rid of nil values; possibly deprecate this method'>
	^ properties at: propertyKey ifAbsent: nil
]

{ #category : #accessing }
HNPropertyHolder >> get: propertyKey ifAbsent: defaultValue [
	<todo: 'Do we need this method? Prefer #get:ifAbsentPut:'>
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

{ #category : #accessing }
HNPropertyHolder >> invariant [
	^ self checkPropertyKeysAndValues: self properties
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
