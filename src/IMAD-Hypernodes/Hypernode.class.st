"
A Hypernode is a node in a nested graph. Each Hypernode contains (possibly empty sets) of Hypernodes and Hyperlinks. A Hyperlink represents an edge from one Hypernode to another. 

There are no a priori constraints on the nesting structure of a Hypernode graph. In particular, a Hyperlink may link to a Hypernode that is not properly nested within the same parent Hypernode.

The design is based on the Hypernode model of *Levene and Poulovassilis>http://scg.unibe.ch/scgbib?query=Leve90a&display=abstract*. In this version of the Hypernode model, links may span Hypernodes. In contrast, their *later model>http://scg.unibe.ch/scgbib?query=Poul94a&display=abstract* imposes a strict nesting hierarchy.

Note that we avoid the terms ""Hyperedge"" and ""Hypergraph"", as these have different specific meanings: a *hypergraph>https://en.wikipedia.org/wiki/Hypergraph* is a generalization of a graph in which hyperedges may connect any number of nodes. This concept is more similar to that of a hypernode, which may contain a subgraph of nodes.

There are various constraints that might make sense to impose on Hypernode graphs, for example that the the source node of each Hyperlink be contained within the same parent Hypernode as the link itself, but we do not enforce such constraints apriori, as there might well be applications that do not require such constraints. For example, there might be applications in which incoming rather than outgoing links are considered to be part of the graph.

Instead each application is free to impose specific constraints, such as a strict nesting structure, or the requirement that each node be contained in at most one parent graph.

I am a model entity. My views are provided by ${class:name=HypernodeEditor}$ (live view), ${class:name=HypernodeGraphElement}$ (subgraph view within the editor view), and ${class:name=HypernodeElement}$ (as a node within a graph).

A Hypernode graph should have a clearly identified root node from which all other nodes can be reached. This is needed to save the graph of reachable nodes. For this reason a new Hypernode should either be instantiated by sending ==Hypernode root== or ==Hypernode for: aNode==, where ==aNode== is an existing node with a root.

"
Class {
	#name : #Hypernode,
	#superclass : #HypergraphEntity,
	#instVars : [
		'nodeContexts',
		'links',
		'root'
	],
	#category : #'IMAD-Hypernodes'
}

