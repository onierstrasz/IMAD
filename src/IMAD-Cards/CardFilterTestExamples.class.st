"
The model deck models the university hierarchy of faculties and institutes (partially).
Tags are 
"
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
	filter :=  'uni' asTagFilter.
	result := deck cardsMatching: filter.
	self assert: result size equals: 1.
	^ result
]

{ #category : #accessing }
CardFilterTestExamples >> deckHasSevenTags [
	<gtExample>
	self assert: deck tags size equals: 7
]

{ #category : #accessing }
CardFilterTestExamples >> deckHasThreeFBMInsititutes [
	<gtExample>
	| filter result |
	filter := 'fbm' asTagFilter.
	result := deck cardsMatching: filter.
	self assert: result size equals: 3.
	^ result
]

{ #category : #accessing }
CardFilterTestExamples >> facultyFilterNotPhilNatHasOnePositiveTag [
	"When a we add a card to a handm we want to know which tags must be set so that the new card will pass the filter."

	<gtExample>
	| filter result |
	filter := 'faculty' asTagFilter & 'philnat' asTagFilter not.
	result := filter positiveTags.
	self assert: result equals: {'faculty'} asSet.
	^ result
]

{ #category : #accessing }
CardFilterTestExamples >> fbmHasOneInf [
	<gtExample>
	| filter result |
	filter := 'inf' asTagFilter & 'fbm' asTagFilter.
	result := deck cardsMatching: filter.
	self assert: result size equals: 1.
	^ result
]

{ #category : #accessing }
CardFilterTestExamples >> initialize [
	deck := self modelDeck
]

{ #category : #accessing }
CardFilterTestExamples >> intersectionTagFilterHasTwoKeyTagDictionary [
	<gtExample>
	| filter |
	filter := self negativeTagFilterHasOneKeyTagDictionary
		& self tagFilterHasOneKeyTagDictionary.
	self
		assert: filter tagDictionaries
		equals:
			(OrderedCollection
				with:
					{('foo' -> #on).
					('bar' -> #negated)} asDictionary).
	^ filter
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
CardFilterTestExamples >> negativeTagFilterHasOneKeyTagDictionary [
	<gtExample>
	| filter |
	filter := self trueFilterHasEmptyTagDictionary
		& 'bar' asTagFilter not.
	self
		assert: filter tagDictionaries
		equals: (OrderedCollection with: {('bar' -> #negated)} asDictionary).
	^ filter
]

{ #category : #accessing }
CardFilterTestExamples >> notPhilNatFilterHasTwoTags [
	<gtExample>
	| filter result |
	filter := 'faculty' asTagFilter & 'philnat' asTagFilter not.
	self assert: filter tags size equals: 2.
	self assert: filter tags equals: {'faculty' . 'philnat'} asSet.
	^ filter
]

{ #category : #accessing }
CardFilterTestExamples >> tagFilterHasOneKeyTagDictionary [
	<gtExample>
	| filter |
	filter := self trueFilterHasEmptyTagDictionary & 'foo' asTagFilter.
	self
		assert: filter tagDictionaries
		equals: (OrderedCollection with: {('foo' -> #on)} asDictionary).
	^ filter
]

{ #category : #accessing }
CardFilterTestExamples >> trueFilterHasEmptyTagDictionary [
	<gtExample>
	| filter |
	filter := TrueFilter new.
	self
		assert: filter tagDictionaries
		equals: (OrderedCollection with: Dictionary new).
	^ filter
]

{ #category : #accessing }
CardFilterTestExamples >> uniHasTwoFacultiesNotPhilNat [
	<gtExample>
	| filter result |
	filter := ('faculty' asTagFilter)
		& ( 'philnat' asTagFilter) not.
	result := deck cardsMatching: filter.
	self assert: result size equals: 2.
	^ result
]

{ #category : #accessing }
CardFilterTestExamples >> unionTagFilterHasTwoKeyTagDictionary [
	<gtExample>
	| filter |
	filter := self negativeTagFilterHasOneKeyTagDictionary
		| self tagFilterHasOneKeyTagDictionary.
	self
		assert: filter tagDictionaries asSet
		equals:
			(OrderedCollection
				with: {('foo' -> #on)} asDictionary
				with: {('bar' -> #negated)} asDictionary) asSet.
	^ filter
]
