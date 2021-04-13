Class {
	#name : #HNConfigurableLookExamples,
	#superclass : #Object,
	#category : #'IMAD-Hypernodes'
}

{ #category : #accessing }
HNConfigurableLookExamples >> basicElement [
	<gtExample>
	<todo:
		'Here we mirror the basic setup of the HypernodeElement.
		Can we make the layout also part of the configuration?
		What layout should we use by default?
		BlFrameLayout or BlLinearLayout vertical ?'>
	^ BlElement new
		layout: BlFrameLayout new;
		"layout: BlLinearLayout vertical;"
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
	| elt |
	elt := self basicElement.
	elt
		aptitude:
			(HNConfigurableLook new
				configuration:
					{(#shape -> #circle).
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
	menuLook := BrGlamorousWithContextMenuAptitude
		content: [ self changingLookMenuFor: configLook ].
	elt aptitude: menuLook + configLook.
	^ elt
]

{ #category : #accessing }
HNConfigurableLookExamples >> hoverColorChange [
	"Copy configurations and directly interpret them."

	<gtExample>
	| elt |
	elt := self newRoundedTextNode.
	elt aptitude
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
	aRoundedTextLook := self roundedTextNode aptitude.
	elt := self basicElement.
	aLook := HNConfigurableLook new
		configuration: aRoundedTextLook configuration.
	elt aptitude: aLook.
	self
		assert: aLook configuration
		equals: aRoundedTextLook configuration.
	elt aptitude: aLook.
	^ elt
]

{ #category : #accessing }
HNConfigurableLookExamples >> plainTextBox [
	<gtExample>
	| elt |
	elt := self basicElement.
	elt
		aptitude:
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
			(#borderColor -> #brown).
			(#padding -> 5)} asDictionary.
	elt aptitude: aLook.
	^ elt
]

{ #category : #accessing }
HNConfigurableLookExamples >> updateBorderColor [
	<gtExample>
	| elt aLook |
	elt := self roundedTextNode.
	elt aptitude update: #borderColor -> #green.
	^ elt
]

{ #category : #accessing }
HNConfigurableLookExamples >> updateCornerRadius [
	<gtExample>
	| elt aLook |
	elt := self roundedTextNode.
	elt aptitude update: #cornerRadius -> 10.
	^ elt
]

{ #category : #accessing }
HNConfigurableLookExamples >> updatePadding [
	<gtExample>
	| elt aLook |
	elt := self roundedTextNode.
	elt aptitude update: #padding -> 20.
	^ elt
]

{ #category : #accessing }
HNConfigurableLookExamples >> updateShape [
	<gtExample>
	| elt aLook |
	elt := self roundedTextNode.
	elt aptitude update: #shape -> #rectangle.
	^ elt
]

{ #category : #accessing }
HNConfigurableLookExamples >> updateText [
	<gtExample>
	| elt aLook |
	elt := self roundedTextNode.
	elt aptitude update: #text -> 'The lazy dog'.
	^ elt
]
