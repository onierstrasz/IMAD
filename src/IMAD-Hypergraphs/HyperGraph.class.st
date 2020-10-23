Class {
	#name : #HyperGraph,
	#superclass : #Object,
	#instVars : [
		'root'
	],
	#category : #'IMAD-Hypergraphs'
}

{ #category : #accessing }
HyperGraph >> initialize [
	super initialize.
	root := HyperNode root
]

{ #category : #accessing }
HyperGraph >> root [
	^ root
]

{ #category : #accessing }
HyperGraph >> size [
	^ self root size
]
