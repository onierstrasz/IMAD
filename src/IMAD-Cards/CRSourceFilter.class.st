"
I query whether the source of a relation is a given card. 
"
Class {
	#name : #CRSourceFilter,
	#superclass : #CRFilter,
	#instVars : [
		'source'
	],
	#category : #'IMAD-Cards-Filters'
}

{ #category : #accessing }
CRSourceFilter >> matches: aCardRel [
	^ aCardRel hasSource: source
]

{ #category : #accessing }
CRSourceFilter >> source: aCard [
	source := aCard
]
