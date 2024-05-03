"
GtDocument precedes Lepiter and is no longer in the system. We replace it by a message logger to see what messages are sent. It seems like we can subclass BrEditor or maybe BlTextElement.
"
Class {
	#name : #GtDocument,
	#superclass : #BlTextElement,
	#instVars : [
		'messageLog'
	],
	#category : #'IMAD-Hypernodes-Model'
}

{ #category : #logging }
GtDocument >> doesNotUnderstand: aMessage [
	self messageLog addLast: aMessage
]

{ #category : #initialization }
GtDocument >> initialize [
	messageLog := OrderedCollection new
]

{ #category : #logging }
GtDocument >> messageLog [
	^ messageLog
]

{ #category : #logging }
GtDocument >> messageLog: anObject [
	messageLog := anObject
]

{ #category : #'monkey-patch' }
GtDocument >> text: aString [
	super text: aString asRopedText
]
