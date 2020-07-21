"
I represent a relation.

I should store the relation itself so I can inspect it and display its properties.
I also need to store the actual elements that I connect because ...
if I am deleted, ...


"
Class {
	#name : #CardRelationElement,
	#superclass : #BlLineElement,
	#traits : 'TCardModelElement',
	#classTraits : 'TCardModelElement classTrait',
	#instVars : [
		'relation',
		'cardGraph'
	],
	#category : #'IMAD-Cards-View'
}

{ #category : #accessing }
CardRelationElement >> contextMenu [
	| menu |
	menu := BrGlamorousSimpleContextMenuContent new
		items:
			{('Inspect relation' -> [ self relation inspect ]).
			('Delete relation'
				-> [ menu anchor: BlElement new.
					self relation delete ])};
		yourself.
	^ menu
]

{ #category : #accessing }
CardRelationElement >> forRelation: aRelation inGraph: aCardGraph [
	<todo:
		'
	- save the relation and the graph
	- build and return the edge (myself)
	- find a better way to draw directed edges
	- implement a better layout along the shortest path between the centers
    - add space between multiple edges along same path
    - add tooltip with name

'>
	| sourceElt targetElt |
	relation := aRelation.
	cardGraph := aCardGraph.
	sourceElt := cardGraph elementFor: self relation source.
	targetElt := cardGraph elementFor: self relation target.
	sourceElt graph connectTo: targetElt.
	self
		fromAnchor: (BlNearestPositionBoundsAnchor nearestTo: targetElt from: sourceElt);
		toAnchor: (BlNearestPositionBoundsAnchor nearestTo: sourceElt from: targetElt);
		toHead:
			(BlArrowheadSimpleArrow new
				border: (BlBorder paint: Color gray width: 3)).
	self
		viewModel: (BrInteractiveModel with: BrHoverModel new);
		look:
			(BrInteractiveCommonLook new
				default: [ :elt | elt border: (BlBorder paint: Color gray width: 2) ];
				hovered: [ :elt | elt border: (BlBorder paint: Color blue width: 2) ])
				+ (BrGlamorousWithContextMenuLook content: [ self contextMenu ])
				+
					(BrGlamorousWithTooltipLook2 content: (self tooltipWithText: self relation kind)).
	^ self
]

{ #category : #accessing }
CardRelationElement >> initialize [
	"NB: most of the initialization is in forRelation:inGraph:"
	super initialize.
	self zIndex: -1.

]

{ #category : #accessing }
CardRelationElement >> relation [
	^ relation
]
