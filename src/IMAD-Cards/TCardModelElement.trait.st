"
I offer some handy methods for Card Model elements
"
Trait {
	#name : #TCardModelElement,
	#category : #'IMAD-Cards-View'
}

{ #category : #accessing }
TCardModelElement >> tooltipWithText: aString [
	"From TCardModelElement"
	^ BrLabel new
		look: BrGlamorousLabelLook new glamorousRegularFontAndSize;
		padding: (BlInsets all: 5);
		alignCenter;
		text: aString asRopedText;
		yourself.
]
