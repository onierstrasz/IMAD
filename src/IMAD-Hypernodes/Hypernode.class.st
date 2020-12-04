"
A Hypernode is a node in a nested graph. Each Hypernode contains (possibly empty sets) of Hypernodes and Hyperlinks. A Hyperlink represents an edge from one Hypernode to another. 

There are no a priori constraints on the nesting structure of a Hypernode graph. In particular, a Hyperlink may link to a Hypernode that is not properly nested within the same parent Hypernode.

The design is based on the Hypernode model of *Levene and Poulovassilis>http://scg.unibe.ch/scgbib?query=Leve90a&display=abstract*. In this version of the Hypernode model, links may span Hypernodes. In contrast, their *later model>http://scg.unibe.ch/scgbib?query=Poul94a&display=abstract* imposes a strict nesting hierarchy.

Note that we avoid the terms ""Hyperedge"" and ""Hypergraph"", as these have different specific meanings: a *hypergraph>https://en.wikipedia.org/wiki/Hypergraph* is a generalization of a graph in which hyperedges may connect any number of nodes. This concept is more similar to that of a hypernode, which may contain a subgraph of nodes.

There are various constraints that might make sense to impose on Hypernode graphs, for example that the the source node of each Hyperlink be contained within the same parent Hypernode as the link itself, but we do not enforce such constraints apriori, as there might well be applications that do not require such constraints. For example, there might be applications in which incoming rather than outgoing links are considered to be part of the graph.

Instead each application is free to impose specific constraints, such as a strict nesting structure, or the requirement that each node be contained in at most one parent graph.
"
Class {
	#name : #Hypernode,
	#superclass : #HypergraphEntity,
	#instVars : [
		'nodes',
		'edges'
	],
	#category : #'IMAD-Hypernodes'
}

