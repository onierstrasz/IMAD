"
I represent a named relationship from one card (the source) to another (the target).
I support filtering operations to retrieve relations.

"
Class {
	#name : #CardRelation,
	#superclass : #Object,
	#instVars : [
		'source',
		'target',
		'name'
	],
	#category : #'IMAD-Cards-Model'
}

{ #category : #accessing }
CardRelation >> hasSource: aCard [
	^ source = aCard
]

{ #category : #accessing }
CardRelation >> hasTarget: aCard [
	^ target = aCard
]

{ #category : #accessing }
CardRelation >> isNamed: aSymbol [
	^ name = aSymbol
]

{ #category : #accessing }
CardRelation >> name [
	^ name
]

{ #category : #accessing }
CardRelation >> name: aSymbol [
	name := aSymbol
]

{ #category : #accessing }
CardRelation >> printOn: aStream [
	aStream
		nextPutAll: self name;
		nextPutAll: ' : '.
	self source printOn: aStream.
	aStream
		nextPutAll: ' -> '.
	self target printOn: aStream
]

{ #category : #accessing }
CardRelation >> source [
	^ source
]

{ #category : #accessing }
CardRelation >> source: aCard [
	source := aCard
]

{ #category : #accessing }
CardRelation >> target [
	^ target
]

{ #category : #accessing }
CardRelation >> target: aCard [
	target := aCard
]
