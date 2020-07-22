Class {
	#name : #VariableClickMenuLook2,
	#superclass : #BrGlamorousWithContextMenuLook2,
	#instVars : [
		'testModifier'
	],
	#category : #'IMAD-Cards-View'
}

{ #category : #accessing }
VariableClickMenuLook2 >> initialize [
	"Adapted from BrWithContextMenuLook>>#initialize"

	super initialize.
	"self changes changes removeLast."
	self usePrimaryMouseButton.
	self testModifier: #isEmpty.
	clickEventHandler := BlEventHandler
		on: BlMouseUpEvent
		do: [ :e | 
			(e button = mouseButton
				and: [ e modifiers perform: self testModifier ])
				ifTrue: [ "e consumed: true."
					self canHide
						ifTrue: [ self hide ].
					position := self root globalPointToLocal: e position.
					self show ] ]
]

{ #category : #accessing }
VariableClickMenuLook2 >> testModifier [
	^ testModifier
]

{ #category : #accessing }
VariableClickMenuLook2 >> testModifier: aSymbol [
	"Possible values: #isAlt, #isCmd, #isCtrl"
	testModifier := aSymbol
]

{ #category : #accessing }
VariableClickMenuLook2 >> useSecondaryMouseButton [
	"Listen to right-click instead of left-click."
	mouseButton := BlMouseButton secondary
]
