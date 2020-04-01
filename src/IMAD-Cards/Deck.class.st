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
Deck >> cardsNamed: aString [
	^ cards select: [:each | each name = aString]
]

{ #category : #accessing }
Deck >> initialize [
	super initialize.
	cards := OrderedCollection new.
]
