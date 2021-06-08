"
I am an object that holds a {{gtClass:name=KeyedTree}} of properties.
Each property consists of a key and a value. The key should normally be a {{gtClass:name=Symbol}}.
The value may be a primitive value, such as a {{gtClass:name=ByteString}}, or  a {{gtClass:name=Number}} , or it may be an {{gtClass:name=OrderedCollection}} or {{gtClass:name=KeyedTree}} of values.


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
	self assert: (aKeyedTree isKindOf: KeyedTree).
	aKeyedTree keys do: [ :key | self assert: key isSymbol ].
	aKeyedTree values do: [ :val | self assertValidValuesFor: val ]
]

{ #category : #accessing }
HNPropertyHolder >> assertValidValuesFor: aKeyedTreeValue [
	self
		assert:
			((aKeyedTreeValue isKindOf: ByteString)
				or: [ (aKeyedTreeValue isKindOf: Number)
						or: [ (aKeyedTreeValue isKindOf: KeyedTree)
								or: [ aKeyedTreeValue isKindOf: OrderedCollection ] ] ])
		description:
			'expected value of type ByteString, Number, OrderedCollection or KeyedTree, got a '
				, aKeyedTreeValue class name.
	(aKeyedTreeValue isKindOf: KeyedTree)
		ifTrue: [ self assertValidKeysAndValuesFor: aKeyedTreeValue ].
	(aKeyedTreeValue isKindOf: OrderedCollection)
		ifTrue:
			[ aKeyedTreeValue do: [ :each | self assertValidValuesFor: each ] ]
]

{ #category : #'gt-extension' }
HNPropertyHolder >> editableLabelFor: aString withSetter: aOneArgumentBlock [
	"NB: stateless utility method"

	| label |
	label := BrEditableLabel new
		aptitude: (BrGlamorousEditableLabelAptitude new defaultBackground: Color white);
		text: aString.
	label
		when: BrEditorAcceptWish
		do: [ :aWish | 
			aString ~= aWish text asString
				ifTrue: [ [ aOneArgumentBlock value: aWish text asString ]
						on: AssertionFailure
						do: [ :e | 
							label text: aString.
							self inform: e printString ] ] ].
	^ label
]

{ #category : #properties }
HNPropertyHolder >> get: propertyKey [
	"self assert: (properties includesKey: propertyKey) description: 'key ', propertyKey asString, ' has not been defined'."
	<todo: 'get rid of nil values; possibly deprecate this method'>
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

{ #category : #accessing }
HNPropertyHolder >> getPath: aKeyPath [
	^ properties atPath: aKeyPath
]

{ #category : #accessing }
HNPropertyHolder >> getPath: aKeyPath ifAbsent: aBlock [
	^ properties atPath: aKeyPath ifAbsent: aBlock
]

{ #category : #accessing }
HNPropertyHolder >> getPath: aKeyPath ifAbsentPut: aBlock [
	^ properties atPath: aKeyPath ifAbsentPut: aBlock
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
