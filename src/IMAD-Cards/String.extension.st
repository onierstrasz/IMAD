Extension { #name : #String }

{ #category : #'*IMAD-Cards' }
String >> asBrEditableLabel [
	^ BrEditableLabel new
		look:
			(BrGlamorousEditableLabelLook new
				defaultBackground: Color veryVeryLightGray);
		text: self
]

{ #category : #'*IMAD-Cards' }
String >> asBrLabel [
	^ BrLabel new
		look: BrGlamorousLabelLook;
		text: self
]
