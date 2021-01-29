Class {
	#name : #ConfigurableNodeLookExamples,
	#superclass : #Object,
	#category : #'IMAD-Hypernodes'
}

{ #category : #accessing }
ConfigurableNodeLookExamples >> basicElement [
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
ConfigurableNodeLookExamples >> changingLookMenuFor: configLook [
	^ BrGlamorousSimpleContextMenuContent new
		items:
			{('Green border and rounded rectangle'
				-> [ configLook
						border: #green;
						shape: #roundedRectangle;
						text: 'Green border and rounded rectangle' ]).
			('Red border and straight rectangle'
				-> [ configLook
						border: #red;
						shape: #rectangle;
						text: 'Red border and straight rectangle' ]).
			('Green background' -> [ configLook background: #lightGreen ]).
			('White background' -> [ configLook background: #white ]).
			('Circle' -> [ configLook shape: #circle ]).
			('Square' -> [ configLook shape: #square ]).
			('Be wider' -> [ configLook beWider ])};
		yourself
]

{ #category : #accessing }
ConfigurableNodeLookExamples >> circleNode [
	<gtExample>
	<todo: 'How to make this work with no text, or empty text?'>
	| elt |
	elt := self basicElement.
	elt look: (ConfigurableNodeLook new shape: #circle;
	text: '';
	border: #red).
	^ elt
]

{ #category : #accessing }
ConfigurableNodeLookExamples >> elementWithChangingLook [
	"See BrLookChangeExamples>>#buttonLookPropertyChange"

	<gtExample>
	| elt menuLook configLook |
	elt := BlElement new.
	elt layout: BlFrameLayout new.	"needed to enable alignCenter for embedded Text elements"
	elt
		constraintsDo: [ :c | 
			c horizontal fitContent.
			c vertical fitContent ].
	configLook := ConfigurableNodeLook new
		text: 'Right-click to change my look'.
	menuLook := BrGlamorousWithContextMenuLook
		content:
			[ self changingLookMenuFor: configLook ].
	elt look: menuLook + configLook.
	^ elt
]

{ #category : #accessing }
ConfigurableNodeLookExamples >> newRoundedTextNode [
	"Copy configurations and directly interpret them."

	<gtExample>
	| elt aLook aRoundedTextLook |
	aRoundedTextLook := self roundedTextNode look.
	elt := self basicElement.
	aLook := ConfigurableNodeLook new
		configuration: aRoundedTextLook configuration.
	elt look: aLook.
	self
		assert: aLook configuration
		equals: aRoundedTextLook configuration.
	elt look: aLook.
	^ elt
]

{ #category : #accessing }
ConfigurableNodeLookExamples >> plainTextBox [
	<gtExample>
	| elt |
	elt := self basicElement.
	elt
		look:
			(ConfigurableNodeLook new
				text: 'woohoo';
				border: #black).
	^ elt
]

{ #category : #accessing }
ConfigurableNodeLookExamples >> roundedTextNode [
	<gtExample>
	| elt aLook |
	elt := self basicElement.
	aLook := ConfigurableNodeLook new
		shape: #roundedRectangle;
		text: 'The quick brown fox';
		border: #brown.
	self
		assert: aLook configuration
		equals:
			({(#shape -> #roundedRectangle).
			(#text -> 'The quick brown fox').
			(#border -> #brown)} as: KeyedTree).
	elt look: aLook.
	^ elt
]
