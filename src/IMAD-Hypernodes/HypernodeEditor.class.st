"
I provide a pluggable editor view of a Hypernode and its embedded subgraph.

See ${class:name=VirtualHandGUI}$ for implementation hints, especially ${method:name=VirtualHandGUI>>#buildGraphPane}$.

The graph is managed by a ${class:name=HypernodeGraphElement}$, and the nodes by instances of ${class:name=HypernodeElement}$.

Events for Hypernode subgraphs are handled by the graphHolder, defined in ${method:name=HypernodeEditor>>#handleEvents}$.  Event handling for Hypernodes is defined in ${method:name=HypernodeElement>>#handleEvents}$.

Todo:
graphical display;
special nodes for external links;
different layout regimes;
handle edit actions and events;
configurable look

"
Class {
	#name : #HypernodeEditor,
	#superclass : #AbstractHypernodeElement,
	#instVars : [
		'node',
		'graphContainer',
		'graphHolder',
		'graph'
	],
	#category : #'IMAD-Hypernodes'
}

{ #category : #accessing }
HypernodeEditor class >> for: aHypernode [
	^ self new
		for: aHypernode;
		yourself
]

{ #category : #accessing }
HypernodeEditor >> buildButtonBar [
	| buttonBar |
	buttonBar := BlElement new
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical fitContent ];
		layout: BlLinearLayout horizontal;
		padding: (BlInsets all: self defaultPadding);
		margin: (BlInsets all: self defaultMargin);
		yourself.
	buttonBar
		addChild:
			(BlElement new
				constraintsDo: [ :c | 
					c horizontal matchParent.
					c vertical matchParent ];
				yourself).
	"buttonBar
		addChild:
			(BrButton new
				look: BrGlamorousButtonWithIconLook;
				icon: BrGlamorousVectorIcons add;
				label: 'Add card';
				action: [ self deck addCard: Card new ])."
	buttonBar
		addChild:
			(BrButton new
				look: BrGlamorousButtonWithIconLook;
				icon: BrGlamorousIcons zoomin;
				label: 'Zoom In';
				action: [ graphContainer zoomIn ]).
	buttonBar
		addChild:
			(BrButton new
				look: BrGlamorousButtonWithIconLook;
				icon: BrGlamorousIcons zoomout;
				label: 'Zoom Out';
				action: [ graphContainer zoomOut ]).
	buttonBar
		addChild:
			(BrButton new
				look: BrGlamorousButtonWithIconLook;
				icon: BrGlamorousIcons zoomtofit;
				label: 'Fit';
				action: [ graphContainer zoomToFit ]).
	buttonBar
		addChild:
			(BrButton new
				look: BrGlamorousButtonWithIconLook;
				icon: BrGlamorousIcons actualsize;
				label: 'Resize';
				action: [ graphContainer zoomToActualSize ]).
	buttonBar
		addChild:
			(BrButton new
				look: BrGlamorousButtonWithIconLook;
				icon: BrGlamorousVectorIcons refresh;
				label: 'Refresh';
				action: [ self updateGraph ]).
	self inDebugMode
		ifTrue: [ buttonBar border: (BlBorder paint: Color orange) ].
	^ buttonBar
]

{ #category : #accessing }
HypernodeEditor >> buildGraphContainer [
	"I contain the graphHolder that holds actual graph (which may change), and handle mouse events."

	graph := HypernodeGraphElement for: self node.
	graphHolder := BlPinchableElement new
		zoomLevel: 1;
		zoomStep: 0.5;
		clipChildren: false;
		contentElement: graph.
		
	graphContainer := graphHolder asPannableElement
		padding: (BlInsets all: self defaultPadding);
		margin: (BlInsets all: self defaultMargin).

	self handleEvents.
	self inDebugMode
		ifTrue: [ graphHolder border: (BlBorder paint: Color lightGray).
			graphContainer border: (BlBorder paint: Color orange) ].
	^ graphContainer
]

{ #category : #accessing }
HypernodeEditor >> contextMenu [
	<todo: 'Add graph context menu actions here.
	Those here are just placeholders, or used for debugging.'>
	^ BrGlamorousSimpleContextMenuContent new
		items:
			{('Inspect self' -> [ :e | self node inspect ]).
			('Reposition nodes' -> [ :e | self graph repositionNodes ])};
		yourself
]

{ #category : #accessing }
HypernodeEditor >> for: aHypernode [
	"self unsubscribe."

	self node: aHypernode.

	"self subscribe.
	self updateHeaderName.
	self tagPane updateTagFilterButtonsForHand: self hand.
	self updateGraph"
]

{ #category : #accessing }
HypernodeEditor >> graph [
	^ graph
]

{ #category : #accessing }
HypernodeEditor >> graph: aHypernodeGraphElement [
	graph notNil
		ifTrue: [ graph unsubscribe ].
	graph := aHypernodeGraphElement.
	graphHolder contentElement: graph
]

{ #category : #accessing }
HypernodeEditor >> handleEvents [
	<todo: 'Add CMD-click'>
	"double-click"
	graphContainer
		when: BlDoubleClickEvent
		do: [ :evt | 
			| newNode |
			newNode := self node
				addNodeWithPosition: (graphHolder globalPointToLocal: evt position) ].
	"right-click"
	graphContainer
		look: (BrGlamorousWithContextMenuLook content: [ self contextMenu ])
]

{ #category : #accessing }
HypernodeEditor >> initialize [
	super initialize.
	node := Hypernode new.
	self
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical matchParent ];
		layout: BlLinearLayout vertical;
		padding: (BlInsets all: self defaultPadding);
		margin: (BlInsets all: self defaultMargin).
	self inDebugMode
		ifTrue: [ self border: (BlBorder paint: Color blue width: 1) ].
	self
		addChildren:
			{self buildButtonBar.
			self buildGraphContainer}.
	self updateGraph
]

{ #category : #accessing }
HypernodeEditor >> node [
	^ node
]

{ #category : #accessing }
HypernodeEditor >> node: aHypernode [
	node := aHypernode.
	self updateGraph
]

{ #category : #accessing }
HypernodeEditor >> nodeElements [
	"for debugging"

	^ self graph nodeElements
]

{ #category : #accessing }
HypernodeEditor >> updateGraph [
	"Use this to build or rebuild the graph"

	<todo:
		'Do we need to set the zoomLevel to the same as the old graph?
	Should we reall build a new graph, or just update the existing one?
	Revisit this when we install all the announcements.'>
	self graph: (HypernodeGraphElement for: self node)


	"newGraph := self buildGraph.
	oldGraph ifNotNil: [ newGraph zoomLevel: oldGraph zoomLevel ].
	graphHolder removeChildren.
	graphHolder addChild: newGraph"
]
