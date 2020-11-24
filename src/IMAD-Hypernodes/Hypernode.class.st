"
A Hypernode is a node in a nested graph, where each node also contains a graph.
A graph G consists of (N,E), a set N of nodes and a set E of edges.
Every node also ""contains"" a (possibly empty) graph.

The design is based on the Hypernode model of *Poulovassilis and Levene>http://scg.unibe.ch/scgbib?query=Poul94a&display=abstract*.


"
Class {
	#name : #Hypernode,
	#superclass : #Object,
	#instVars : [
		'nodes',
		'edges'
	],
	#category : #'IMAD-Hypernodes'
}

{ #category : #accessing }
Hypernode >> initialize [
	super initialize.
	nodes := OrderedCollection new.
	edges := OrderedCollection new
]

{ #category : #accessing }
Hypernode >> nodes [ 
	^ nodes
]
