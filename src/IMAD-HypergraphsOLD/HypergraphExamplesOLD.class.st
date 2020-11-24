"
I provide a bunch test examples for Hypergraphs.
"
Class {
	#name : #HypergraphExamplesOLD,
	#superclass : #Object,
	#category : #'IMAD-HypergraphsOLD'
}

{ #category : #accessing }
HypergraphExamplesOLD >> emptyHypergraph [
	<gtExample>
	| graph |
	graph := HyperGraphOLD new.
	self assert: graph root isRoot.
	self assert: graph size equals: 1.
	^ graph
]

{ #category : #accessing }
HypergraphExamplesOLD >> flatGraph [
	"a Graph with three nodes"

	<gtExample>
	| graph |
	graph := self emptyHypergraph.
	graph root addNode.
	graph root addNode.
	graph root addNode.
	self assert: graph root size equals: 4.
	self assert: graph root leaves size equals: 3.
	self assert: graph root subgraphs size equals: 0.
	self assert: (graph root leaves collect: #depth) max equals: 1.
	^ graph
]

{ #category : #accessing }
HypergraphExamplesOLD >> threeLevelGraph [
	<gtExample>
	| graph abc a b c ba bb ca cb caa |
	graph := self flatGraph.
	abc := graph root children.
	a := abc first.
	b := abc second.
	ba := b addNode.
	bb := b addNode.
	c := abc third.
	ca := c addNode.
	cb := c addNode.
	caa := ca addNode.
	self assert: graph root size equals: 9.
	self assert: graph root leaves size equals: 1.
	self assert: graph root subgraphs size equals: 2.
	self assert: graph root allLeaves size equals: 5.
	self assert: graph root allSubgraphs size equals: 3.
	self assert: graph root withAllSubgraphs size equals: 4.
	self assert: (graph root allLeaves collect: #depth) max equals: 3.
	^ graph
]
