"
I provide the view of a Hypernode's subgraph within the HypernodeEditor.
I sit inside the graphHolder of the HypernodeEditor.
I can be replaced if the graph is changed.

I also keep track of the mappings from model entities back to their elements (in the graphElementsDictionary).
NB: The dictionary is needed because for each edge to create we have to look up the element corresponding to the other end of the relation.
NB: We can also use this to map relations to their edges, if needed.

(I am based on  ${class:name=VirtualHandGraphView}$.)

"
Class {
	#name : #HypernodeGraphView,
	#superclass : #BlElement,
	#instVars : [
		'graphElementsDictionary',
		'node'
	],
	#category : #'IMAD-Hypernodes-IMAD-Hypernodes'
}

{ #category : #accessing }
HypernodeGraphView >> contextMenu [
	<todo: 'add graph context menu actions here'>
	^ BrGlamorousSimpleContextMenuContent new
		items: {('Inspect self' -> [ :e | self node inspect ])};
		yourself
]

{ #category : #accessing }
HypernodeGraphView >> defaultLayout [
	"The KamadaKawai force-based layout seems to lead to zero-divide issues.
	The Tree Layout leads to problems with cycles.
	The Circle Layout can't cope with empty graphs."

	"^ BlOnceLayout new layout: GtGradCircleLayout new"
	
	^ BlOnceLayout new layout: GtGradHorizontalTreeLayout new

	"^ BlOnceLayout new layout: GtGradKamadaKawaiLayout new"
	
	
	
]

{ #category : #accessing }
HypernodeGraphView >> edgeElementFor: aHyperlink [
	^ HyperlinkView new forLink: aHyperlink inGraph: self
]

{ #category : #accessing }
HypernodeGraphView >> edges [
	^ node edges
]

{ #category : #accessing }
HypernodeGraphView >> elementFor: anEntity [
	self assert: (graphElementsDictionary includesKey: anEntity).
	^ graphElementsDictionary at: anEntity
]

{ #category : #accessing }
HypernodeGraphView >> for: aHypernode [
	<todo: 'also pass style as a parameter?'>
	node := aHypernode.
	graphElementsDictionary := Dictionary new.
	self nodes
		ifNotEmpty: [ self nodes
				do: [ :aNode | 
					| nodeElement |
					nodeElement := self nodeElementFor: aNode.
					self mapModelEntity: aNode toElement: nodeElement.
					self addChild: nodeElement ] ].
	self edges do: [ :edge | self addChild: (self edgeElementFor: edge) ].
	"self layout: self style layout."
	self layout: self defaultLayout.
	self clipChildren: false.
	^ self
]

{ #category : #accessing }
HypernodeGraphView >> initialize [
	<todo: 'Fix creation of new node -- need announcements?'>
	super initialize.
	graphElementsDictionary := Dictionary new.
	self
		constraintsDo: [ :c | 
			c horizontal fitContent.
			c vertical fitContent ].
	"Border for debugging only"
	self border: (BlBorder paint: Color paleBlue width: 0.5).
	self
		viewModel: (BrInteractiveModel with: BrHoverModel new);
		look: (BrGlamorousWithContextMenuLook content: [ self contextMenu ]).	"right-click"
	self
		addEventHandler:
			(BlEventHandler
				on: BlDoubleClickEvent
				do: [ :evt | self node addNode ])	"Double-click"
]

{ #category : #accessing }
HypernodeGraphView >> mapModelEntity: aNode toElement: nodeElement [
	graphElementsDictionary at: aNode put: nodeElement
]

{ #category : #accessing }
HypernodeGraphView >> node [
	^ node
]

{ #category : #accessing }
HypernodeGraphView >> nodeElementFor: aNode [ 

	^ HypernodeElement new
		node: aNode;
		yourself
]

{ #category : #accessing }
HypernodeGraphView >> nodes [
	^ self node nodes
]
