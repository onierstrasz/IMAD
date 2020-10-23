Class {
	#name : #HyperNode,
	#superclass : #Object,
	#instVars : [
		'parent',
		'children'
	],
	#category : #'IMAD-Hypergraphs'
}

{ #category : #accessing }
HyperNode class >> root [
	"Create an empty root node of a Hypergraph"

	^ self new
]

{ #category : #accessing }
HyperNode >> children [
	^ children
]

{ #category : #accessing }
HyperNode >> initialize [
	super initialize.
	parent := nil.
	children := OrderedCollection new
]

{ #category : #accessing }
HyperNode >> isRoot [
	^ self parent = nil
]

{ #category : #accessing }
HyperNode >> parent [
	^ parent
]

{ #category : #accessing }
HyperNode >> size [
	^ self children inject: 1 into: [ :sum :each | sum + each size ] 
]
