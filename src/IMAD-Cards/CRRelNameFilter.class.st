"
I query whether a relation has a given name.
"
Class {
	#name : #CRRelNameFilter,
	#superclass : #CRFilter,
	#instVars : [
		'kind'
	],
	#category : #'IMAD-Cards-Filters'
}

{ #category : #accessing }
CRRelNameFilter >> kind: aSymbol [
	kind := aSymbol
]

{ #category : #accessing }
CRRelNameFilter >> matches: aCardRel [
	^ aCardRel isOfKind: kind
]
