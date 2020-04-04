"
I evaluate the intersection of two queries.
"
Class {
	#name : #CRIntersectionFilter,
	#superclass : #CRUnionFilter,
	#category : #'IMAD-Cards-Filters'
}

{ #category : #accessing }
CRIntersectionFilter >> matches: aCardRel [
	^ (left matches: aCardRel) &
		((right matches: aCardRel))
]
