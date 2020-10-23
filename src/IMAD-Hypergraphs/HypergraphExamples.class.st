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
	| graph |
	graph := HyperGraph new.
	self assert: graph root isRoot.
	self assert: graph size equals: 1.
	^ graph
]
