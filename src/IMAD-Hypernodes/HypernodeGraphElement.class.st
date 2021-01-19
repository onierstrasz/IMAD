"
I provide the view of a Hypernode's subgraph within the HypernodeEditor.
I sit inside the graphHolder of the HypernodeEditor.
I can be replaced if the graph is changed.

I also keep track of the mappings from model entities back to their elements (in the graphElementsDictionary).
NB: The dictionary is needed because for each edge to create we have to look up the element corresponding to the other end of the relation.
NB: We can also use this to map relations to their edges, if needed.
I do not directly handle events, but this is done by the graphHolder.
Event handling is defined in ${method:name=HypernodeEditor>>#handleEvents}$.

(I am based on  ${class:name=VirtualHandGraphView}$.)

"
Class {
	#name : #HypernodeGraphElement,
	#superclass : #AbstractHypernodeElement,
	#instVars : [
		'graphElementsDictionary',
		'node'
	],
	#category : #'IMAD-Hypernodes-IMAD-Hypernodes'
}

{ #category : #accessing }
HypernodeGraphElement class >> for: aHypernode [
	^ self new
		initializeFor: aHypernode;
		yourself
]

{ #category : #accessing }
HypernodeGraphElement >> addEdge: aHyperlink [
	self addChild: (HyperlinkView forLink: aHyperlink inGraph: self)
]

{ #category : #accessing }
HypernodeGraphElement >> addNewContext: aHypernodeContext [
	| nodeElement |
	nodeElement := HypernodeElement forContext: aHypernodeContext.
	self mapModelEntity: aHypernodeContext node toElement: nodeElement.
	self addChild: nodeElement.
	
	nodeElement relocate: aHypernodeContext position
]

{ #category : #accessing }
HypernodeGraphElement >> contextFor: aNode [
	"Not yet used anywhere?"

	^ (self elementFor: aNode) context
]

{ #category : #accessing }
HypernodeGraphElement >> contexts [
	^ self node contexts
]

{ #category : #accessing }
HypernodeGraphElement >> defaultLayout [
	<todo: 'Note sure we really want this ... instead we need to change or set the layout depending on the situation'>
	^ BlOnceLayout new layout: BlFitLayout new

	"^ BlOnceLayout new layout: GtGradHorizontalTreeLayout new"

	"The KamadaKawai force-based layout seems to lead to zero-divide issues.
	The Tree Layout leads to problems with cycles.
	The Circle Layout can't cope with empty graphs."

	"^ BlOnceLayout new layout: GtGradCircleLayout new"

	"^ BlOnceLayout new layout: GtGradKamadaKawaiLayout new"
]

{ #category : #accessing }
HypernodeGraphElement >> edges [
	^ node edges
]

{ #category : #accessing }
HypernodeGraphElement >> elementFor: aNode [
	self assert: (graphElementsDictionary includesKey: aNode).
	^ graphElementsDictionary at: aNode
]

{ #category : #accessing }
HypernodeGraphElement >> initialize [
	super initialize.
	graphElementsDictionary := IdentityDictionary new.
	self
		layout: (BlWrapAroundChildrenLayout new addLayout: BlBasicNodeBasedLayout new);
		constraintsDo: [ :c | 
			c horizontal fitContent.
			c vertical fitContent ];
		padding: (BlInsets all: self defaultPadding);
		margin: (BlInsets all: self defaultMargin);
		clipChildren: false.
	self inDebugMode
		ifTrue: [ self
				background: Color white;
				effect: BrGlamorousShadowEffect new ]
]

{ #category : #accessing }
HypernodeGraphElement >> initializeFor: aHypernode [
	"Initialization method."

	<todo: 'also pass style as a parameter?'>
	node := aHypernode.
	self contexts
		ifNotEmpty: [ self contexts do: [ :context | self addNewContext: context ] ].
	self edges
		do: [ :edge | 
		
		self addEdge: edge
		.
		
		"self addChild: (HyperlinkView forLink: edge inGraph: self) "].
	self subscribe.
	^ self
]

{ #category : #accessing }
HypernodeGraphElement >> mapModelEntity: aNode toElement: nodeElement [
	"Map nodes back to their element within this graph"
	self assert: (graphElementsDictionary includesKey: aNode) not.
	graphElementsDictionary at: aNode put: nodeElement
]

{ #category : #accessing }
HypernodeGraphElement >> node [
	^ node
]

{ #category : #accessing }
HypernodeGraphElement >> nodeElements [
	"for debugging"

	^ graphElementsDictionary values
]

{ #category : #accessing }
HypernodeGraphElement >> nodes [
	^ self node nodes
]

{ #category : #accessing }
HypernodeGraphElement >> repositionNode: aHypernodeContext [
	aHypernodeContext position isNotNil
		ifTrue: [ (self elementFor: aHypernodeContext node)
				relocate: aHypernodeContext position ]
]

{ #category : #accessing }
HypernodeGraphElement >> repositionNodes [
	"Reposition all nodes according to the position stored in the context."

	self contexts do: [ :context | self repositionNode: context ]
]

{ #category : #accessing }
HypernodeGraphElement >> subscribe [
	self node announcer
		when: CreateNodeContext
		do:
			[ :announcement :subscriber | self addNewContext: announcement context ]
		for: self.
	self node announcer
		when: UpdateNodeContext
		do:
			[ :announcement :subscriber | self repositionNode: announcement context ]
		for: self.
	self node announcer
		when: CreateLink
		do:
			[ :announcement :subscriber | self addEdge: announcement link ]
		for: self
]

{ #category : #accessing }
HypernodeGraphElement >> unsubscribe [
	self node announcer unsubscribe: self
]
