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
	"sample code from TG to start with"

	^ BlElement new
		size: 200 @ 300;
		margin: (BlInsets all: 10);
		look: BrShadowLook;
		background: Color white;
		addChild:
			(BrLabel new
				look: (BrGlamorousLabelLook new bold glamorousRegularFont fontSize: 20);
				text: 'Woohoo')
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
