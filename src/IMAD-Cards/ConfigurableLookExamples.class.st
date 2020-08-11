Class {
	#name : #ConfigurableLookExamples,
	#superclass : #Object,
	#category : #'IMAD-Cards-View'
}

{ #category : #accessing }
ConfigurableLookExamples >> basicElement [
	<gtExample>
	<todo:
		'Only needed if we have text or other children. Should this be part of the look?'>
	^ BlElement new
		layout: BlLinearLayout vertical;
		constraintsDo: [ :c | 
			c horizontal fitContent.
			c vertical fitContent ]
]

{ #category : #accessing }
ConfigurableLookExamples >> circleNode [
	<gtExample>
	<todo: 'How to make this work with no text, or empty text?'>
	| elt |
	elt := self basicElement.
	elt look: (ConfigurableLook new shape: #circle;
	text: '';
	border: #red).
	^ elt
]

{ #category : #accessing }
ConfigurableLookExamples >> newRoundedTextNode [
	"Copy configurations and directly interpret them."

	<gtExample>
	| elt aLook aRoundedTextLook |
	aRoundedTextLook := self roundedTextNode look.
	elt := self basicElement.
	aLook := ConfigurableLook new
		configuration: aRoundedTextLook configuration.
	elt look: aLook.
	self
		assert: aLook configuration
		equals: aRoundedTextLook configuration.
	elt look: aLook.
	^ elt
]

{ #category : #accessing }
ConfigurableLookExamples >> plainTextBox [
	<gtExample>
	| elt |
	elt := self basicElement.
	elt
		look:
			(ConfigurableLook new
				text: 'woohoo';
				border: #black).
	^ elt
]

{ #category : #accessing }
ConfigurableLookExamples >> roundedTextNode [
	<gtExample>
	| elt aLook |
	elt := self basicElement.
	aLook := ConfigurableLook new
		shape: #roundedRectangle;
		text: 'The quick brown fox';
		border: #brown.
	self
		assert: aLook configuration
		equals:
			{(#shape -> #roundedRectangle).
			(#text -> 'The quick brown fox').
			(#border -> #brown)} asDictionary.
	elt look: aLook.
	^ elt
]
