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

{ #category : #comparing }
HypergraphEntity >> = anObject [
	"Answer whether the receiver and anObject represent the same object."

	self == anObject
		ifTrue: [ ^ true ].
	self class = anObject class
		ifFalse: [ ^ false ].
	^ self properties = anObject properties
]

{ #category : #accessing }
HypergraphEntity >> assertGeneratedValueEqualsSelf [
	"If this fails, there is a bug in the code generation!"

	self
		assert: self generatedValue = self
		description: 'Fatal error: generated storeString is not equal to self'
]

{ #category : #accessing }
HypergraphEntity >> assertInvariant [
	self
		assert: properties isNotNil
		description: 'properties must be defined'
]

{ #category : #ut }
HypergraphEntity >> assertValidStorageMethod [
	"Utility. Only needs to be true as a precondition for storing."

	| methodName className |
	methodName := self storageMethodName.
	self
		assert: methodName notNil
		description: 'storage method name must be defined'.
	self
		assert: methodName isString
		description: 'storage method name must be a string'.
	self
		assert:
			(methodName
				detect: [ :c | c isAlphaNumeric not ]
				ifFound: [ false ]
				ifNone: [ true ])
		description: 'storage method name must be alphanumeric'.
	self
		assert: methodName first isLowercase
		description: 'storage method name must start with lower case character'.
	className := self storageClassName.
	self
		assert: className notNil
		description: 'storage class name must be defined'.
	self
		assert: className isString
		description: 'storage class name must be a string'.
	self
		assert: className first isUppercase
		description: 'storage class name must start with upper case character'.
	self
		assert: (Smalltalk at: className asSymbol ifAbsent: [ nil ]) isClass
		description: 'storage class name must refer to an existing class'
]

{ #category : #utilities }
HypergraphEntity >> classNamed: aClassName [
	^ Smalltalk at: aClassName asSymbol ifAbsent: [ nil ]
]

{ #category : #accessing }
HypergraphEntity >> generatedValue [
	^ OpalCompiler new
		source: self storeString;
		evaluate
]

{ #category : #accessing }
HypergraphEntity >> get: propertyKey [
	self assert: (properties includesKey: propertyKey) description: 'key ', propertyKey asString, ' has not been defined'.
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
HypergraphEntity >> storageClassName [
	self subclassResponsibility
]

{ #category : #accessing }
HypergraphEntity >> storageMethodName [
	self subclassResponsibility
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
