"
I handle a Ctrl-click and drag event between two nodes to create an edge.
I must be on a node when starting and stopping.
"
Class {
	#name : #EdgeCreationHandler,
	#superclass : #BlCustomEventHandler,
	#category : #'IMAD-Cards-View'
}

{ #category : #accessing }
EdgeCreationHandler >> dragEndEvent: anEvent [
	<todo: 'check that we are on a card node and create the relation from the card of the start node to this card'>
		"anEvent inspect"
]

{ #category : #accessing }
EdgeCreationHandler >> dragEvent: anEvent [
	<todo: 'update a proto-line from the start node to where we are now'>
]

{ #category : #accessing }
EdgeCreationHandler >> dragStartEvent: anEvent [
	<todo: 'check that we are on a node and remember it as the start node'>
	"anEvent inspect"
]

{ #category : #accessing }
EdgeCreationHandler >> eventsToHandle [
	^ { BlDragStartEvent . BlDragEvent . BlDragEndEvent }
]

{ #category : #accessing }
EdgeCreationHandler >> wantsEvent: anEvent [
	"I only want Control events"
	^ (super wantsEvent: anEvent) and: [ anEvent modifiers isCtrl ]
]
