Class {
	#name : #DoubleClickMenuLook2,
	#superclass : #BrGlamorousWithContextMenuLook2,
	#category : #'IMAD-Cards-View'
}

{ #category : #accessing }
DoubleClickMenuLook2 >> initialize [
	super initialize.
	mouseButton := BlMouseButton primary.
	clickEventHandler := BlEventHandler
		on: BlDoubleClickEvent
		do: [ :e | 
			e button = mouseButton
				ifTrue: [ "e consumed: true."
					self canHide
						ifTrue: [ self hide ].
					position := self root globalPointToLocal: e position.
					self show ] ].

]
