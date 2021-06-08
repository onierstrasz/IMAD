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

{ #category : #accessing }
UnionFilter >> tagDictionaries [
	"The left filter is a disjunction of conjunctions, and the right is a single conjunctions. We add the right dictionary to the list."

	| rightDict |
	rightDict := right tagDictionaries.
	self
		assert: rightDict size = 1
		description: 'Tag filters should be normalized to disjunctive normal form'.
	^ left tagDictionaries
		addAll: rightDict;
		yourself
]
