"
I evaluate the intersection of two queries.
"
Class {
	#name : #CRIntersectionFilter,
	#superclass : #CRBinaryFilter,
	#category : #'IMAD-Cards-Filters'
}

{ #category : #accessing }
CRIntersectionFilter >> matches: aCardRel [
	^ (left matches: aCardRel) &
		((right matches: aCardRel))
]
