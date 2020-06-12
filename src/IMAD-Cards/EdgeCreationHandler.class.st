"
I handle a Ctrl-click and drag event between two nodes to create an edge.
I must be on a node when starting and stopping.

This would be better done using separate drag and drop events, but it seems that BlDropEvent is currently (2020-06-12) broken (sent to the dragged element instead of the drop location). 
"
Class {
	#name : #EdgeCreationHandler,
	#superclass : #BlCustomEventHandler,
	#instVars : [
		'edgeStarted',
		'startNode',
		'lineElement',
		'mousePositionElement',
		'container'
	],
	#category : #'IMAD-Cards-View'
}

{ #category : #accessing }
EdgeCreationHandler >> dragEndEvent: anEvent [
	"anEvent inspect"

	<todo:
		'check that we are on a card node and create the relation from the card of the start node to this card'>
	edgeStarted
		ifTrue: [ | endNode |
			anEvent consumed: true.
			endNode := container findMouseEventTargetAt: anEvent position.
			endNode graph isNode
				ifTrue: [ | fromCard toCard |
					fromCard := startNode graph model.
					toCard := endNode graph model.
					self
						assert: (fromCard isKindOf: Card)
						description: fromCard asString , ' should be an instance of Card'.
					self
						assert: (toCard isKindOf: Card)
						description: toCard asString , ' should be an instance of Card'.
					fromCard connectTo: toCard ].
			container removeChild: mousePositionElement.
			container removeChild: lineElement ]
]

{ #category : #accessing }
EdgeCreationHandler >> dragEvent: anEvent [
	<todo: 'update a proto-line from the start node to where we are now'>
	edgeStarted
		ifTrue: [ anEvent consumed: true.
			mousePositionElement
				relocate: (anEvent currentTarget globalPointToParent: anEvent position) ]
]

{ #category : #accessing }
EdgeCreationHandler >> dragStartEvent: anEvent [
	<todo: 'check that we are on a node and remember it as the start node'>
	startNode := anEvent currentTarget.
	startNode graph isNode
		ifTrue: [ edgeStarted := true.
			anEvent consumed: true.
			container := startNode parent.
			container addChild: mousePositionElement.
			mousePositionElement relocate: startNode position.
			lineElement := BlLineElement new.
			lineElement
				zIndex: -1;
				border: (BlBorder paint: Color blue width: 1);
				fromAnchor: (BlElementCenterAnchor element: startNode);
				toAnchor: (BlElementCenterAnchor element: mousePositionElement).
			container addChild: lineElement ]
]

{ #category : #accessing }
EdgeCreationHandler >> eventsToHandle [
	^ { BlDragStartEvent . BlDragEvent . BlDragEndEvent }
]

{ #category : #accessing }
EdgeCreationHandler >> initialize [
	super initialize.
	edgeStarted := false.
	mousePositionElement := BlElement new
		geometry: BlEllipse new;
		size: 10@10;
		background: Color blue;
		border: BlBorder empty.
	mousePositionElement relocate: 0 @ 0
]

{ #category : #accessing }
EdgeCreationHandler >> wantsEvent: anEvent [
	"I only want Control events"
	^ (super wantsEvent: anEvent) and: [ anEvent modifiers isCtrl ]
]
