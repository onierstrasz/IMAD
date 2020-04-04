"
I query whether the target of a relation is a given card. 
"
Class {
	#name : #CRTargetFilter,
	#superclass : #CRFilter,
	#instVars : [
		'target'
	],
	#category : #'IMAD-Cards-Filters'
}

{ #category : #accessing }
CRTargetFilter >> matches: aCardRel [
	^ aCardRel hasTarget: target
]

{ #category : #accessing }
CRTargetFilter >> target: aCard [
	target := aCard
]
