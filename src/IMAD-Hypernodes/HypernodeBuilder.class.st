"
A am used to build a complete Hypernode graph as a clone of an existing one.
I keep track of the mapping between the old and the new nodes in the graph, and recreate the entire structure.

I am used in particular to save scripts as methods to store and restore hypernode graphs.
See {{gtMethod:name=Hypernode>>#storeOn:}}.

The strategy is as follows:

- Create the builder
- Create each node (with its properties), using {{gtMethod:name=HypernodeBuilder>>#addNode:for:}}, keeping track of the mapping of old ids to new ones
- Populate each node with its subnodes (which now exist), using {{gtMethod:name=HypernodeBuilder>>#addSubNode:for:withContextProperties:}}, and its edges, using {{gtMethod:name=HypernodeBuilder>>#addEdgeFrom:to:for:withProperties:}}
- Return the root node

"
Class {
	#name : #HypernodeBuilder,
	#superclass : #Object,
	#instVars : [
		'idMap'
	],
	#category : #'IMAD-Hypernodes-Model'
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
HypernodeBuilder >> addSubNode: nodeId for: id withContextProperties: properties [
	| parent subnode context |
	parent := self nodeForId: id.
	subnode := self nodeForId: nodeId.
	context := HypernodeContext forNode: subnode withParent: parent.
	context properties: properties.
	parent addContext: context
]

{ #category : #accessing }
HypernodeBuilder >> addSubNodes: nodeIds for: id [
	self
		deprecated: 'Use addSubNode: nodeId for: id withContextProperties:'.
	nodeIds
		do: [ :eachId | (self nodeForId: id) addContextForNode: (self nodeForId: eachId) ]
]

{ #category : #accessing }
HypernodeBuilder >> initialize [
	super initialize.
	idMap := KeyedTree new
]

{ #category : #accessing }
HypernodeBuilder >> nodeForId: id [
	^ idMap at: id
]

{ #category : #accessing }
HypernodeBuilder >> setRootFor: id to: theRootId [
	(self nodeForId: id) root: (self nodeForId: theRootId)
]
