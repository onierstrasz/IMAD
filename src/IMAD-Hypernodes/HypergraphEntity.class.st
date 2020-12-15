"
I am a common abstract superclass for Hypernodes, Hyperlinks and related classes.

See ${class:name=Hypernode}$.

"
Class {
	#name : #HypergraphEntity,
	#superclass : #HNPropertyHolder,
	#category : #'IMAD-Hypernodes-IMAD-Hypernodes'
}

{ #category : #invariant }
HypergraphEntity >> assertGeneratedValueEqualsSelf [
	"If this fails, there is a bug in the code generation!"

	self
		assert: self generatedValue = self
		description: 'Fatal error: generated storeString is not equal to self'
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

{ #category : #storing }
HypergraphEntity >> generatedValue [
	^ OpalCompiler new
		source: self storeString;
		evaluate
]

{ #category : #utilities }
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

{ #category : #storing }
HypergraphEntity >> storageClassName [
	self subclassResponsibility
]

{ #category : #storing }
HypergraphEntity >> storageMethodName [
	self subclassResponsibility
]
