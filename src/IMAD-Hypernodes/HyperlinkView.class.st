"
I present a Hyperlink as an edge within a graph of a Hypernode within a HypernodeView.

See also: ${class:name=CardRelationViewBuilder}$. 
"
Class {
	#name : #HyperlinkView,
	#superclass : #Object,
	#instVars : [
		'link',
		'graph',
		'linkElement'
	],
	#category : #'IMAD-Hypernodes-IMAD-Hypernodes'
}

{ #category : #accessing }
HyperlinkView class >> forLink: edge inGraph: aHypernodeGraphElement [
	^ self new
		forLink: edge inGraph: aHypernodeGraphElement
]

{ #category : #accessing }
HyperlinkView >> addLook [
	linkElement
		viewModel: (BrInteractiveModel with: BrHoverModel new);
		look:
			(BrInteractiveCommonLook new
				default: [ :elt | elt border: (BlBorder paint: Color gray width: 2) ];
				hovered: [ :elt | elt border: (BlBorder paint: Color blue width: 2) ])
				+ (BrGlamorousWithContextMenuLook content: [ self contextMenu ])
				"+
					(BrGlamorousWithTooltipLook2
						content: (self tooltipWithText: self link kind))"
]

{ #category : #accessing }
HyperlinkView >> connectCenterLeftToRightAnchorFrom: sourceElt To: targetElt [
	linkElement
		fromAnchor: (BlElementCenterRightAnchor element: sourceElt);
		toAnchor: (BlElementCenterLeftAnchor element: targetElt);
		toHead:
			(BlArrowheadSimpleArrow new
				border: (BlBorder paint: Color gray width: 3))
]

{ #category : #accessing }
HyperlinkView >> contextMenu [
	<todo: 'Adapt for links'>
	| menu |
	menu := BrGlamorousSimpleContextMenuContent new
		items:
			{('Inspect link' -> [ self link inspect ]).
			('Delete link'
				-> [ menu anchor: BlElement new.
					self link delete ])};
		yourself.
	^ menu
]

{ #category : #accessing }
HyperlinkView >> forLink: aHyperlink inGraph: aHypernodeGraphElement [
	"Look up the source and target elements in the graph and connect them with a new edge element (BlLineElement or other curve)"

	<todo:
		'
		- FIX Center Anchor connections
		- offer a way to plug in different styles of edges (subclasses of BlCurveElement) 
		- find a better way to draw directed edges
    	- add space between multiple edges along same path
	'>
	| sourceElt targetElt |
	link := aHyperlink.
	graph := aHypernodeGraphElement.
	sourceElt := graph elementFor: self link source.
	targetElt := graph elementFor: self link target.
	sourceElt graph connectTo: targetElt.
	linkElement := self newEdgeElement .
	self connectCenterLeftToRightAnchorFrom: sourceElt To: targetElt.
	"edgeElement := self newLine."
	"self connectNearestPositionBoundsAnchorFrom: sourceElt To: targetElt."
	self addLook.
	^ linkElement
]

{ #category : #accessing }
HyperlinkView >> link [
	^ link
]

{ #category : #accessing }
HyperlinkView >> newDirectedCurvedEdge [
	^ BlParabollaArcElement new
		zIndex: 0;
		curvatureFraction: 0.2;
		border: (BlBorder paint: Color gray width: 2);
		toHead:
			(BlArrowheadSimpleArrow new
				border:
					(BlBorder builder
						paint: Color gray;
						width: 2;
						build))
]

{ #category : #accessing }
HyperlinkView >> newDirectedEdge [
	^ BlParabollaArcElement new
		zIndex: 0;
		curvatureFraction: 0;
		border: (BlBorder paint: Color gray width: 2);
		toHead:
			(BlArrowheadSimpleArrow new
				border:
					(BlBorder builder
						paint: Color gray;
						width: 2;
						build))
]

{ #category : #accessing }
HyperlinkView >> newEdgeElement [
	"^ self newSigmoid"

	^ self newDirectedCurvedEdge
	"^ self newDirectedEdge"
]

{ #category : #accessing }
HyperlinkView >> newSigmoid [
	^ BlSigmoidElement new
		border: (BlBorder paint: Color gray width: 3);
		zIndex: 10;
		bendingPoint: 0.5;
		sharpness: 1.0;
		yourself
]

{ #category : #accessing }
HyperlinkView >> tooltipWithText: aString [
	"From TCardModelElement"
	^ BrLabel new
		look: BrGlamorousLabelLook new glamorousRegularFontAndSize;
		padding: (BlInsets all: 5);
		alignCenter;
		text: aString asRopedText;
		yourself.
]
