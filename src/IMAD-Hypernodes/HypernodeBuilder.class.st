"
A am used to build a complete Hypernode graph as a clone of an existing one.
I keep track of the mapping between the old and the new nodes in the graph, and recreate the entire structure.

I am used in particular to save scripts as methods to store and restore hypernode graphs.
See ${method:name=Hypernode>>#storeOn:}$.

The strategy is as follows:

- Create the builder
- Create each node (with its properties), using ${method:name=HypernodeBuilder>>#addNode:for:}$, keeping track of the mapping of old ids to new ones
- Populate each node with its subnodes (which now exist), using ${method:name=HypernodeBuilder>>#addSubNodes:for:}$, and its edges, using ${method:name=HypernodeBuilder>>#addEdgeFrom:to:for:withProperties:}$
- Return the root node

"
Class {
	#name : #HypernodeBuilder,
	#superclass : #Object,
	#instVars : [
		'idMap'
	],
	#category : #'IMAD-Hypernodes-IMAD-Hypernodes'
}

{ #category : #accessing }
HypernodeBuilder >> addEdgeFrom: fromId to: toId for: parentId withProperties: properties [
	| edge |
	edge := Hyperlink
		from: (self nodeForId: fromId)
		to: (self nodeForId: toId).
	edge properties: properties.
	(self nodeForId: parentId) addLink: edge.
	^ edge
]

{ #category : #accessing }
HypernodeBuilder >> addNode: aHypernode for: id [
	self assert: (idMap includesKey: id) not.
	idMap at: id put: aHypernode
]

{ #category : #accessing }
HypernodeBuilder >> addSubNodes: nodeIds for: id [
	"Change
		HypernodeBuilder>>#addSubNodes:for:
	to multiple calls of
		HypernodeBuilder>>#addSubNode:withContextProperties:for:
	"

	<todo: 'Fix to handle context objects'>
	nodeIds
		do: [ :eachId | (self nodeForId: id) addNode: (self nodeForId: eachId) ]
]

{ #category : #accessing }
HypernodeBuilder >> initialize [
	super initialize.
	idMap := Dictionary new
]

{ #category : #accessing }
HypernodeBuilder >> nodeForId: id [
	^ idMap at: id
]
