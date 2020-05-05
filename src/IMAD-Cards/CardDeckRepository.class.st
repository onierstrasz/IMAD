Class {
	#name : #CardDeckRepository,
	#superclass : #Object,
	#category : #'IMAD-Cards'
}

{ #category : #accessing }
CardDeckRepository >> generateTestCardDeck [
	"NB: generated method CardDeckRepository>>#generateTestCardDeck. Do not modify."

	<gtExample>
	^ CardDeck new
		set: #storageClassName to: 'CardDeckRepository';
		set: #name to: 'TestDeck';
		set: #description to: 'For testing purposes';
		set: #storageMethodName to: 'generateTestCardDeck';
		addCard:
			(Card new
				set: #name to: 'A';
				set: #description to: 'To do';
				yourself);
		addCard:
			(Card new
				set: #name to: 'B';
				set: #description to: 'To do';
				yourself);
		addCard:
			(Card new
				set: #name to: 'C';
				set: #description to: 'To do';
				yourself);
		addRelation: 'x' fromCardNamed: 'A' toCardNamed: 'B';
		addRelation: 'x' fromCardNamed: 'A' toCardNamed: 'C';
		addRelation: 'y' fromCardNamed: 'B' toCardNamed: 'C';
		addRelation: 'z' fromCardNamed: 'C' toCardNamed: 'B';
		yourself
]
