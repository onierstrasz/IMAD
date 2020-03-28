"
I am a holder of information about a domain concept in a domain model.
I provide a UI to enter, edit and manipulate this information.

I have a title, a description, and other properties.



"
Class {
	#name : #Card,
	#superclass : #Object,
	#instVars : [
		'title'
	],
	#category : #'IMAD-Cards'
}

{ #category : #accessing }
Card >> asElement [
	| element |
	element := CardElement new.
	element card: self.
	^ element
]

{ #category : #accessing }
Card >> gtLiveFor: aView [
	<gtView>
	^ aView explicit
		title: 'Live';
		priority: 0;
		stencil: [ self ]
]

{ #category : #accessing }
Card >> initialize [
	super initialize.
	self title: '(undefined)'
]

{ #category : #accessing }
Card >> title [
	^ title
]

{ #category : #accessing }
Card >> title: aString [
	title := aString 

]
