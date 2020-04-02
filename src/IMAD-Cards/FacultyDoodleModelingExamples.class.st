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
	#instVars : [
		'deck'
	],
	#category : #'IMAD-Cards-Examples'
}

{ #category : #accessing }
FacultyDoodleModelingExamples >> committeeConcept [
	<gtExample>
	| card cardName |
	cardName := 'Committee'.
	self assert: (deck cardsNamed: cardName) isEmpty.
	card := Card new.
	card name: cardName;
		description: 'I am a committee within the Faculty of Science of the University of Bern.';
		yourself.
	deck add: card.
	self assert: (deck cardsNamed: cardName) size equals: 1.
	^ card
]

{ #category : #accessing }
FacultyDoodleModelingExamples >> initialize [
	super initialize.
	deck := Deck new.
]
