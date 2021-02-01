Class {
	#name : #HNConfigurableLookExamples,
	#superclass : #Object,
	#category : #'IMAD-Hypernodes'
}

{ #category : #accessing }
HNConfigurableLookExamples >> basicElement [
	<gtExample>
	<todo:
		'Here we mirror the basuc setup of the HypernodeElement.
		Can we make the layout also part of the configuration?
		What layout should we use by default?
		BlFrameLayout or BlLinearLayout vertical ?'>
	^ BlElement new
		layout: BlFrameLayout new;
		constraintsDo: [ :c | 
			c horizontal fitContent.
			c vertical fitContent ]
]

{ #category : #accessing }
HNConfigurableLookExamples >> changingLookMenuFor: configLook [
	^ BrGlamorousSimpleContextMenuContent new
		items:
			{('Green border and rounded rectangle'
				-> [ configLook
						updateAll:
							{(#borderColor -> #green).
							(#shape -> #roundedRectangle).
							(#text -> 'Green border and rounded rectangle')} ]).
			('Red border and straight rectangle'
				-> [ configLook
						updateAll:
							{(#borderColor -> #red).
							(#shape -> #rectangle).
							(#text -> 'Red border and straight rectangle')} ]).
			('Green background'
				-> [ configLook update: #background -> #lightGreen ]).
			('White background' -> [ configLook update: #background -> #white ]).
			('Circle' -> [ configLook update: #shape -> #circle ]).
			('Square' -> [ configLook update: #shape -> #square ]).
			('Be wider' -> [ configLook beWider ])};
		yourself
]

{ #category : #accessing }
HNConfigurableLookExamples >> circleNode [
	<gtExample>
	<todo: 'How to make this work with no text, or empty text?'>
	| elt |
	elt := self basicElement.
	elt
		look:
			(HNConfigurableLook new
				configuration:
					{(#shape -> #circle).
					(#text -> '').
					(#borderColor -> #red)}).
	^ elt
]

{ #category : #accessing }
HNConfigurableLookExamples >> elementWithChangingLook [
	"See also BrLookChangeExamples>>#buttonLookPropertyChange"

	<gtExample>
	| elt menuLook configLook |
	elt := self basicElement.
	configLook := HNConfigurableLook
		configuration: {(#text -> 'Right-click to change my look')} asDictionary.
	menuLook := BrGlamorousWithContextMenuLook
		content: [ self changingLookMenuFor: configLook ].
	elt look: menuLook + configLook.
	^ elt
]

{ #category : #accessing }
HNConfigurableLookExamples >> hoverColorChange [
	"Copy configurations and directly interpret them."

	<gtExample>
	| elt |
	elt := self newRoundedTextNode.
	elt look
		updateAll:
			{(#borderColor -> #blue).
			(#hoverColor -> #red)}.
	^ elt
]

{ #category : #accessing }
HNConfigurableLookExamples >> newRoundedTextNode [
	"Copy configurations and directly interpret them."

	<gtExample>
	| elt aLook aRoundedTextLook |
	aRoundedTextLook := self roundedTextNode look.
	elt := self basicElement.
	aLook := HNConfigurableLook new
		configuration: aRoundedTextLook configuration.
	elt look: aLook.
	self
		assert: aLook configuration
		equals: aRoundedTextLook configuration.
	elt look: aLook.
	^ elt
]

{ #category : #accessing }
HNConfigurableLookExamples >> plainTextBox [
	<gtExample>
	| elt |
	elt := self basicElement.
	elt
		look:
			(HNConfigurableLook new
				configuration:
					{(#text -> 'woohoo').
					(#borderColor -> #black)}).
	^ elt
]

{ #category : #accessing }
HNConfigurableLookExamples >> roundedTextNode [
	<gtExample>
	| elt aLook |
	elt := self basicElement.
	aLook := HNConfigurableLook
		configuration:
			{(#shape -> #roundedRectangle).
			(#text -> 'The quick brown fox').
			(#borderColor -> #brown)}.
	self
		assert: aLook configuration
		equals:
			{(#shape -> #roundedRectangle).
			(#text -> 'The quick brown fox').
			(#borderColor -> #brown)} asDictionary.
	elt look: aLook.
	^ elt
]

{ #category : #accessing }
HNConfigurableLookExamples >> updateBorderColor [
	<gtExample>
	| elt aLook |
	elt := self roundedTextNode.
	elt look update: #borderColor ->#green.
	^ elt
]

{ #category : #accessing }
HNConfigurableLookExamples >> updateCornerRadius [
	<gtExample>
	| elt aLook |
	elt := self roundedTextNode.
	elt look update: #cornerRadius -> 10.
	^ elt
]

{ #category : #accessing }
HNConfigurableLookExamples >> updatePadding [
	<gtExample>
	| elt aLook |
	elt := self roundedTextNode.
	elt look update: #padding -> 20.
	^ elt
]

{ #category : #accessing }
HNConfigurableLookExamples >> updateShape [
	<gtExample>
	| elt aLook |
	elt := self roundedTextNode.
	elt look update: #shape ->#rectangle.
	^ elt
]

{ #category : #accessing }
HNConfigurableLookExamples >> updateText [
	<gtExample>
	| elt aLook |
	elt := self roundedTextNode.
	elt look update: #text -> 'The lazy dog'.
	^ elt
]
