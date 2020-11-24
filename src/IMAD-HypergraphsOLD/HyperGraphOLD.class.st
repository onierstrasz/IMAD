Class {
	#name : #HyperGraphOLD,
	#superclass : #Object,
	#instVars : [
		'root'
	],
	#category : #'IMAD-HypergraphsOLD'
}

{ #category : #accessing }
HyperGraphOLD >> initialize [
	super initialize.
	root := HyperNodeOLD root
]

{ #category : #accessing }
HyperGraphOLD >> root [
	^ root
]

{ #category : #accessing }
HyperGraphOLD >> size [
	^ self root size
]
