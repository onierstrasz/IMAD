Class {
	#name : #TrueFilter,
	#superclass : #AbstractFilter,
	#category : #'IMAD-Cards-Filters'
}

{ #category : #accessing }
TrueFilter >> matches: aCardModelEntity [
	^ true
]
