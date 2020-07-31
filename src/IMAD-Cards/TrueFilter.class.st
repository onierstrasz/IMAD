Class {
	#name : #TrueFilter,
	#superclass : #AbstractFilter,
	#category : #'IMAD-Cards-Filters'
}

{ #category : #accessing }
TrueFilter >> matches: aCardModelEntity [
	^ true
]

{ #category : #accessing }
TrueFilter >> positiveTags [
	^ Set new
]
