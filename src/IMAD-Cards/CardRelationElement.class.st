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
		'cardGraph',
		'edgeElement'
	],
	#category : #'IMAD-Cards-View'
}

{ #category : #accessing }
CardRelationElement >> addLook [

	edgeElement
		viewModel: (BrInteractiveModel with: BrHoverModel new);
		look:
			(BrInteractiveCommonLook new
				default: [ :elt | elt border: (BlBorder paint: Color gray width: 2) ];
				hovered: [ :elt | elt border: (BlBorder paint: Color blue width: 2) ])
				+ (BrGlamorousWithContextMenuLook content: [ self contextMenu ])
				+
					(BrGlamorousWithTooltipLook2
						content: (self tooltipWithText: self relation kind)).
]

{ #category : #accessing }
CardRelationElement >> connectCenterLeftToRightAnchorFrom: sourceElt To: targetElt [
	edgeElement
		fromAnchor: (BlElementCenterRightAnchor element: sourceElt);
		toAnchor: (BlElementCenterLeftAnchor element: targetElt);
		toHead:
			(BlArrowheadSimpleArrow new
				border: (BlBorder paint: Color gray width: 3))
]

{ #category : #accessing }
CardRelationElement >> connectNearestPositionBoundsAnchorFrom: sourceElt To:  targetElt [

	edgeElement
		fromAnchor: (BlNearestPositionBoundsAnchor nearestTo: targetElt from: sourceElt);
		toAnchor: (BlNearestPositionBoundsAnchor nearestTo: sourceElt from: targetElt);
		toHead:
			(BlArrowheadSimpleArrow new
				border: (BlBorder paint: Color gray width: 3)).
]

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
	"Look up the source and target elements in the graph and connect them with a new edge element (BlLineElement or other curve)"

	<todo:
		'
		- FIX Center Anchor connections
		- offer a way to plug in different styles of edges (subclasses of BlCurveElement) 
		- find a better way to draw directed edges
    	- add space between multiple edges along same path
	'>
	| sourceElt targetElt |
	relation := aRelation.
	cardGraph := aCardGraph.
	sourceElt := cardGraph elementFor: self relation source.
	targetElt := cardGraph elementFor: self relation target.
	sourceElt graph connectTo: targetElt.
	edgeElement := self newSigmoid.
	self connectCenterLeftToRightAnchorFrom: sourceElt To: targetElt.
	"edgeElement := self newLine."
	"self connectNearestPositionBoundsAnchorFrom: sourceElt To: targetElt."
	self addLook.
	^ edgeElement
]

{ #category : #accessing }
CardRelationElement >> initialize [
	"NB: most of the initialization is in forRelation:inGraph:"
	super initialize.
	self zIndex: -1.

]

{ #category : #accessing }
CardRelationElement >> newLine [
	^ BlLineElement new
		zIndex: -1;
		yourself
]

{ #category : #accessing }
CardRelationElement >> newSigmoid [
	^ BlSigmoidElement new
		border: (BlBorder paint: Color gray width: 3);
		zIndex: 10;
		bendingPoint: 0.5;
		sharpness: 1.0;
		yourself
]

{ #category : #accessing }
CardRelationElement >> relation [
	^ relation
]
