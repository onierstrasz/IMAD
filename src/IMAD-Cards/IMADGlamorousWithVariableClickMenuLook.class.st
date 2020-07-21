Class {
	#name : #IMADGlamorousWithVariableClickMenuLook,
	#superclass : #BrGlamorousWithContextMenuLook,
	#instVars : [
		'testModifier'
	],
	#category : #'IMAD-Cards-Examples'
}

{ #category : #accessing }
IMADGlamorousWithVariableClickMenuLook >> initialize [
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
				ifTrue: [ e consumed: true.
					self canHide
						ifTrue: [ self hide ].
					position := e localPosition.
					self show ] ].
	self
		addChange:
			(BrLookChange new
				up: [ :e | widget addEventHandler: clickEventHandler ];
				down: [ :e | widget removeEventHandler: clickEventHandler ];
				yourself)
]

{ #category : #accessing }
IMADGlamorousWithVariableClickMenuLook >> testModifier [
	^ testModifier
]

{ #category : #accessing }
IMADGlamorousWithVariableClickMenuLook >> testModifier: aSymbol [
	"Possible values: #isAlt, #isCmd, #isCtrl"
	testModifier := aSymbol
]

{ #category : #accessing }
IMADGlamorousWithVariableClickMenuLook >> useSecondaryMouseButton [
	"Listen to right-click instead of left-click."
	mouseButton := BlMouseButton secondary
]
