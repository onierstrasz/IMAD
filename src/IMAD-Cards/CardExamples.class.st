"
I contain a bunch of examples of index cards to specify domain concepts.

"
Class {
	#name : #CardExamples,
	#superclass : #Object,
	#category : #'IMAD-Cards-Examples'
}

{ #category : #accessing }
CardExamples >> emptyCard [
	<gtExample>
	^ Card new name: 'Woohoo'
]
