"
I provide a context for a ${class:name=Hypernode}$ instance as a subnode within a Hypernode graph.

Where as a Hypernode may be a subnode of many other Hypernodes, in each case it is so within a unique context. A HypernodeContext therefore knows its parent node as well as the subnode it provides the context for.

A HypernodeContext is used to keep track of contextual information related to the role of a node within a subgraph, in particular it keeps track of the last position in the display.

Note that a HypernodeContext seems to overlap in responsibility with a ${class:name=HypernodeElement}$, since the latter also knows the node and its position, but the differences are that (i) a context is a model entity, not a view, and (ii) there is only one context entity per subnode, while there may be many elements since there can be multiple views open on the same node or graph.

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
	#category : #'IMAD-Hypernodes-IMAD-Hypernodes'
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
HypernodeContext >> hasPosition [
	^ self position isNotNil
]

{ #category : #accessing }
HypernodeContext >> initializeNode: aSubnode parent: aHypernode [
	node := aSubnode.
	parent := aHypernode
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
	<todo: 'assign a random position if nil?'>
	| position |
	position := self get: #position.
	self assert: position isNotNil.
	^ position
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
HypernodeContext >> reposition: aPosition [
	"NB: only announce an update on repositioning"

	self position: aPosition.
	self parent announcer announce: (UpdateNodeContext new context: self)
]
