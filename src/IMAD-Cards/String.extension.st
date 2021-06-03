Extension { #name : #String }

{ #category : #'*IMAD-Cards' }
String >> asBrEditableLabel [
	^ BrEditableLabel new
		aptitude:
			(BrGlamorousEditableLabelAptitude new
				defaultBackground: Color veryVeryLightGray);
		text: self
]

{ #category : #'*IMAD-Cards' }
String >> asBrLabel [
	^ BrLabel new
		aptitude: BrGlamorousLabelAptitude;
		text: self
]

{ #category : #'*IMAD-Cards' }
String >> asRelNameFilter [
	^ CRRelNameFilter new kind: self
]

{ #category : #'*IMAD-Cards' }
String >> asTagFilter [
	^ CardTagFilter  new
		tag: self;
		yourself
		
]
