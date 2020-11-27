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
	#name : #HypernodeView,
	#superclass : #BlElement,
	#instVars : [
		'graphElementsDictionary',
		'node'
	],
	#category : #'IMAD-Hypernodes-IMAD-Hypernodes'
}

{ #category : #accessing }
HypernodeView >> for: aHypernode [
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
	"self nodes
		do: [ :source | 
			source sourceRelations
				do: [ :rel | 
					(hand containsRelation: rel)
						ifTrue: [ self addChild: (self edgeElementFor: rel) ] ] ]."
	"self layout: self style layout."
	self clipChildren: false.
	^ self
]

{ #category : #accessing }
HypernodeView >> initialize [
	super initialize.
	graphElementsDictionary := Dictionary new.
	self
		constraintsDo: [ :c | 
			c horizontal fitContent.
			c vertical fitContent ]
]

{ #category : #accessing }
HypernodeView >> mapModelEntity: aNode toElement: nodeElement [
	graphElementsDictionary at: aNode put: nodeElement
]

{ #category : #accessing }
HypernodeView >> nodeElementFor: aNode [ 

	^ HypernodeElement new
		node: aNode;
		yourself
]

{ #category : #accessing }
HypernodeView >> nodes [
	^ node nodes
]
