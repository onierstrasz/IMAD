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
		'startElement'
	],
	#category : #'IMAD-Hypernodes'
}

{ #category : #accessing }
HyperlinkDragHandler >> dragEndEvent: anEvent [
	edgeStarted
		ifTrue: [ | endElement |
			anEvent consumed: true.
			"endNode := container findMouseEventTargetAt: anEvent position."
			endElement := self findHypernodeElementAt: anEvent position.
			endElement
				ifNotNil: [ endElement graph isNode
						ifTrue: [ | fromNode toNode |
							self assert: (endElement isKindOf: HypernodeElement).
							fromNode := startElement graph model.
							toNode := endElement graph model.
							self
								assert: (fromNode isKindOf: Hypernode)
								description: fromNode asString , ' should be an instance of Hypernode'.
							self
								assert: (toNode isKindOf: Hypernode)
								description: toNode asString , ' should be an instance of Hypernode'.
							startElement context parent addLink: fromNode -> toNode ] ].
			container removeChild: mousePositionElement.
			container removeChild: lineElement ]
]

{ #category : #accessing }
HyperlinkDragHandler >> dragEvent: anEvent [
	edgeStarted
		ifTrue: [ anEvent consumed: true.
			mousePositionElement
				relocate: (anEvent currentTarget globalPointToParent: anEvent position) ]
]

{ #category : #accessing }
HyperlinkDragHandler >> dragStartEvent: anEvent [
	startElement := anEvent currentTarget.
	startElement graph isNode
		ifTrue: [ self assert: (startElement isKindOf: HypernodeElement).
			edgeStarted := true.
			anEvent consumed: true.
			container := startElement parent.
			"container := startElement container."
			container addChild: mousePositionElement.
			mousePositionElement relocate: startElement position.
			lineElement := BlLineElement new.
			lineElement
				zIndex: -1;
				border: (BlBorder paint: Color blue width: 1);
				fromAnchor: (BlElementCenterAnchor element: startElement);
				toAnchor: (BlElementCenterAnchor element: mousePositionElement).
			container addChild: lineElement ]
]

{ #category : #accessing }
HyperlinkDragHandler >> eventsToHandle [
	^ { BlDragStartEvent . BlDragEvent . BlDragEndEvent }
]

{ #category : #accessing }
HyperlinkDragHandler >> findHypernodeElementAt: aPosition [
	| element |
	element := container findMouseEventTargetAt: aPosition.
	[ element isKindOf: HypernodeElement ]
		whileFalse: [ (element = container or: [ element isNil ])
				ifTrue: [ ^ nil ].
			element := element parent ].
	^ element
]

{ #category : #accessing }
HyperlinkDragHandler >> initialize [
	super initialize.
	edgeStarted := false.
	mousePositionElement := BlElement new
		geometry: BlEllipse new;
		size: 10@10;
		background: Color blue;
		border: BlBorder empty.
	"mousePositionElement relocate: 0 @ 0"
]

{ #category : #accessing }
HyperlinkDragHandler >> wantsEvent: anEvent [
	"I only want Control events"
	^ (super wantsEvent: anEvent) and: [ anEvent modifiers isCtrl ]
]
