"
I serve as a common superclass for shared behaviour of Card model entities.
All entities have a set of properties.

"
Class {
	#name : #AbstractCardModelEntity,
	#superclass : #Object,
	#instVars : [
		'properties',
		'announcer'
	],
	#category : #'IMAD-Cards-Model'
}

{ #category : #comparing }
AbstractCardModelEntity >> = anObject [
	"Answer whether the receiver and anObject represent the same object."

	self == anObject
		ifTrue: [ ^ true ].
	self class = anObject class
		ifFalse: [ ^ false ].
	^ self properties = anObject properties
]

{ #category : #accessing }
AbstractCardModelEntity >> announcer [
	^ announcer
]

{ #category : #initialization }
AbstractCardModelEntity >> assertInvariant [
	self
		assert: properties isNotNil
		description: 'properties must be defined'
]

{ #category : #properties }
AbstractCardModelEntity >> defaultDescription [
	^ 'To do'
]

{ #category : #properties }
AbstractCardModelEntity >> defaultValue [
	^ '...'
]

{ #category : #utility }
AbstractCardModelEntity >> editableLabelFor: aString withSetter: aOneArgumentBlock [
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
AbstractCardModelEntity >> freshKey [
	| index key |
	index := self properties size.
	key := 'key' , index asString.
	[ self properties includesKey: key ]
		whileTrue: [ index := index + 1.
			key := 'key' , index asString ].
	^ key
]

{ #category : #properties }
AbstractCardModelEntity >> get: propertyKey [
	self assert: (properties includesKey: propertyKey) description: 'key to lookup must exist'.
	^ properties at: propertyKey ifAbsent: nil
]

{ #category : #comparing }
AbstractCardModelEntity >> hash [
	^ super hash bitXor: self properties hash
]

{ #category : #'ui requests' }
AbstractCardModelEntity >> inform: aString [
	"NB: just a placeholder for a real gt version of #inform:"

	| aSpace |
	aSpace := BlSpace new.
	aSpace title: aString.
	aSpace extent: 500 @ 50.
	aSpace addChild: (BlTextElement new text: aString asRopedText).
	aSpace withHalos.
	aSpace show
]

{ #category : #initialization }
AbstractCardModelEntity >> initialize [
	super initialize.
	announcer := Announcer new.
	properties := Dictionary new.
]

{ #category : #accessing }
AbstractCardModelEntity >> labelFor: aString [
	"NB: stateless utility method"

	| label |
	label := BrEditableLabel new
		look: BrGlamorousEditorAptitude new; "NB: not really editable"
		text: aString.
	^ label
]

{ #category : #properties }
AbstractCardModelEntity >> properties [
	^ properties
]

{ #category : #accessing }
AbstractCardModelEntity >> properties: aDictionary [
	"NB: Only used for method storage"

	properties := aDictionary
]

{ #category : #properties }
AbstractCardModelEntity >> protectedKeys [
	^ OrderedCollection new
]

{ #category : #properties }
AbstractCardModelEntity >> removePropertyWithKey: aKey [
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
AbstractCardModelEntity >> rename: oldKey to: newKey [
	self assert: (self properties includesKey: oldKey) description: 'key to rename must exist'.
	self assert: (self properties includesKey: newKey) not description: 'new name of key must not exist'.
	self assert: (self protectedKeys includes: oldKey) not description: 'cannot rename a protected key'.
	self properties at: newKey put: (self properties removeKey: oldKey).
	self announcer announce: PropertiesUpdated new
]

{ #category : #properties }
AbstractCardModelEntity >> set: propertyKey to: aValue [
	self properties at: propertyKey put: aValue.
	self announcer announce: PropertiesUpdated new
]

{ #category : #printing }
AbstractCardModelEntity >> storePropertiesOn: aStream [
	aStream nextPutAll: '  properties: '.
	properties storeOn: aStream.
	aStream
		nextPutAll: ';';
		cr
]
