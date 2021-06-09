Extension { #name : #String }

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
