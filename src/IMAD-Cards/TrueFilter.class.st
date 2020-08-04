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

{ #category : #accessing }
TrueFilter >> tagDictionaries [
	^ OrderedCollection with: Dictionary new
]

{ #category : #accessing }
TrueFilter >> tags [
	^ Set new
]
