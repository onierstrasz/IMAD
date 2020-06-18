"
I represent a relation.

I should store the relation itself so I can inspect it and display its properties.
I also need to store the actual elements that I connect because ...
if I am deleted, ...


"
Class {
	#name : #CardRelationElement,
	#superclass : #BlLineElement,
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
			{('Inspect relation' -> [ relation inspect ]).
			('Delete relation'
				-> [ menu anchor: BlElement new.
					relation delete ])};
		yourself.
	^ menu
]

{ #category : #accessing }
CardRelationElement >> forRelation: aRelation inGraph: aCardGraph [
	<todo: 'save the relation and the graph
	build and return the edge (myself)'>
	
]

{ #category : #accessing }
CardRelationElement >> from: sourceElt to: targetElt [
	<todo: 'find a better way to draw directed edges'>
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
				hovered: [ :elt | elt border: (BlBorder paint: Color red width: 2) ])
				+ (BrGlamorousWithContextMenuLook content: [ self contextMenu ]).
	^ self
]

{ #category : #accessing }
CardRelationElement >> initialize [
	super initialize.
	self zIndex: -1.

]
