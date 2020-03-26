"
I am a holder of information about a domain concept in a domain model.
I provide a UI to enter, edit and manipulate this information.
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

	^ CardElement new

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
Card >> title: aString [
	title := aString 

]
