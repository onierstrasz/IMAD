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
		'node',
		'graphContextsDictionary'
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
HypernodeGraphElement >> contextFor: anEntity [
	self assert: (graphContextsDictionary includesKey: anEntity).
	^ graphContextsDictionary at: anEntity
]

{ #category : #accessing }
HypernodeGraphElement >> contexts [
	^ self node contexts
]

{ #category : #accessing }
HypernodeGraphElement >> defaultLayout [
	"NOT NEEDED?"

	"The KamadaKawai force-based layout seems to lead to zero-divide issues.
	The Tree Layout leads to problems with cycles.
	The Circle Layout can't cope with empty graphs."

	"^ BlOnceLayout new layout: GtGradCircleLayout new"

	^ BlOnceLayout new layout: GtGradHorizontalTreeLayout new

	"^ BlOnceLayout new layout: GtGradKamadaKawaiLayout new"
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
HypernodeGraphElement >> initialize [
	super initialize.
	graphElementsDictionary := Dictionary new.
	graphContextsDictionary := Dictionary new.
	self
		constraintsDo: [ :c | 
			c horizontal fitContent.
			c vertical fitContent ].
	"Border for debugging only"
	self border: (BlBorder paint: Color blue width: 1).
]

{ #category : #accessing }
HypernodeGraphElement >> initializeFor: aHypernode [
	"Initialization method."

	<todo: 'also pass style as a parameter?'>
	node := aHypernode.
	graphElementsDictionary := Dictionary new.
	self contexts
		ifNotEmpty: [ self contexts
				do: [ :context | 
					| nodeElement |
					nodeElement := HypernodeElement for: context node.
					self mapModelEntity: context node toContext: context.
					self mapModelEntity: context node toElement: nodeElement.
					self addChild: nodeElement ] ].
	self edges
		do: [ :edge | self addChild: (HyperlinkView forLink: edge inGraph: self) ].
	self repositionNodes.
	
	"What is the right Layout object to use?"
	
	self layout: BlBasicLayout new.
	"self layout: BlFitChildrenLayout new."
	"self layout: BlOnceLayout new."

	self clipChildren: false.
	^ self
]

{ #category : #accessing }
HypernodeGraphElement >> mapModelEntity: aNode toContext: aContext [
	"Map nodes back to their context within this graph"
	graphElementsDictionary at: aNode put: aContext
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
HypernodeGraphElement >> nodeElements [
	"for debugging"

	^ graphElementsDictionary values
]

{ #category : #accessing }
HypernodeGraphElement >> nodes [
	^ self node nodes
]

{ #category : #accessing }
HypernodeGraphElement >> repositionNodes [
	"Reposition all nodes according to the position stored in the context."

	self contexts
		do: [ :context | 
			context position isNotNil
				ifTrue: [ (self elementFor: context node) relocate: context position ] ]
]
