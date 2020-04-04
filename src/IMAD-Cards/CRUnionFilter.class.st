"
I evaluate the union of two queries.
"
Class {
	#name : #CRUnionFilter,
	#superclass : #CRFilter,
	#instVars : [
		'left',
		'right'
	],
	#category : #'IMAD-Cards-Filters'
}

{ #category : #accessing }
CRUnionFilter >> left: aCardRelFilter [
	left := aCardRelFilter
]

{ #category : #accessing }
CRUnionFilter >> matches: aCardRel [
	^ (left matches: aCardRel) |
		((right matches: aCardRel))
]

{ #category : #accessing }
CRUnionFilter >> right: aCardRelFilter [
	right := aCardRelFilter
]
