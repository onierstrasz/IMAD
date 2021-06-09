Class {
	#name : #HNPropertyHolderTestExamples,
	#superclass : #Object,
	#category : #'IMAD-Hypernodes-Examples'
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

{ #category : #accessing }
HNPropertyHolderTestExamples >> testGetPath [
	<gtExample>
	| holder  |
	holder := HNPropertyHolder new.
	holder properties: self nestedProperties.

	self assert: (holder getPath: #(#a)) equals: 1.
	self assert: (holder getPath: #(#a) ifAbsent: [ 0 ]) equals: 1.
	self assert: (holder getPath: #(#a) ifAbsentPut: [ 0 ]) equals: 1.
	self assert: (holder getPath: #(#c #x) ifAbsentPut: [ 0 ]) equals: 'hello'.
	self assert: (holder getPath: #(#d) ifAbsentPut: [ #foo ]) equals: #foo.
	self assert: (holder getPath: #(#e #f) ifAbsentPut: [ #bar ]) equals: #bar.

	^ holder
]

{ #category : #accessing }
HNPropertyHolderTestExamples >> testKeyedTreePath [
	"Here we only test the core KeyedTree methods, not the HNPropertyHolder API."

	<gtExample>
	| kt |
	kt := self nestedProperties.
	self assert: kt allKeys equals: #(#a #b #c #x #y) asOrderedCollection.
	self assert: (kt at: #a) equals: 1.
	self assert: (kt atPath: #(#a)) equals: 1.
	self assert: (kt atPath: #(#a) ifAbsent: [ 0 ]) equals: 1.
	self assert: (kt atPath: #(#a) ifAbsentPut: [ 0 ]) equals: 1.
	self assert: (kt atPath: #(#c #x) ifAbsentPut: [ 0 ]) equals: 'hello'.
	self assert: (kt atPath: #(#d) ifAbsentPut: [ #foo ]) equals: #foo.
	self assert: (kt atPath: #(#e #f) ifAbsentPut: [ #bar ]) equals: #bar.
	self
		assert: kt allKeys asSet
		equals: #(#a #b #c #x #y #d #e #f) asSet.
	^ kt
]
