Extension { #name : #String }

{ #category : #'*IMAD-Cards' }
String >> asBrLabel [
	^ BrLabel new
		look: BrGlamorousLabelLook;
		text: self
]
