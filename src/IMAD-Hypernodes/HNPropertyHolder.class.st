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
	self assertValidKeysAndValuesFor: self properties
]

{ #category : #invariant }
HNPropertyHolder >> assertValidKeysAndValuesFor: aKeyedTree [
	<todo: 'recurse into collections and dictionaries'>
	self assert: (aKeyedTree isKindOf: KeyedTree).
	aKeyedTree keys do: [ :key | self assert: key isSymbol ].
	aKeyedTree values
		do: [ :val | 
			self
				assert:
					((val isKindOf: ByteString)
						or: [ (val isKindOf: Number)
								or: [ (val isKindOf: KeyedTree) or: [ val isKindOf: OrderedCollection ] ] ])
				description:
					'expected value of type ByteString, Number, OrderedCollection or KeyedTree, got a '
						, val class name ]
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
	properties := KeyedTree new
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
	self properties at: propertyKey put: aValue.
	^ aValue
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
