"
I am a common abstract superclass for Hypernodes, Hyperlinks and related classes.

See ${class:name=Hypernode}$.

"
Class {
	#name : #HypergraphEntity,
	#superclass : #Object,
	#instVars : [
		'properties'
	],
	#category : #'IMAD-Hypernodes-IMAD-Hypernodes'
}

{ #category : #accessing }
HypergraphEntity >> = anObject [
	"Answer whether the receiver and anObject represent the same object."

	self == anObject
		ifTrue: [ ^ true ].
	self class = anObject class
		ifFalse: [ ^ false ].
	^ self properties = anObject properties
]

{ #category : #accessing }
HypergraphEntity >> assertGeneratedNodeEqualsSelf [
	"If this fails, there is a bug in the code generation!"

	self
		assert: self generatedNodeEqualsSelf
		description: 'Fatal error: generated storeString is not equal to self'
]

{ #category : #accessing }
HypergraphEntity >> assertInvariant [
	self
		assert: properties isNotNil
		description: 'properties must be defined'
]

{ #category : #accessing }
HypergraphEntity >> evalStoreString [
	^ OpalCompiler new
		source: self storeString;
		evaluate
]

{ #category : #accessing }
HypergraphEntity >> generatedNodeEqualsSelf [
	^ self evalStoreString = self
]

{ #category : #accessing }
HypergraphEntity >> get: propertyKey [
	self assert: (properties includesKey: propertyKey) description: 'key to lookup must exist'.
	^ properties at: propertyKey ifAbsent: nil
]

{ #category : #accessing }
HypergraphEntity >> hash [
	^ super hash bitXor: self properties hash
]

{ #category : #accessing }
HypergraphEntity >> inform: aString [
	"NB: just a placeholder for a real gt version of #inform:"

	| aSpace |
	aSpace := BlSpace new.
	aSpace title: aString.
	aSpace extent: 500 @ 50.
	aSpace addChild: (BlTextElement new text: aString asRopedText).
	aSpace withHalos.
	aSpace show
]

{ #category : #accessing }
HypergraphEntity >> initialize [
	super initialize.
	properties := Dictionary new
]

{ #category : #accessing }
HypergraphEntity >> properties [
	^ properties
]

{ #category : #accessing }
HypergraphEntity >> properties: aDictionary [
	"NB: Only used for method storage"

	properties := aDictionary
]

{ #category : #accessing }
HypergraphEntity >> set: propertyKey to: aValue [
	self properties at: propertyKey put: aValue
	"self announcer announce: PropertiesUpdated new"
]

{ #category : #accessing }
HypergraphEntity >> storePropertiesOn: aStream [
	properties isNotEmpty
		ifTrue: [ aStream nextPutAll: '  properties: '.
			properties storeOn: aStream.
			aStream
				nextPutAll: ';';
				cr ]
]
