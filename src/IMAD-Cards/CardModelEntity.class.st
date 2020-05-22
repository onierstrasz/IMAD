"
I serve as a common superclass for shared behaviour of Card model entities.
All entities have a set of properties.
"
Class {
	#name : #CardModelEntity,
	#superclass : #Object,
	#instVars : [
		'properties',
		'announcer'
	],
	#category : #'IMAD-Cards-Model'
}

{ #category : #comparing }
CardModelEntity >> = anObject [
	"Answer whether the receiver and anObject represent the same object."

	self == anObject
		ifTrue: [ ^ true ].
	self class = anObject class
		ifFalse: [ ^ false ].
	^ self properties = anObject properties
]

{ #category : #initialization }
CardModelEntity >> assertInvariant [
	self
		assert: properties isNotNil
		description: 'properties must be defined'
]

{ #category : #properties }
CardModelEntity >> defaultDescription [
	^ 'To do'
]

{ #category : #properties }
CardModelEntity >> defaultValue [
	^ '...'
]

{ #category : #properties }

CardModelEntity >> freshKey [
	| index key |
	index := self properties size.
	key := 'key' , index asString.
	[ self properties includesKey: key ]
		whileTrue: [ index := index + 1.
			key := 'key' , index asString ].
	^ key
]

{ #category : #properties }

CardModelEntity >> get: propertyKey [
	self assert: (properties includesKey: propertyKey) description: 'key to lookup must exist'.
	^ properties at: propertyKey ifAbsent: nil
]


{ #category : #comparing }
CardModelEntity >> hash [
	^ self name hash
]

{ #category : #'ui requests' }
CardModelEntity >> inform: aString [
	"NB: just a placeholder for a real gt version of #inform:"

	<todo: 'Build a better implementation of #inform:'>
	| aSpace |
	aSpace := BlSpace new.
	aSpace title: aString.
	aSpace extent: 500 @ 50.
	aSpace addChild: (BlTextElement new text: aString asRopedText).
	aSpace withHalos.
	aSpace show
]

{ #category : #initialization }
CardModelEntity >> initialize [
	super initialize.
	announcer := Announcer new.
	properties := Dictionary new.
]

{ #category : #properties }
CardModelEntity >> properties [
	^ properties
]

{ #category : #properties }
CardModelEntity >> protectedKeys [
	^ OrderedCollection new
]

{ #category : #properties }
CardModelEntity >> removePropertyWithKey: aKey [
	self
		assert: (self properties includesKey: aKey)
		description: 'key of property to remove must exist'.
	self
		assert: (self protectedKeys includes: aKey) not
		description: 'cannot remove a property with a protected key'.
	self properties removeKey: aKey.
	self announcer announce: PropertiesUpdated new
]

{ #category : #properties }
CardModelEntity >> rename: oldKey to: newKey [
	self assert: (self properties includesKey: oldKey) description: 'key to rename must exist'.
	self assert: (self properties includesKey: newKey) not description: 'new name of key must not exist'.
	self assert: (self protectedKeys includes: oldKey) not description: 'cannot rename a protected key'.
	self properties at: newKey put: (self properties removeKey: oldKey).
	self announcer announce: PropertiesUpdated new
]

{ #category : #properties }
CardModelEntity >> set: propertyKey to: aValue [
	self properties at: propertyKey put: aValue.
	self announcer announce: PropertiesUpdated new
]
