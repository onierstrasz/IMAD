Extension { #name : #String }

{ #category : #'*IMAD' }
String >> asBrEditableLabel [
	^ BrEditableLabel new
		aptitude:
			(BrGlamorousEditableLabelAptitude new
				defaultBackground: Color veryVeryLightGray);
		text: self
]

{ #category : #'*IMAD' }
String >> asBrLabel [
	^ BrLabel new
		aptitude: BrGlamorousLabelAptitude;
		text: self
]
