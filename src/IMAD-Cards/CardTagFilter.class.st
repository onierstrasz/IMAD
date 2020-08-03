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
CardTagFilter >> positiveTags [
	^ Set with: tag
]

{ #category : #accessing }
CardTagFilter >> tag [
	^ tag
]

{ #category : #accessing }
CardTagFilter >> tag: aString [
	tag := aString 
]

{ #category : #accessing }
CardTagFilter >> tags [
	^ Set new
		add: tag;
		yourself
]
