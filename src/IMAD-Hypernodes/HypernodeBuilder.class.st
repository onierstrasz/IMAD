"
A am used to build a complete Hypernode graph as a clone of an existing one.
I keep track of the mapping between the old and the new nodes in the graph, and recreate the entire structure.

I am used in particular to save scripts as methods to store and restore hypernode graphs.
See ${method:name=Hypernode>>#storeOn:}$.

The strategy is as follows:

- Create the builder
- Create each node (with it properties), keeping track of the mapping of old ids to new ones
- Populate each node with its subnodes (which now exist) and its edges
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
HypernodeBuilder >> addNode: aHypernode forId: id [
	self assert: (idMap includesKey: id) not.
	idMap at: id put: aHypernode
]

{ #category : #accessing }
HypernodeBuilder >> forNode: aHypernode addSubNodes: nodeIds [
	
]

{ #category : #accessing }
HypernodeBuilder >> initialize [
	super initialize.
	idMap := Dictionary new
]

{ #category : #accessing }
HypernodeBuilder >> returnNodeForId: id [
	^ idMap at: id
]
