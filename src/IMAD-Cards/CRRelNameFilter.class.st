"
I query whether a relation has a given name.
"
Class {
	#name : #CRRelNameFilter,
	#superclass : #CRFilter,
	#instVars : [
		'name'
	],
	#category : #'IMAD-Cards-Filters'
}

{ #category : #accessing }
CRRelNameFilter >> matches: aCardRel [
	^ aCardRel isNamed: name
]

{ #category : #accessing }
CRRelNameFilter >> name: aSymbol [
	name := aSymbol
]
