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

{ #category : #accessing }
IntersectionFilter >> tagDictionaries [
	"Both left and right filters should be conjunctions. We merge the dictionaries."

	| leftDict rightDict |
	leftDict := left tagDictionaries.
	self
		assert: leftDict size = 1
		description: 'Tag filters should be normalized to disjunctive normal form'.
	rightDict := right tagDictionaries.
	self
		assert: rightDict size = 1
		description: 'Tag filters should be normalized to disjunctive normal form'.
	^ OrderedCollection
		with:
			(left tagDictionaries first
				addAll: rightDict first;
				yourself)
]
