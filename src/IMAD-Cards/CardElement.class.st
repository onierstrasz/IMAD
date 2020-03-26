"
I provide a view for a Card.
"
Class {
	#name : #CardElement,
	#superclass : #BlElement,
	#category : #'IMAD-Cards'
}

{ #category : #accessing }
CardElement >> initialize [
	super initialize.
	self
		size: 200 @ 300;
		margin: (BlInsets all: 10);
		look: BrShadowLook;
		background: Color white;
		addChild:
			(BrLabel new
				look: (BrGlamorousLabelLook new bold glamorousRegularFont fontSize: 20);
				text: 'Woohoo')
]
