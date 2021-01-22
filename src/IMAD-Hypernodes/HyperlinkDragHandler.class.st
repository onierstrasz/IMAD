"
I handle a Ctrl-click and drag event between two nodes to create an edge.
I must be on a node when starting and stopping.

This would be better done using separate drag and drop events, but it seems that BlDropEvent is currently (2020-06-12) broken (sent to the dragged element instead of the drop location). 
"
Class {
	#name : #HyperlinkDragHandler,
	#superclass : #BlCustomEventHandler,
	#instVars : [
		'edgeStarted',
		'lineElement',
		'mousePositionElement',
		'container',
		'startElement',
		'dragStartGlobalPosition',
		'originalPosition'
	],
	#category : #'IMAD-Hypernodes'
}

{ #category : #accessing }
HyperlinkDragHandler >> dragEndEvent: anEvent [
	edgeStarted
		ifFalse: [ ^ self ].

	anEvent consumed: true.
	
	self
		findHypernodeElementAt: anEvent position
		do: [ :aHypernodeElement |
	    aHypernodeElement graph isNode
				ifTrue: [ | fromNode toNode |
					self assert: (aHypernodeElement isKindOf: HypernodeElement).
					fromNode := startElement graph model.
					toNode := aHypernodeElement graph model.
					self
						assert: (fromNode isKindOf: Hypernode)
						description: fromNode asString , ' should be an instance of Hypernode'.
					self
						assert: (toNode isKindOf: Hypernode)
						description: toNode asString , ' should be an instance of Hypernode'.
					startElement context parent addLink: fromNode -> toNode ] ].

	container removeChild: mousePositionElement.
	container removeChild: lineElement
]

{ #category : #accessing }
HyperlinkDragHandler >> dragEvent: anEvent [
	| aCurrentPosition aStartPosition dragDelta |

	edgeStarted
		ifFalse: [ ^ self ].
	
	anEvent consumed: true.
	aCurrentPosition := anEvent currentTarget globalPointToParent: anEvent position.
	aStartPosition := anEvent currentTarget globalPointToParent: dragStartGlobalPosition.

	dragDelta := aCurrentPosition - aStartPosition.

	mousePositionElement
		relocate: originalPosition + dragDelta
]

{ #category : #accessing }
HyperlinkDragHandler >> dragStartEvent: anEvent [
	startElement := anEvent currentTarget.
	startElement graph isNode
		ifFalse: [ ^ self ].

	self assert: (startElement isKindOf: HypernodeElement).
	edgeStarted := true.

	"drag start position in space coordinates"
	dragStartGlobalPosition := anEvent position.
	"element position in parent"
	originalPosition := anEvent currentTarget constraints position
		"#localPosition is an offset of the mouse within the origianal node"
		+ anEvent localPosition
		"offset the mouse position node to be centered relative to the mouse position"
		- (self mousePositionExtent / 2.0).

	anEvent consumed: true.

	container := startElement parent.
	"container := startElement container."
	mousePositionElement relocate: originalPosition.
	lineElement := BlLineElement new.
	lineElement
		zIndex: -1;
		border: (BlBorder paint: Color blue width: 1);
		fromAnchor: (BlElementCenterAnchor element: startElement);
		toAnchor: (BlElementCenterAnchor element: mousePositionElement).
	container addChild: mousePositionElement.
	container addChild: lineElement
]

{ #category : #accessing }
HyperlinkDragHandler >> eventsToHandle [
	^ { BlDragStartEvent . BlDragEvent . BlDragEndEvent }
]

{ #category : #accessing }
HyperlinkDragHandler >> findHypernodeElementAt: aGlobalPosition do: ifFoundBlock [
	container
		withAllLeafChildrenAt: (container globalPointToLocal: aGlobalPosition)
		do: [ :eachElement |
				eachElement
					withAllParentsUpTo: container
					detect: [ :eachParent | eachParent isKindOf: HypernodeElement ]
					ifFound: [ :aHypernodeElement | ^ ifFoundBlock value: aHypernodeElement ]
					ifNone: [  ] ]
]

{ #category : #accessing }
HyperlinkDragHandler >> initialize [
	super initialize.
	edgeStarted := false.
	mousePositionElement := BlElement new
		geometry: BlEllipseGeometry new;
		size: self mousePositionExtent;
		background: Color blue;
		border: BlBorder empty;
		zIndex: -1
]

{ #category : #accessing }
HyperlinkDragHandler >> mousePositionExtent [
	^ 10 @ 10
]

{ #category : #accessing }
HyperlinkDragHandler >> wantsEvent: anEvent [
	"I only want Control events"
	^ (super wantsEvent: anEvent) and: [ anEvent modifiers isCtrl ]
]
