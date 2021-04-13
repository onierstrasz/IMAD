Extension { #name : #String }

{ #category : #'*IMAD-Cards' }
String >> asBrEditableLabel [
	^ BrEditableLabel new
		look:
			(BrGlamorousEditableLabelAptitude new
				defaultBackground: Color veryVeryLightGray);
		text: self
]

{ #category : #'*IMAD-Cards' }
String >> asBrLabel [
	^ BrLabel new
		look: BrGlamorousLabelAptitude;
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
