"
I contain some modeling examples using Card decks.

CardDeckExamples new facultyDoodleDomain 

The Faculty of Science of the University of Bern forms various committees to make decisions on various issues throughout the year (budgets, hiring of professors, teaching evaluations, etc.).
Each committee is composed of Faculty members (i.e., professors), assistants, and also some students. The chair of a committee is always a Faculty member. Committees meet on various dates and may deliver reports to the Dean or to the Faculty.
Committee members can be contacted by email or phone
 
"
Class {
	#name : #CardDeckExamples,
	#superclass : #Object,
	#category : #'IMAD-Cards-Examples'
}

{ #category : #accessing }
CardDeckExamples >> builtModelEqualsGeneratedModel [
	<gtExample>
	| deck |
	deck := self facultyDoodleDomain.
	deck assertGeneratedDeckEqualsSelf.
	^ deck
]

{ #category : #'as yet unclassified' }
CardDeckExamples >> facultyDoodleDomain [
	<storedCardDeck>
	<gtExample>
	^ CardDeck new
		name: 'Faculty Doodle Domain';
		description:
			'I represent the domain of doodles to organize Committee meetings for the Faculty of Science.';
		set: #storageClassName to: 'CardDeckExamples';
		set: #storageMethodName to: 'facultyDoodleDomain';
		addCard:
			(Card new
				name: 'Chair';
				description: 'I chair the committee and am also a Faculty member.';
				yourself);
		addCard:
			(Card new
				name: 'Committee';
				description:
					'I am a committee within the Faculty of Science of the University of Bern. I am formed to make decisions on various issues throughout the year (budgets, hiring of professors, teaching evaluations, etc.).';
				yourself);
		addCard:
			(Card new
				name: 'Meeting';
				description:
					'I am held on a given date, and produce a report to the Dean or the Faculty.';
				yourself);
		addCard:
			(Card new
				name: 'Member';
				description:
					'I am a Faculty member, or possibly an assistant or a student. I can be contacted by email or phone';
				yourself);
		addCard:
			(Card new
				name: 'Report';
				description: '...';
				yourself);
		addRelation: #chair fromCardNamed: 'Committee' toCardNamed: 'Chair';
		addRelation: #meeting
			fromCardNamed: 'Committee'
			toCardNamed: 'Meeting';
		addRelation: #member
			fromCardNamed: 'Committee'
			toCardNamed: 'Member';
		addRelation: #report
			fromCardNamed: 'Committee'
			toCardNamed: 'Report';
		yourself
]
