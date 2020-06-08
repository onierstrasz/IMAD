"
I  provide a dedicated view for a Card Deck, or a subset of Cards in a Deck.

"
Class {
	#name : #CardDeckElement,
	#superclass : #BlElement,
	#instVars : [
		'deck'
	],
	#category : #'IMAD-Cards-View'
}

{ #category : #accessing }
CardDeckElement >> deck: aCardDeck [
	deck := aCardDeck
]

{ #category : #accessing }
CardDeckElement >> initialize [
	<todo: 'Move CardDeck graph implementation here'>
	super initialize.
	self addChild: (BlTextElement new text: ('A Deck' asRopedText fontSize: 12))
]
