"
A temporary workaround as a substitute for ""self inform:"".

	Shout out: 'hello!'
"
Class {
	#name : #Shout,
	#superclass : #Object,
	#category : #'IMAD-Cards-Utilities'
}

{ #category : #'as yet unclassified' }
Shout class >> out: aString [
	^ self new out: aString
]

{ #category : #'as yet unclassified' }
Shout >> out: aString [
	| aSpace aText |
	aText := BlRopedText string: aString.
	aSpace := BlSpace new.
	aSpace title: aString.
	aSpace extent: 500 @ 50.
	aSpace addChild: (BlTextElement new text: aText). "NB: Could be any kind of BlElement"
	aSpace withHalos.
	aSpace show
]
