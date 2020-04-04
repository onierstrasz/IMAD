"
I am an abstract parent of binary union and intersection filters.
"
Class {
	#name : #CRBinaryFilter,
	#superclass : #CRFilter,
	#instVars : [
		'left',
		'right'
	],
	#category : #'IMAD-Cards-Filters'
}

{ #category : #accessing }
CRBinaryFilter >> left: aCardRelFilter [
	left := aCardRelFilter
]

{ #category : #accessing }
CRBinaryFilter >> right: aCardRelFilter [
	right := aCardRelFilter
]
