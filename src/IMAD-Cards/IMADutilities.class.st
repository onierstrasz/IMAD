"
I am a utility class for this package. I can run all the tests and find all the todos.
"
Class {
	#name : #IMADutilities,
	#superclass : #Object,
	#category : #'IMAD-Cards-Utilities'
}

{ #category : #accessing }
IMADutilities >> findAllTodos [
	<gtExample>
	^ #todo: gtPragmas & 'IMAD-Card' gtPackageMatches
]

{ #category : #accessing }
IMADutilities >> runAllExamples [
	<gtExample>
	^ ('IMAD' gtPackageMatches & #gtExample gtReferences) gtExamples
]
