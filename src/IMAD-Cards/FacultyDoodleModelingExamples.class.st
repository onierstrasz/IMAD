"
I simulate the exercise of modeling this description:

 Exercise: turn this into a UML class diagram ...
The Faculty of Science of the University of Bern forms various committees to make decisions on various issues throughout the year (budgets, hiring of professors, teaching evaluations, etc.).
Each committee is composed of Faculty members (i.e., professors), assistants, and also some students. The chair of a committee is always a Faculty member. Committees meet on various dates and may deliver reports to the Dean or to the Faculty.
Committee members can be contacted by email or phone
 
"
Class {
	#name : #FacultyDoodleModelingExamples,
	#superclass : #Object,
	#category : #'IMAD-Cards-Examples'
}

{ #category : #accessing }
FacultyDoodleModelingExamples >> buildConcepts [
	"
The Faculty of Science of the University of Bern forms various committees to make decisions on various issues throughout the year (budgets, hiring of professors, teaching evaluations, etc.).
Each committee is composed of Faculty members (i.e., professors), assistants, and also some students. The chair of a committee is always a Faculty member. Committees meet on various dates and may deliver reports to the Dean or to the Faculty.
Committee members can be contacted by email or phone
 	"
 	<gtExample>
 	<todo: 'build the whole model'>
 	| deck |
 	deck := CardDeck new.
 	self assert: deck isEmpty.
 	deck addCardNamed: 'Committee' description: 'I am a committee within the Faculty of Science of the University of Bern. I am formed to make decisions on various issues throughout the year (budgets, hiring of professors, teaching evaluations, etc.).'.
 	deck addCardNamed: 'Member' description: 'I am a Faculty member, or possibly an assistant or a student.'.
 	deck addCardNamed: 'Chair' description: '...'.
 	deck addCardNamed: 'Meeting' description: '...'.
 	deck addCardNamed: 'Report' description: '...'.
 	
 	"
 	deck addCardNamed: 'xxx' description: '...'.
 	deck addCardNamed: 'xxx' description: '...'.
 	deck addCardNamed: 'xxx' description: '...'.
 	"
 	self assert: deck size equals: 5.
 	^ deck
]

{ #category : #accessing }
FacultyDoodleModelingExamples >> committeeConcept [
	<gtExample>
	| deck card cardName |
	deck := CardDeck new.
	cardName := 'Committee'.
	self assert: (deck cardsNamed: cardName) isEmpty.
	card := Card new.
	card name: cardName;
		description: 'I am a committee within the Faculty of Science of the University of Bern.';
		yourself.
	deck add: card.
	self assert: (deck cardsNamed: cardName) size equals: 1.
	^ deck
]
