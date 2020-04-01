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
		'universe',
		'domain'
	],
	#category : #'IMAD-Cards'
}

{ #category : #accessing }
FacultyDoodleModelingExamples >> committeeConcept [
	<gtExample>
	
]

{ #category : #accessing }
FacultyDoodleModelingExamples >> facultyDoodleDomain [
	<gtExample>
	domain ifNil: [
		domain := Card new.
		domain name: #FacultyDoodle;
			kind: #domain;
			universe: self imadUniverse;
			description: 'I am the domain of Doodles for meetings of committees of the Faculty of Science of the University of Bern.'.
		self assert: domain concepts isEmpty.
	].
	^ domain
]

{ #category : #accessing }
FacultyDoodleModelingExamples >> imadUniverse [
	<gtExample>
	universe ifNil: [
		universe := Card new.
		universe name: #IMAD;
			kind: #universe;
			description: 'I am the universe of domains used to exemplify and test the IMAD modeling framework.'.
		self assert: universe domains isEmpty.
		].
	^ universe
]