{ #category : #creation }
Hypernode class >> for: aHypernode [
	^ Hypernode new
		root: aHypernode root;
		yourself
]

{ #category : #creation }
Hypernode class >> root [
	^ Hypernode new
		beRoot;
		yourself
]

{ #category : #factory }
Hypernode >> -> aNode [
	^ Hyperlink from: self to: aNode
]

{ #category : #comparing }
Hypernode >> = anObject [
	"NB: We do not search for an isomorphic, but simply test if the given order of nodes and edges in the two graphs is an isomorphism."

	^ super = anObject and: [ self isomorphicTo: anObject ]
]

{ #category : #updating }
Hypernode >> addContext: aHypernodeContext [
	self contexts add: aHypernodeContext.
	self announcer
		announce: (CreateNodeContext new context: aHypernodeContext).
	^ aHypernodeContext
]

{ #category : #updating }
Hypernode >> addContextForNode: aNode [
	^ self addContext: (HypernodeContext forNode: aNode withParent: self)
]

{ #category : #updating }
Hypernode >> addLink: aLink [
	self assert: (aLink isKindOf: Hyperlink).
	aLink parent: self.
	self links add: aLink.
	self announcer announce: (CreateLink new link: aLink)
]

{ #category : #updating }
Hypernode >> addNewNodeContext [
	"NB: returns a new HypernodeContext for the node"

	^ self addContextForNode: (Hypernode for: self)
]

{ #category : #updating }
Hypernode >> addNode: aNode WithPosition: aPosition [
	| context |
	context := HypernodeContext forNode: aNode withParent: self.
	context position: aPosition.
	self addContext: context.
	^ aNode
]

{ #category : #updating }
Hypernode >> addNodeWithPosition: aPosition [
	| node |
	node := Hypernode for: self.
	self addNode: node WithPosition: aPosition.
	^ node
]

{ #category : #accessing }
Hypernode >> allNodes [
	^ self reachableNodes asOrderedCollection
]

{ #category : #'gt-extension' }
Hypernode >> asElement [
	^ HypernodeEditor for: self
]

{ #category : #updating }
Hypernode >> beRoot [
	self root: self
]

{ #category : #updating }
Hypernode >> beRootForAllNodes [
	"Useful for tests, where we build subgraphs, and want them to all have the same global root."

	self allNodes do: [ :node | node root: self ]
]

{ #category : #accessing }
Hypernode >> contexts [
	"returns the collection of HypernodeContexts holding the subnodes of my subgraph"

	^ nodeContexts
]

{ #category : #storing }
Hypernode >> defaultStorageClassName [
	^ 'HypernodeRepository'
]

{ #category : #storing }
Hypernode >> defaultStorageMethodName [
	^ 'sampleHypernodeGraph'
]

{ #category : #updating }
Hypernode >> deleteContext: aHypernodeContext [
	aHypernodeContext deleteLinks.
	self contexts remove: aHypernodeContext ifAbsent: [  ].
	self announcer
		announce: (DeleteNodeContext new context: aHypernodeContext)
]

{ #category : #updating }
Hypernode >> deleteLink: aLink [
	self links remove: aLink ifAbsent: [  ].
	self announcer announce: (DeleteLink new link: aLink)
]

{ #category : #updating }
Hypernode >> deleteLinksForContext: aContext [
	(self links select: [ :l | l source == aContext node ])
		do: [ :l | self deleteLink: l ].
	(self links select: [ :l | l target == aContext node ])
		do: [ :l | self deleteLink: l ]
]

{ #category : #storing }
Hypernode >> ensureDefaultStorageClassMethod [
	self storageClassName isNil
		ifTrue: [ self storageClassName: self defaultStorageClassName ].
		
	self storageMethodName isNil
		ifTrue: [ self storageMethodName: self defaultStorageMethodName ]
]

{ #category : #storing }
Hypernode >> generateStorageMethodString [
	| stream |
	self assertValidStorageMethod.
	self assertGeneratedValueEqualsSelf.
	stream := WriteStream on: String new.
	stream
		nextPutAll: self storageMethodName;
		nextPutAll: ' <storedHypernode> <gtExample> ^ '.
	self storeOn: stream.
	^ OpalCompiler new format: stream contents
]

{ #category : #'gt-extension' }
Hypernode >> gtLiveFor: aView [
	<gtView>
	^ aView explicit
		title: 'Live';
		priority: 5;
		stencil: [ self asElement ]
]

{ #category : #querying }
Hypernode >> hasContext: aHypernodeContext [
	^ self contexts includes: aHypernodeContext
]

{ #category : #querying }
Hypernode >> hasLink: aLink [
	self assert: (aLink isKindOf: Hyperlink).
	"^ (self links select: [ :l | l = aLink ]) size = 1"
	^ self links includes: aLink
]

{ #category : #querying }
Hypernode >> hasNode: aHypernode [
	^ self nodes includes: aHypernode
]

{ #category : #comparing }
Hypernode >> hash [
	<todo: 'Is there something we should do here?'>
	^ super hash
]

{ #category : #initialization }
Hypernode >> initialize [
	super initialize.
	"nodes := OrderedCollection new."
	nodeContexts := OrderedCollection new.
	links := OrderedCollection new
]

{ #category : #querying }
Hypernode >> isDAG [
	<todo: 'Need to search for absence of directed cycles. Requires a DFS.'>
	^ self notYetImplemented
]

{ #category : #querying }
Hypernode >> isGraph [
	^ self isLeaf not
]

{ #category : #querying }
Hypernode >> isLeaf [
	^ self nodes isEmpty and: [ self links isEmpty ]
]

{ #category : #querying }
Hypernode >> isRoot [
	^ self root == self
]

{ #category : #querying }
Hypernode >> isTree [
	<todo: 'Need to search for absence of any kind of cycles, directed or not.'>
	^ self notYetImplemented
]

{ #category : #querying }
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
			mySubedges := node links.
			otherSubedges := (otherNodes at: i) links.
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
Hypernode >> links [
	"Collection of all my hyperlinks"
	^ links
]

{ #category : #accessing }
Hypernode >> nodes [ 
	^ self contexts collect: #node
]

{ #category : #printing }
Hypernode >> printOn: aStream [
	<todo:
		'Expand this with more detailed information; adapt to different kinds of graphs.'>
	| subgraphs |
	self isLeaf
		ifTrue: [ aStream nextPutAll: 'a leaf Hypernode'.
			^ self ].
	subgraphs := self nodes select: #isGraph.
	subgraphs isEmpty
		ifTrue: [ aStream nextPutAll: 'a flat graph Hypernode' ]
		ifFalse: [ aStream nextPutAll: 'a hierarchical graph Hypernode' ].
	aStream
		nextPutAll: '(';
		nextPutAll: self nodes size asString;
		nextPutAll: ' node';
		nextPutAll:
			(self nodes size = 1
				ifTrue: [ '' ]
				ifFalse: [ 's' ]);
		nextPutAll: '; ';
		nextPutAll: links size asString;
		nextPutAll: ' edge';
		nextPutAll:
			(links size = 1
				ifTrue: [ '' ]
				ifFalse: [ 's' ]).
	subgraphs isEmpty
		ifFalse: [ aStream
				nextPutAll: '; ';
				nextPutAll: subgraphs size asString;
				nextPutAll: ' subgraph';
				nextPutAll:
					(subgraphs size = 1
						ifTrue: [ '' ]
						ifFalse: [ 's' ]) ].
	aStream nextPutAll: ')'
]

{ #category : #accessing }
Hypernode >> reachableEdges [
	^ self reachableNodes flatCollect: #links
]

{ #category : #accessing }
Hypernode >> reachableNodes [
	"NB: We use an IdentitySet to check for inclusion so that we test for identity, not equality."

	<todo: 'more tests'>
	| reachable toCheck reachedSet |
	reachable := OrderedCollection with: self.
	reachedSet := IdentitySet with: self.
	toCheck := self nodes copy.
	toCheck addAll: (self links flatCollect: #nodes).
	[ toCheck notEmpty ]
		whileTrue: [ | nextNode |
			nextNode := toCheck removeFirst.
			self assert: nextNode isNotNil.
			(reachedSet includes: nextNode)
				ifFalse: [ reachedSet add: nextNode.
					reachable addLast: nextNode.
					toCheck addAll: nextNode nodes.
					toCheck addAll: (nextNode links flatCollect: #nodes) ] ].
	^ reachable
]

{ #category : #accessing }
Hypernode >> root [
	self
		assert: root isNotNil
		description:
			'The root must not be nil. Be sure to instantiate all Hypernodes with "Hypernode root" or "Hypernode for: aNode".'.
	^ root
]

{ #category : #initialization }
Hypernode >> root: aHypernode [
	"Should only be set once during initialization, or exceptionally to define a subgraph as a new root."

	root := aHypernode
]

{ #category : #storing }
Hypernode >> saveState [
	| storageClass |
	storageClass := self classNamed: self storageClassName.
	self
		assert: storageClass isClass
		description: 'Storage class ' , self storageClassName , ' must exist.'.
	storageClass compile: self generateStorageMethodString
]

{ #category : #storing }
Hypernode >> storageClassMethod [
	| class method |
	class := self root get: #storageClassName ifAbsent: '(TBD)'.
	method := self root get: #storageMethodName ifAbsent: '(TBD)'.
	^ class , '>>#' , method
]

{ #category : #storing }
Hypernode >> storageClassName [
	^ self root get: #storageClassName
]

{ #category : #storing }
Hypernode >> storageClassName: aString [
	self root set: #storageClassName to: aString
]

{ #category : #storing }
Hypernode >> storageMethodDefined [
	| className methodName |
	className := self storageClassName.
	methodName := self storageMethodName.
	^ className isNotNil
		and:
			[ (self classNamed: className) isClass and: [ methodName isNotNil ] ]
]

{ #category : #storing }
Hypernode >> storageMethodName [
	^ self get: #storageMethodName
]

{ #category : #storing }
Hypernode >> storageMethodName: aString [
	self set: #storageMethodName to: aString
]

{ #category : #storing }
Hypernode >> storeOn: aStream [
	"We store the HypernodeGraph as a code snippet that asks a HypernodeBuilder to recreate the graph. Each Hypernode is assigned an id, which is used by the builder to uniquely identify the nodes. Note that we start the search for all nodes not from this node, but from the root of the graph. Most graphs have a single root, but some may have multiple subroots."

	| allNodes nodeIdMap rootId myId |
	allNodes := self root allNodes.

	"Note the id of each node."
	nodeIdMap := IdentityDictionary new.
	allNodes doWithIndex: [ :each :id | nodeIdMap at: each put: id ].
	rootId := nodeIdMap at: self root.
	myId := nodeIdMap at: self .

	"Use the builder to map each old id to the new node."
	aStream
		nextPutAll: 'HypernodeBuilder new';
		cr.

	"Recreate each reachable node with its properties."
	allNodes
		doWithIndex: [ :each :id | 
			"Create the subgraphs for each node."
			aStream nextPutAll: '  addNode: (Hypernode new '.
			each properties isNotEmpty
				ifTrue: [ aStream
						cr;
						nextPutAll: '  '.
					each storePropertiesOn: aStream.
					aStream nextPutAll: '    ' ].
			aStream
				nextPutAll: 'yourself)';
				nextPutAll: ' for: ';
				nextPutAll: id asString;
				nextPutAll: ';';
				cr ].

	"Add the subgraph nodes to each node."
	allNodes
		doWithIndex: [ :each :id | 
			each contexts
				do: [ :context | 
					aStream
						nextPutAll: '  addSubNode: ';
						nextPutAll: (nodeIdMap at: context node) asString;
						nextPutAll: '  for: ';
						nextPutAll: id asString;
						cr;
						nextPutAll: '    withContextProperties: '.
					context properties storeOn: aStream.
					aStream
						nextPutAll: ';';
						cr ] ].

	"Add the subgraph edges to each node."
	"HB addEdgeFrom:to:for:withProperties:"
	allNodes
		doWithIndex: [ :each :id | 
			each links
				do: [ :edge | 
					aStream
						nextPutAll: '  addEdgeFrom: ';
						nextPutAll: (nodeIdMap at: edge source) asString;
						nextPutAll: ' to: ';
						nextPutAll: (nodeIdMap at: edge target) asString;
						nextPutAll: ' for: ';
						nextPutAll: id asString;
						cr;
						nextPutAll: '    withProperties: '.
					edge properties storeOn: aStream.
					aStream
						nextPutAll: ';';
						cr ] ].

	"Set the root for each node"
	allNodes
		doWithIndex: [ :each :id | 
			aStream
				nextPutAll: '  setRootFor: ';
				nextPutAll: id asString;
				nextPutAll: '  to: ';
				nextPutAll: rootId asString;
				nextPutAll: ';';
				cr ].

	"Return myself"
	aStream
		nextPutAll: '  nodeForId: ';
		nextPutAll: myId asString;
		nextPutAll: '.';
		cr
]
