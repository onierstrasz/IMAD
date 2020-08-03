"
I handle a Ctrl-click and drag event between two nodes to create an edge.
I must be on a node when starting and stopping.

This would be better done using separate drag and drop events, but it seems that BlDropEvent is currently (2020-06-12) broken (sent to the dragged element instead of the drop location). 
"
Class {
	#name : #BlEdgeBuilder,
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
BlEdgeBuilder >> dragEndEvent: anEvent [
	edgeStarted
		ifTrue: [ | endNode |
			anEvent consumed: true.
			"endNode := container findMouseEventTargetAt: anEvent position."
			endNode := self findCardElementAt: anEvent position.
			endNode
				ifNotNil: [ endNode graph isNode
						ifTrue: [ | fromCard toCard |
							fromCard := startNode graph model.
							toCard := endNode graph model.
							self
								assert: (fromCard isKindOf: Card)
								description: fromCard asString , ' should be an instance of Card'.
							self
								assert: (toCard isKindOf: Card)
								description: toCard asString , ' should be an instance of Card'.
							fromCard connectTo: toCard ] ].
			container removeChild: mousePositionElement.
			container removeChild: lineElement ]
]

{ #category : #accessing }
BlEdgeBuilder >> dragEvent: anEvent [
	edgeStarted
		ifTrue: [ anEvent consumed: true.
			mousePositionElement
				relocate: (anEvent currentTarget globalPointToParent: anEvent position) ]
]

{ #category : #accessing }
BlEdgeBuilder >> dragStartEvent: anEvent [
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
BlEdgeBuilder >> eventsToHandle [
	^ { BlDragStartEvent . BlDragEvent . BlDragEndEvent }
]

{ #category : #accessing }
BlEdgeBuilder >> findCardElementAt: aPosition [
	| element |
	element := container findMouseEventTargetAt: aPosition.
	[ element isKindOf: CardNodeView ]
		whileFalse: [ (element = container or: [ element isNil ])
				ifTrue: [ ^ nil ].
			element := element parent ].
	^ element
]

{ #category : #accessing }
BlEdgeBuilder >> initialize [
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
BlEdgeBuilder >> wantsEvent: anEvent [
	"I only want Control events"
	^ (super wantsEvent: anEvent) and: [ anEvent modifiers isCtrl ]
]
