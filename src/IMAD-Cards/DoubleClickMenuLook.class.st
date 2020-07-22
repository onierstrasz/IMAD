Class {
	#name : #DoubleClickMenuLook,
	#superclass : #BrGlamorousWithContextMenuLook,
	#category : #'IMAD-Cards-View'
}

{ #category : #accessing }
DoubleClickMenuLook >> initialize [
	super initialize.
	mouseButton := BlMouseButton primary.
	clickEventHandler := BlEventHandler
		on: BlDoubleClickEvent
		do: [ :e | 
			e button = mouseButton
				ifTrue: [ e consumed: true.
					self canHide
						ifTrue: [ self hide ].
					position := e localPosition.
					self show ] ].

]
