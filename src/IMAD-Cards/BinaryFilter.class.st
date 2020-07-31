"
I am an abstract parent of binary union and intersection filters.
"
Class {
	#name : #BinaryFilter,
	#superclass : #AbstractFilter,
	#instVars : [
		'left',
		'right'
	],
	#category : #'IMAD-Cards-Filters'
}

{ #category : #accessing }
BinaryFilter >> left: aFilter [
	left := aFilter
]

{ #category : #accessing }
BinaryFilter >> positiveTags [
	^ left positiveTags
		addAll: right positiveTags;
		yourself
]

{ #category : #accessing }
BinaryFilter >> right: aFilter [
	right := aFilter
]
