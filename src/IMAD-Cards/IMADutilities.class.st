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
