Class {
	#name : #CardFilterTestExamples,
	#superclass : #Object,
	#instVars : [
		'deck'
	],
	#category : #'IMAD-Cards-Examples'
}

{ #category : #accessing }
CardFilterTestExamples >> deckHasOneUni [
	<gtExample>
	| filter result |
	filter := CardTagFilter new tag: 'uni'.
	result := deck cardsMatching: filter
]

{ #category : #accessing }
CardFilterTestExamples >> initialize [
	deck := self modelDeck
]

{ #category : #'as yet unclassified' }
CardFilterTestExamples >> modelDeck [
	<storedCardDeck>
	<gtExample>
	^ CardDeck new
		name: #CardDeck546856448;
		description: 'To do';
		set: #storageClassName to: 'CardFilterTestExamples';
		set: #storageMethodName to: 'modelDeck';
		addCard:
			(Card new
				name: 'FBMSI';
				description: 'To do';
				yourself);
		addCard:
			(Card new
				name: 'FBPhysics';
				description: 'To do';
				addTag: 'fb';
				yourself);
		addCard:
			(Card new
				name: 'INF';
				description: 'To do';
				addTag: 'inst';
				addTag: 'inf';
				yourself);
		addCard:
			(Card new
				name: 'Math';
				description: 'To do';
				addTag: 'inst';
				yourself);
		addCard:
			(Card new
				name: 'PhilHist';
				description: 'To do';
				addTag: 'faculty';
				yourself);
		addCard:
			(Card new
				name: 'PhilHum';
				description: 'To do';
				addTag: 'faculty';
				yourself);
		addCard:
			(Card new
				name: 'PhilNat';
				description: 'To do';
				addTag: 'faculty';
				addTag: 'philnat';
				yourself);
		addCard:
			(Card new
				name: 'Stats';
				description: 'To do';
				addTag: 'inst';
				yourself);
		addCard:
			(Card new
				name: 'Unibe';
				description: 'To do';
				addTag: 'uni';
				yourself);
		addRelation: 'partOf' fromCardNamed: 'FBMSI' toCardNamed: 'INF';
		addRelation: 'partOf' fromCardNamed: 'FBMSI' toCardNamed: 'Math';
		addRelation: 'partOf' fromCardNamed: 'FBMSI' toCardNamed: 'Stats';
		addRelation: 'partOf' fromCardNamed: 'PhilNat' toCardNamed: 'FBMSI';
		addRelation: 'partOf'
			fromCardNamed: 'PhilNat'
			toCardNamed: 'FBPhysics';
		addRelation: 'partOf'
			fromCardNamed: 'Unibe'
			toCardNamed: 'PhilHist';
		addRelation: 'partOf' fromCardNamed: 'Unibe' toCardNamed: 'PhilHum';
		addRelation: 'partOf' fromCardNamed: 'Unibe' toCardNamed: 'PhilNat';
		yourself
]
