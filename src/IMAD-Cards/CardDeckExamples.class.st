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
	| deck1 deck2 genMethod |
	deck1 := self facultyDoodleDomain.
	deck1 compileMethodString.
	genMethod := (deck1 storageClass >> deck1 genMethodName asSymbol).
	deck2 := genMethod valueWithReceiver: deck1 arguments: #().
	genMethod removeFromSystem.
	self assert: deck1 equals: deck2.
	^ deck1 = deck2
]

{ #category : #accessing }
CardDeckExamples >> facultyDoodleDomain [
	<gtExample>
	<todo: 'expand with missing concepts'>
	| deck |
	deck := CardDeck new.
	self assert: deck isEmpty.
	
	deck
		name: 'Faculty Doodle Domain';
		description: 'I represent the domain of doodles to organize Committee meetings for the Faculty of Science.';
		storageClassName: 'CardDeckExamples';
		generatingMethodName: 'genFacultyDoodleModelingExamples'.
	
	deck
		addCardNamed: 'Committee'
		description:
			'I am a committee within the Faculty of Science of the University of Bern. I am formed to make decisions on various issues throughout the year (budgets, hiring of professors, teaching evaluations, etc.).'.

	deck
		addCardNamed: 'Member'
		description:
			'I am a Faculty member, or possibly an assistant or a student. I can be contacted by email or phone'.
	deck cardNamed: 'Member' become: #member ofCardNamed: 'Committee'.
	
	self assert: ((deck cardNamed: 'Member') is: #member of: (deck cardNamed: 'Committee')).

	deck
		addCardNamed: 'Chair'
		description: 'I chair the committee and am also a Faculty member.'.
	deck cardNamed: 'Chair' become: #chair ofCardNamed: 'Committee'.

	self assert: ((deck cardNamed: 'Chair') is: #chair of: (deck cardNamed: 'Committee')).

	deck
		addCardNamed: 'Meeting'
		description:
			'I am held on a given date, and produce a report to the Dean or the Faculty.'.
	deck cardNamed: 'Meeting' become: #meeting ofCardNamed: 'Committee'.

	self assert: ((deck cardNamed: 'Meeting') is: #meeting of: (deck cardNamed: 'Committee')).

	deck addCardNamed: 'Report' description: '...'.	
	"deck cardNamed: 'Report' become: #report ofCardNamed: 'Committee'."
	deck addRelation: #report fromCardNamed: 'Committee' toCardNamed: 'Report'.
	
	self assert: ((deck cardNamed: 'Report') is: #report of: (deck cardNamed: 'Committee')).

	self assert: deck size equals: 5.
	^ deck
]
