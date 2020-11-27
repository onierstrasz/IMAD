"
I provide a pluggable editor view of a Hypernode and its embedded subgraph.

See ${class:name=VirtualHandGUI}$ for implementation hints, especially ${method:name=VirtualHandGUI>>#buildGraphPane}$.

Todo:
graphical display;
special nodes for external links;
different layout regimes;
handle edit actions and events;
configurable look

"
Class {
	#name : #HypernodeEditor,
	#superclass : #BlElement,
	#instVars : [
		'node',
		'theGraph',
		'graphHolder'
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
				action: [ theGraph zoomIn ]).
	buttonBar
		addChild:
			(BrButton new
				look: BrGlamorousButtonWithIconLook;
				icon: BrGlamorousIcons zoomout;
				label: 'Zoom Out';
				action: [ theGraph zoomOut ]).
	buttonBar
		addChild:
			(BrButton new
				look: BrGlamorousButtonWithIconLook;
				icon: BrGlamorousIcons zoomtofit;
				label: 'Fit';
				action: [ theGraph zoomToFit ]).
	buttonBar
		addChild:
			(BrButton new
				look: BrGlamorousButtonWithIconLook;
				icon: BrGlamorousIcons actualsize;
				label: 'Resize';
				action: [ theGraph zoomToActualSize ]).
	buttonBar
		addChild:
			(BrButton new
				look: BrGlamorousButtonWithIconLook;
				icon: BrGlamorousVectorIcons refresh;
				label: 'Refresh';
				action: [ self updateGraph ]).
	^ buttonBar
]

{ #category : #accessing }
HypernodeEditor >> buildGraph [
	"I am the actual graph held by the graphHolder within the graphPane"

	"self hand filter: self tagPane filter."

	"theGraph := (VirtualHandGraphView new forHand: self hand withStyle: self style )
		asPannableElement."

	theGraph := (HypernodeView new for: self node) asPannableElement.
	theGraph zoomableElement clipChildren: false.
	^ theGraph
]

{ #category : #accessing }
HypernodeEditor >> buildGraphHolder [
	"I hold the actual graph (which may change), and handle mouse events."

	<todo: 'Add CMD-click'>
	graphHolder := BlElement new
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical matchParent ];
		padding: (BlInsets all: 5);
		margin: (BlInsets all: 5);
		layout: BlLinearLayout vertical;
		yourself.
	"graphHolder
		viewModel: (BrInteractiveModel with: BrHoverModel new);
		look: (BrGlamorousWithContextMenuLook content: [ self contextMenu ])."	"right-click"
	"graphHolder
		addEventHandler:
			(BlEventHandler
				on: BlDoubleClickEvent
				do: [ :evt | self hand addCard: Card new ])."	"Double-click"
	^ graphHolder
]

{ #category : #accessing }
HypernodeEditor >> for: aHypernode [
	self node: aHypernode
]

{ #category : #accessing }
HypernodeEditor >> initialize [
	super initialize.
	node := Hypernode new.
	self
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical matchParent ];
		padding: (BlInsets all: 5);
		margin: (BlInsets all: 5);
		layout: BlLinearLayout vertical.
	self
		addChildren:
			{self buildButtonBar.
			self buildGraphHolder}.
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
HypernodeEditor >> updateGraph [
	| newGraph oldGraph |
	oldGraph := theGraph.
	newGraph := self buildGraph.
	oldGraph ifNotNil: [ newGraph zoomTo: oldGraph zoomLevel ].
	graphHolder removeChildren.
	graphHolder addChild: newGraph
]
