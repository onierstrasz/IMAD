Extension { #name : #BlExampleAtomElement }

{ #category : #'*ASA-GtExperiments' }
BlExampleAtomElement >> color [
	^ color
]

{ #category : #'*ASA-GtExperiments' }
BlExampleAtomElement >> color: aColor [
	color := aColor
]

{ #category : #'*ASA-GtExperiments' }
BlExampleAtomElement >> fullDrawOnSpartaCanvas: aCanvas [
	aCanvas fill
		path: (self bounds inParent asRectangle);
		paint: self color;
		draw
]

{ #category : #'*ASA-GtExperiments' }
BlExampleAtomElement >> initialize [
	"Make a new atom with a random position and velocity."
	super initialize.
	
	color := Color blue.

	self size: 8 @ 7.
	self background: Color red
]
