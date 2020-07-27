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
	filter := self uniFilter.
	result := deck cardsMatching: filter.
	self assert: result size equals: 1.
	^ result
]

{ #category : #accessing }
CardFilterTestExamples >> deckHasThreeFBMInsititutes [
	<gtExample>
	| filter result |
	filter := self fbmFilter.
	result := deck cardsMatching: filter.
	self assert: result size equals: 3.
	^ result
]

{ #category : #accessing }
CardFilterTestExamples >> fbmFilter [
	^ CardTagFilter new tag: 'fbm'
]

{ #category : #accessing }
CardFilterTestExamples >> fbmHasOneInf [
	<gtExample>
	| filter result |
	filter := self infAndFbmFilter.
	result := deck cardsMatching: filter.
	self assert: result size equals: 1.
	^ result
]

{ #category : #accessing }
CardFilterTestExamples >> infAndFbmFilter [
	^ self fbmFilter & self infFilter
]

{ #category : #accessing }
CardFilterTestExamples >> infFilter [
	^ CardTagFilter new tag: 'inf'
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
				addTag: 'fb';
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
				addTag: 'fbm';
				yourself);
		addCard:
			(Card new
				name: 'Math';
				description: 'To do';
				addTag: 'inst';
				addTag: 'fbm';
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
				addTag: 'fbm';
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

{ #category : #accessing }
CardFilterTestExamples >> uniFilter [
	^ CardTagFilter new tag: 'uni'
]