{ #category : #accessing }
Hypernode >> -> aNode [
	^ Hyperlink from: self to: aNode
]

{ #category : #accessing }
Hypernode >> = anObject [
	"NB: We do not search for an isomorphic, but simply test if the given order of nodes and edges in the two graphs is an isomorphism."

	^ super = anObject and: [ self isomorphicTo: anObject ]
]

{ #category : #accessing }
Hypernode >> addLink: aLink [
	edges add: aLink
]

{ #category : #accessing }
Hypernode >> addNode [
	| node |
	node := Hypernode new.
	self addNode: node.
	^ node 
]

{ #category : #accessing }
Hypernode >> addNode: aNode [
	nodes add: aNode 
]

{ #category : #accessing }
Hypernode >> asElement [
	^ HypernodeEditor for: self
]

{ #category : #accessing }
Hypernode >> edges [
	^ edges
]

{ #category : #accessing }
Hypernode >> gtLiveFor: aView [
	<gtView>
	^ aView explicit
		title: 'Live';
		priority: 5;
		stencil: [ self asElement ]
]

{ #category : #accessing }
Hypernode >> initialize [
	super initialize.
	nodes := OrderedCollection new.
	edges := OrderedCollection new
]

{ #category : #accessing }
Hypernode >> isDAG [
	<todo: 'Need to dearch for absence of directed cycles. Requires a DFS.'>
	^ self notYetImplemented
]

{ #category : #accessing }
Hypernode >> isLeaf [
	^ self nodes isEmpty and: [ self edges isEmpty ]
]

{ #category : #accessing }
Hypernode >> isTree [
	<todo: 'Need to search for absence of any kind of cycles, directed or not.'>
	^ self notYetImplemented
]

{ #category : #accessing }
Hypernode >> isomorphicTo: anotherHypernode [
	"Note that we do not search for an isomorphism, but simply check if the contained nodes and edges in the same, given order establish an isomrphism."

	| myNodes otherNodes myEdges otherEdges myIndices otherIndices |
	myNodes := self reachableNodes.
	otherNodes := anotherHypernode reachableNodes.
	myEdges := self reachableEdges.
	otherEdges := anotherHypernode reachableEdges.

	"The graphs have the same numbers of nodes and edges"
	myNodes size = otherNodes size
		ifFalse: [ ^ false ].
	myEdges size = otherEdges size
		ifFalse: [ ^ false ].

	"The nodes and edges have identical properties."
	myNodes
		withIndexDo: [ :node :i | 
			node properties = (otherNodes at: i) properties
				ifFalse: [ ^ false ] ].
	myEdges
		withIndexDo: [ :edge :i | 
			edge properties = (otherEdges at: i) properties
				ifFalse: [ ^ false ] ].

	"To check for isomorphism, we identify nodes in the two graphs by their indices in the lists of reachable nodes."
	myIndices := IdentityDictionary
		newFromKeys: myNodes
		andValues: (1 to: myNodes size).
	otherIndices := IdentityDictionary
		newFromKeys: otherNodes
		andValues: (1 to: otherNodes size).
	
	"All nodes contain the same subnodes, i.e., with the same indices in the list of all reachable nodes."
	myNodes
		withIndexDo: [ :node :i | 
			| mySubnodes otherSubnodes |
			mySubnodes := node nodes collect: [ :each | myIndices at: each ].
			otherSubnodes := (otherNodes at: i) nodes
				collect: [ :each | otherIndices at: each ].
			mySubnodes = otherSubnodes
				ifFalse: [ ^ false ] ].

	"All nodes contain the same edges, mapping between corresponding nodes."
	myNodes
		withIndexDo: [ :node :i | 
			| mySubedges otherSubedges |
			mySubedges := node edges.
			otherSubedges := (otherNodes at: i) edges.
			mySubedges size = otherSubedges size
				ifFalse: [ ^ false ].
			mySubedges
				withIndexDo: [ :edge :j | 
					(myIndices at: edge source)
						= (otherIndices at: (otherSubedges at: j) source)
						ifFalse: [ ^ false ].
					(myIndices at: edge target)
						= (otherIndices at: (otherSubedges at: j) target)
						ifFalse: [ ^ false ] ] ].
	^ true
]

{ #category : #accessing }
Hypernode >> nodes [ 
	^ nodes
]

{ #category : #accessing }
Hypernode >> reachableEdges [
	^ self reachableNodes flatCollect: #edges
]

{ #category : #accessing }
Hypernode >> reachableNodes [
	"NB: We use an IdentitySet to check for inclusion so that we test for identity, not equality."

	<todo: 'more tests'>
	| reachable toCheck reachedSet |
	reachable := OrderedCollection with: self.
	reachedSet := IdentitySet with: self.
	toCheck := self nodes copy.
	toCheck addAll: (self edges flatCollect: #nodes).
	[ toCheck notEmpty ]
		whileTrue: [ | nextNode |
			nextNode := toCheck removeFirst.
			self assert: nextNode isNotNil.
			(reachedSet includes: nextNode)
				ifFalse: [ reachedSet add: nextNode.
					reachable addLast: nextNode.
					toCheck addAll: nextNode nodes.
					toCheck addAll: (nextNode edges flatCollect: #nodes) ] ].
	^ reachable
]

{ #category : #accessing }
Hypernode >> storeOn: aStream [
	"We store the HypernodeGraph as a code snippet that asks a HypernodeBuilder to recreate the graph. Each Hypernode is assigned an id, which is used by the builder to uniquely identify the nodes."

	| allNodes nodeIdMap |
	allNodes := self reachableNodes asOrderedCollection.

	"Note the id of each node."
	nodeIdMap := IdentityDictionary new.
	allNodes doWithIndex: [ :each :id | nodeIdMap at: each put: id ].

	"Use the builder to each old id to the new node."
	aStream
		nextPutAll: 'HypernodeBuilder new';
		cr.

	"Recreate each reachable node with its properties."
	allNodes
		doWithIndex: [ :each :id | 
			"Create the subgraphs for each node."
			aStream
				nextPutAll: '  addNode: (Hypernode new ';
				cr;
				nextPutAll: '  '.
			each storePropertiesOn: aStream.
			aStream
				nextPutAll: '    yourself)';
				nextPutAll: ' forId: ';
				nextPutAll: id asString;
				nextPutAll: ';';
				cr ].

	"Add the subgraph nodes to each node."
	allNodes
		doWithIndex: [ :each :id | 
			each nodes isNotEmpty
				ifTrue: [ aStream
						nextPutAll: '  addSubNodes: { ';
						nextPutAll:
							(' . '
								join: (each nodes collect: [ :subnode | nodeIdMap at: subnode ]));
						nextPutAll: ' }';
						nextPutAll: ' forId: ';
						nextPutAll: id asString;
						nextPutAll: ';';
						cr ] ].

	"Add the subgraph edges to each node."
	"HB addEdgeFromId:toId:forId:withProperties:"
	allNodes
		doWithIndex: [ :each :id | 
			each edges
				do: [ :edge | 
					aStream
						nextPutAll: '  addEdgeFromId: ';
						nextPutAll: (nodeIdMap at: edge source) asString;
						nextPutAll: ' toId: ';
						nextPutAll: (nodeIdMap at: edge target) asString;
						nextPutAll: ' forId: ';
						nextPutAll: id asString;
						cr;
						nextPutAll: '  withProperties: '.
					edge properties storeOn: aStream.
					aStream
						nextPutAll: ';';
						cr ] ].

	"Return the root node"
	aStream
		nextPutAll: '  nodeForId: ';
		nextPutAll: (nodeIdMap at: self) asString;
		nextPutAll: '.';
		cr
]
