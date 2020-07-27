"
I evaluate the intersection of two queries.
"
Class {
	#name : #IntersectionFilter,
	#superclass : #BinaryFilter,
	#category : #'IMAD-Cards-Filters'
}

{ #category : #accessing }
IntersectionFilter >> matches: aCardModelEntity [
	^ (left matches: aCardModelEntity) &
		((right matches: aCardModelEntity))
]
