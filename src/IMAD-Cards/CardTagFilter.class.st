Class {
	#name : #CardTagFilter,
	#superclass : #AbstractFilter,
	#instVars : [
		'tag'
	],
	#category : #'IMAD-Cards-Filters'
}

{ #category : #accessing }
CardTagFilter >> matches: aCard [
	^ aCard hasTagNamed: self tag 
]

{ #category : #accessing }
CardTagFilter >> tag [
	^ tag
]

{ #category : #accessing }
CardTagFilter >> tag: aString [
	tag := aString 
]
