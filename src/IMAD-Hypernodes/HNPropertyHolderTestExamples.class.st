Class {
	#name : #HNPropertyHolderTestExamples,
	#superclass : #Object,
	#category : #'IMAD-Hypernodes-IMAD-Hypernodes'
}

{ #category : #accessing }
HNPropertyHolderTestExamples >> emptyProperties [
	<gtExample>
	| holder |
	holder := HNPropertyHolder new.
	self assert: holder properties size equals: 0.
	holder assertInvariant.
	^ holder
]

{ #category : #accessing }
HNPropertyHolderTestExamples >> nestedProperties [
	<gtExample>
	^ {(#a -> 1).
	(#b -> 2).
	(#c
		->
			({(#x -> 'hello').
			(#y -> {'hi' . 'there'} asOrderedCollection)} as: KeyedTree))}
		as: KeyedTree
]

{ #category : #accessing }
HNPropertyHolderTestExamples >> setName [
	<gtExample>
	| holder |
	holder := self emptyProperties.
	self assert: (holder get: #name) equals: nil.
	self assert: (holder get: #name ifAbsent: '') equals: ''.
	self assert: holder properties size equals: 0.
	self assert: (holder set: #name to: 'foo') equals: 'foo'.
	self assert: holder properties size equals: 1.
	holder assertInvariant.
	^ holder
]

{ #category : #accessing }
HNPropertyHolderTestExamples >> setNameWhenAbsent [
	<gtExample>
	| holder |
	holder := self emptyProperties.
	self assert: holder properties size equals: 0.
	self assert: (holder get: #name ifAbsentPut: 'foo') equals: 'foo'.
	self assert: holder properties size equals: 1.
	holder assertInvariant.
	^ holder
]
