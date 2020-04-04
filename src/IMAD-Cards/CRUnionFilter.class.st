"
I evaluate the union of two queries.
"
Class {
	#name : #CRUnionFilter,
	#superclass : #CRBinaryFilter,
	#category : #'IMAD-Cards-Filters'
}

{ #category : #accessing }
CRUnionFilter >> matches: aCardRel [
	^ (left matches: aCardRel) |
		((right matches: aCardRel))
]
