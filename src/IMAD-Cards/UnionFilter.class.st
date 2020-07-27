"
I evaluate the union of two queries.
"
Class {
	#name : #UnionFilter,
	#superclass : #BinaryFilter,
	#category : #'IMAD-Cards-Filters'
}

{ #category : #accessing }
UnionFilter >> matches: aCardModelEntity [
	^ (left matches: aCardModelEntity) |
		((right matches: aCardModelEntity))
]
