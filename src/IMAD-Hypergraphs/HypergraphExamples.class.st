"
I provide a bunch test examples for Hypergraphs.
"
Class {
	#name : #HypergraphExamples,
	#superclass : #Object,
	#category : #'IMAD-Hypergraphs'
}

{ #category : #accessing }
HypergraphExamples >> emptyHypergraph [
	<gtExample>
	| root |
	root := HyperNode root.
	self assert: root isRoot.
	self assert: root size equals: 1.
	^ root
]
