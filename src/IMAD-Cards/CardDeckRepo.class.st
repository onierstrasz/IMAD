Class {
	#name : #CardDeckRepo,
	#superclass : #Object,
	#category : #'IMAD-Cards'
}

{ #category : #accessing }
CardDeckRepo >> generateCardDeck [
	"NB: generated method CardDeckRepo>>#generateCardDeck. Do not modify."

	<gtExample>
	^ CardDeck new
		set: #storageClassName to: 'CardDeckRepo';
		set: #name to: #CardDeck25677312;
		set: #description to: 'To do';
		set: #storageMethodName to: 'generateCardDeck';
		yourself
]
