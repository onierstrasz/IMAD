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
