"
I provide a view for a Card.
"
Class {
	#name : #CardElement,
	#superclass : #CardModelElement,
	#category : #'IMAD-Cards-UI'
}

{ #category : #initialization }
CardElement >> initialize [
	super initialize.
	self entity: Card new. "placeholder"
]
