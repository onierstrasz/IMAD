"
I provide a context for a {{gtClass:name=Hypernode}} instance as a subnode within a Hypernode graph.

Whereas a Hypernode may be a subnode of many other Hypernodes, in each case it is so within a unique context. A HypernodeContext therefore knows its parent node as well as the subnode it provides the context for.

A HypernodeContext is used to keep track of contextual information related to the role of a node within a subgraph, in particular it keeps track of the last position in the display.

Note that a HypernodeContext seems to overlap in responsibility with a {{gtClass:name=HypernodeElement}}, since the latter also knows the node and its position, but the differences are that (i) a context is a model entity, not a view, and (ii) there is only one context entity per subnode, while there may be many elements since there can be multiple views open on the same node or graph.

My node is the Hypernode that I provide a context for. My parent is the node that contains my node in its subgraph.
NB: a context knows its parent node, but a node does not know its parent nodes (or contexts).

"
Class {
	#name : #HypernodeContext,
	#superclass : #HNPropertyHolder,
	#instVars : [
		'parent',
		'node'
	],
	#category : #'IMAD-Hypernodes-Model'
}

{ #category : #accessing }
HypernodeContext class >> forNode: aSubnode withParent: aHypernode [
	^ self new
		initializeNode: aSubnode parent: aHypernode;
		yourself
]

{ #category : #accessing }
HypernodeContext >> -> aContext [
	"convenience method"

	^ self node -> aContext node
]

{ #category : #accessing }
HypernodeContext >> delete [
	self parent deleteContext: self
]

{ #category : #accessing }
HypernodeContext >> deleteLinks [
	self parent deleteLinksForContext: self
]

{ #category : #accessing }
HypernodeContext >> description [
	^ self node description
]

{ #category : #accessing }
HypernodeContext >> description: aString [
	^ self node description: aString
]

{ #category : #accessing }
HypernodeContext >> graphStyle [
	^ parent graphStyle
]

{ #category : #accessing }
HypernodeContext >> initializeNode: aSubnode parent: aHypernode [
	node := aSubnode.
	parent := aHypernode
]

{ #category : #accessing }
HypernodeContext >> name [
	^ self node name
]

{ #category : #accessing }
HypernodeContext >> name: aString [
	^ self node name: aString
]

{ #category : #accessing }
HypernodeContext >> node [
	^ node
]

{ #category : #accessing }
HypernodeContext >> parent [
	^ parent
]

{ #category : #accessing }
HypernodeContext >> position [
	^ self get: #position ifAbsentPut: [ self randomPosition ]
]

{ #category : #accessing }
HypernodeContext >> position: aPosition [
	self set: #position to: aPosition
]

{ #category : #accessing }
HypernodeContext >> printOn: aStream [
	"Placeholder version to help in debugging"

	super printOn: aStream.
	aStream
		nextPutAll: '(child: ';
		nextPutAll: node hash asString;
		nextPutAll: '; parent: ';
		nextPutAll: parent hash asString;
		nextPutAll: ')'
]

{ #category : #accessing }
HypernodeContext >> randomPosition [
	"Only really used to inspect test examples without explicit positions"

	^ (1 to: 100) atRandom @ (1 to: 100) atRandom
]

{ #category : #accessing }
HypernodeContext >> reposition: aPosition [
	"NB: only announce an update on repositioning"

	self position: aPosition.
	self parent announcer announce: (UpdateNodeContext new context: self)
]
