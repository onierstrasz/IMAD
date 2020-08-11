Class {
	#name : #ConfigurableLookExamples,
	#superclass : #Object,
	#category : #'IMAD-Cards-View'
}

{ #category : #accessing }
ConfigurableLookExamples >> basicElement [
	<gtExample>
	^ BlElement new
		layout: BlLinearLayout vertical;
		constraintsDo: [ :c | 
			c horizontal fitContent.
			c vertical fitContent ]
]

{ #category : #accessing }
ConfigurableLookExamples >> circleNode [
	<gtExample>
	| elt |
	elt := BlElement new.
	elt look: (ConfigurableLook new shape: #circle;
	border: #red).
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
	| elt |
	elt := BlElement new.
	elt look: (ConfigurableLook new shape: #circle;
	border: #black).
	^ elt
]
