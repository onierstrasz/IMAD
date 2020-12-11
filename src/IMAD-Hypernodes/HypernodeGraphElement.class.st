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
	#superclass : #BlElement,
	#instVars : [
		'graphElementsDictionary',
		'node'
	],
	#category : #'IMAD-Hypernodes-IMAD-Hypernodes'
}

{ #category : #accessing }
HypernodeGraphElement >> defaultLayout [
	"The KamadaKawai force-based layout seems to lead to zero-divide issues.
	The Tree Layout leads to problems with cycles.
	The Circle Layout can't cope with empty graphs."

	"^ BlOnceLayout new layout: GtGradCircleLayout new"
	
	^ BlOnceLayout new layout: GtGradHorizontalTreeLayout new

	"^ BlOnceLayout new layout: GtGradKamadaKawaiLayout new"
	
	
	
]

{ #category : #accessing }
HypernodeGraphElement >> edgeElementFor: aHyperlink [
	^ HyperlinkView new forLink: aHyperlink inGraph: self
]

{ #category : #accessing }
HypernodeGraphElement >> edges [
	^ node edges
]

{ #category : #accessing }
HypernodeGraphElement >> elementFor: anEntity [
	self assert: (graphElementsDictionary includesKey: anEntity).
	^ graphElementsDictionary at: anEntity
]

{ #category : #accessing }
HypernodeGraphElement >> for: aHypernode [
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
HypernodeGraphElement >> initialize [
	<todo: 'Fix creation of new node -- need announcements?'>
	super initialize.
	graphElementsDictionary := Dictionary new.
	self
		constraintsDo: [ :c | 
			c horizontal fitContent.
			c vertical fitContent ].
	"Border for debugging only"
	self border: (BlBorder paint: Color paleBlue width: 0.5).
	
]

{ #category : #accessing }
HypernodeGraphElement >> mapModelEntity: aNode toElement: nodeElement [
	graphElementsDictionary at: aNode put: nodeElement
]

{ #category : #accessing }
HypernodeGraphElement >> node [
	^ node
]

{ #category : #accessing }
HypernodeGraphElement >> nodeElementFor: aNode [ 

	^ HypernodeElement new
		node: aNode;
		yourself
]

{ #category : #accessing }
HypernodeGraphElement >> nodes [
	^ self node nodes
]
