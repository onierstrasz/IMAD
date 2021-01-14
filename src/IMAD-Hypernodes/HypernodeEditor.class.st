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

	<todo: 'Add CMD-click'>
	graph := HypernodeGraphElement for: self node.
	graphHolder := BlPinchableElement new
		zoomLevel: 2;
		clipChildren: false;
		contentElement: graph.
	graphContainer := BlElement new
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical matchParent ];
		layout: BlLinearLayout vertical;
		padding: (BlInsets all: self defaultPadding);
		margin: (BlInsets all: self defaultMargin);
		yourself.
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
	self tagPane updateTagFilterButtonsForHand: self hand."
	self updateGraph
]

{ #category : #accessing }
HypernodeEditor >> graph [
	^ graph
]

{ #category : #accessing }
HypernodeEditor >> graph: aHypernodeGraphElement [
	graph := aHypernodeGraphElement.
	graphHolder contentElement: graph
]

{ #category : #accessing }
HypernodeEditor >> handleEvents [
	"OLD CODE:"

	"graphHolder
		addEventHandler:
			(BlEventHandler
				on: BlDoubleClickEvent
				do: [ :evt | 
					self node
						addNodeWithPosition: (self graph globalPointToLocal: evt position)


				])"

	"Double-click"
	
	<todo: 'I should not directly add and position the node, but this should be handled indiractly by announcements from the Hypernode model.'>

	graphContainer
		viewModel: (BrInteractiveModel with: BrHoverModel new);
		look: (BrGlamorousWithContextMenuLook content: [ self contextMenu ]).	"right-click"
	graphContainer
		when: BlDoubleClickEvent
		do: [ :evt | 
			| newNode |
			newNode := self node
				addNodeWithPosition: (self graph globalPointToLocal: evt position).
			"NB: The following code should disappear!"
			graph addChild: newNode.
			newNode relocate: (graphHolder globalPointToLocal: evt position) ]
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
	node := aHypernode
]

{ #category : #accessing }
HypernodeEditor >> nodeElements [
	"for debugging"

	^ self graph nodeElements
]

{ #category : #accessing }
HypernodeEditor >> updateGraph [

	<todo: 'Do we need to set the zoomLevel to the same as the old graph?
	Should we reall build a new graph, or just update the existing one?
	Revisit this when we install all the announcements.'>
	self graph: (HypernodeGraphElement for: self node)


	"newGraph := self buildGraph.
	oldGraph ifNotNil: [ newGraph zoomLevel: oldGraph zoomLevel ].
	graphHolder removeChildren.
	graphHolder addChild: newGraph"
]
