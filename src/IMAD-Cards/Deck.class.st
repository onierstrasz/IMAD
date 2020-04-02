Class {
	#name : #Deck,
	#superclass : #Object,
	#instVars : [
		'cards'
	],
	#category : #'IMAD-Cards'
}

{ #category : #accessing }
Deck >> add: aCard [
	cards add: aCard
]

{ #category : #accessing }
Deck >> cardNamed: aString [
	| result |
	result := cards select: [:each | each name = aString].
	self assert: result size equals: 1.
	^ result at: 1
]

{ #category : #accessing }
Deck >> cardsNamed: aString [
	^ cards select: [:each | each name = aString]
]

{ #category : #accessing }
Deck >> initialize [
	super initialize.
	cards := OrderedCollection new.
]

{ #category : #accessing }
Deck >> isEmpty [
	^ cards isEmpty
]

{ #category : #accessing }
Deck >> listTodos [
	<gtExample>
	^ #todo: gtPragmas & 'IMAD-Card' gtPackageMatches
]
