"
I extend ${class:BrGlamorousWithContextMenuLook}$ by allowing contextual menus to open on specific modified mouse events, namely CTRL-, ALT-, and CMD-click and right-click.

See ${method:UsefulExamples>>#elementHandlingClickEvents}$ for usage examples.

"
Class {
	#name : #VariableClickMenuLook,
	#superclass : #BrGlamorousWithContextMenuLook,
	#instVars : [
		'testModifier'
	],
	#category : #'IMAD-Cards-View'
}

{ #category : #accessing }
VariableClickMenuLook >> initialize [
	"Adapted from BrWithContextMenuLook>>#initialize"
	
	<todo: 'BROKEN -- to be fixed'>

	super initialize.
	"self changes changes removeLast."
	self usePrimaryMouseButton.
	self testModifier: #isEmpty.
	"clickEventHandler := BlEventHandler
		on: BlMouseUpEvent
		do: [ :e | 
			(e button = mouseButton
				and: [ e modifiers perform: self testModifier ])
				ifTrue: [ e consumed: true.
					self canHide
						ifTrue: [ self hide ].
					position := e localPosition.
					self show ] ]."
	"self
		addChange:
			(BrLookChange new
				up: [ :e | widget addEventHandler: clickEventHandler ];
				down: [ :e | widget removeEventHandler: clickEventHandler ];
				yourself)"
]

{ #category : #accessing }
VariableClickMenuLook >> testModifier [
	^ testModifier
]

{ #category : #accessing }
VariableClickMenuLook >> testModifier: aSymbol [
	"Possible values: #isAlt, #isCmd, #isCtrl"
	testModifier := aSymbol
]

{ #category : #accessing }
VariableClickMenuLook >> useSecondaryMouseButton [
	"Listen to right-click instead of left-click."
	mouseButton := BlMouseButton secondary
]
