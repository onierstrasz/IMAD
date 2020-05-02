"
I am a utility class for this package. I can run all the tests and find all the todos.

	IMAD gtExamples
	
	IMAD todos

"
Class {
	#name : #IMAD,
	#superclass : #Object,
	#category : #'IMAD-Cards-Utilities'
}

{ #category : #converting }
IMAD class >> gtExamples [
	^ self new allExamples
]

{ #category : #converting }
IMAD class >> todos [
	^ self new findAllTodos
]

{ #category : #accessing }
IMAD >> allExamples [
	<gtExample>
	^ ('IMAD' gtPackageMatches & #gtExample gtReferences) gtExamples
]

{ #category : #accessing }
IMAD >> findAllTodos [
	<gtExample>
	^ #todo: gtPragmas & 'IMAD-Card' gtPackageMatches
]
