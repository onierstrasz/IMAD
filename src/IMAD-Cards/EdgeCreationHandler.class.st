"
I handle a Ctrl-click and drag event between two nodes to create an edge.
I must be on a node when starting and stopping.
"
Class {
	#name : #EdgeCreationHandler,
	#superclass : #BlCustomEventHandler,
	#instVars : [
		'edgeStarted',
		'startNode',
		'lineElement',
		'mousePositionElement'
	],
	#category : #'IMAD-Cards-View'
}

{ #category : #accessing }
EdgeCreationHandler >> dragEndEvent: anEvent [
	"anEvent inspect"

	<todo:
		'check that we are on a card node and create the relation from the card of the start node to this card'>
	edgeStarted
		ifTrue: [ anEvent consumed: true ]
]

{ #category : #accessing }
EdgeCreationHandler >> dragEvent: anEvent [
	<todo: 'update a proto-line from the start node to where we are now'>
	edgeStarted
		ifTrue: [ anEvent consumed: true.
			mousePositionElement relocate: anEvent position ]
]

{ #category : #accessing }
EdgeCreationHandler >> dragStartEvent: anEvent [
	<todo: 'check that we are on a node and remember it as the start node'>
	startNode := anEvent currentTarget.
	startNode graph isNode
		ifTrue: [ edgeStarted := true.
			anEvent consumed: true.
			mousePositionElement relocate: anEvent position.
			lineElement := BlLineElement new.
			lineElement
				zIndex: -1;
				border: (BlBorder paint: Color blue width: 1);
				fromAnchor: (BlAbsolutePositionAnchor position: anEvent position);
				toAnchor: (BlElementCenterAnchor element: mousePositionElement) ]
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
]

{ #category : #accessing }
EdgeCreationHandler >> wantsEvent: anEvent [
	"I only want Control events"
	^ (super wantsEvent: anEvent) and: [ anEvent modifiers isCtrl ]
]
