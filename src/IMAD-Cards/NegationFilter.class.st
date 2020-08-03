Class {
	#name : #NegationFilter,
	#superclass : #AbstractFilter,
	#instVars : [
		'filter'
	],
	#category : #'IMAD-Cards-Filters'
}

{ #category : #accessing }
NegationFilter >> filter: aFilter [
	filter := aFilter
]

{ #category : #accessing }
NegationFilter >> matches: aCardModelEntity [
	^ (filter matches: aCardModelEntity) not
]

{ #category : #accessing }
NegationFilter >> positiveTags [
	^ Set new
]

{ #category : #accessing }
NegationFilter >> tags [
	^ filter tags
]
