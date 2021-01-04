"
Some random examples, not necessarily tests.

The ${method:name=HypernodeExamples>>#editorScript}$ method contains a script that summarizes all the key interactions, but without the underlying model. This is intended to be used for demo and debugging purposes.

"
Class {
	#name : #HypernodeExamples,
	#superclass : #Object,
	#category : #'IMAD-Hypernodes-IMAD-Hypernodes'
}

{ #category : #accessing }
HypernodeExamples >> editorScript [
"This example will also run as a Playground snippet.
The purpose is to demonstrate all the GUI events and interactions without the scaffolding of the underlying model or the dedicated classed.
This makes it easier to debug the definitions of the event handlers."

<gtExample>
<todo: '
- add zoom buttons
- highlight node when hovering over it
- create edges
- zoom and pan
- editor context menu
'>

| padding margin editor graph buttonBar makeNode |

"graph editor example"

padding := 5.
margin := padding.

"The editor is the root element. It holds the graph and eventually some gui buttons."
editor := BlElement new.
editor
	constraintsDo: [ :c | 
		c horizontal matchParent.
		c vertical matchParent ];
	padding: (BlInsets all: padding); "on the inside"
	margin: (BlInsets all: margin); "on the outside"
	layout: BlLinearLayout vertical.
editor border: (BlBorder paint: Color blue width: 1).

"The graph element holds the actual graph nodes and edges"
graph := BlElement new asPannableElement.
graph
	constraintsDo: [ :c | 
		c horizontal matchParent.
		c vertical matchParent ];
	padding: (BlInsets all: padding);
	margin: (BlInsets all: margin);
	layout: BlLinearLayout vertical.
graph border: (BlBorder paint: Color red width: 1).
graph layout:BlBasicLayout new.
graph clipChildren: false.

buttonBar := BlElement new.
buttonBar
	constraintsDo: [ :c | 
		c horizontal matchParent.
		c vertical fitContent ];
	padding: (BlInsets all: padding);
	margin: (BlInsets all: margin);
	layout: BlLinearLayout horizontal.
buttonBar border: (BlBorder paint: Color orange width: 1).
"NB: Zooming is not working"
buttonBar
	addChild:
		(BrButton new
			look: BrGlamorousButtonWithIconLook;
			icon: BrGlamorousIcons zoomin;
			label: 'Zoom In';
			action: [ graph zoomIn ]).
buttonBar
	addChild:
		(BrButton new
			look: BrGlamorousButtonWithIconLook;
			icon: BrGlamorousIcons zoomout;
			label: 'Zoom Out';
			action: [ graph zoomOut ]).
buttonBar
	addChild:
		(BrButton new
			look: BrGlamorousButtonWithIconLook;
			icon: BrGlamorousIcons zoomtofit;
			label: 'Fit';
			action: [ graph zoomToFit ]).
buttonBar
	addChild:
		(BrButton new
			look: BrGlamorousButtonWithIconLook;
			icon: BrGlamorousIcons actualsize;
			label: 'Resize';
			action: [ graph zoomToActualSize ]).
buttonBar
	addChild:
		(BrButton new
			look: BrGlamorousButtonWithIconLook;
			icon: BrGlamorousVectorIcons refresh;
			label: 'Refresh';
			action: [ graph forceLayout "self updateGraph" ]).

editor addChild: buttonBar.
editor addChild: graph.

"A constructor block in lieu of a method."
makeNode := 	[ | node |
	node := BlElement new.
	node 
		layout: BlFrameLayout new;
		geometry: (BlRectangle cornerRadius: 4);
		border: (BlBorder paint: Color black width: 1);
		background: Color white;
		constraintsDo: [ :c | 
			c horizontal fitContent.
			c vertical fitContent ];
		padding: (BlInsets all: 5).
	node graph beNode.
	node addEventHandler: HypernodePullHandler new.
	node
		addEventHandler:
			(BlEventHandler
				on: BlDoubleClickEvent
				do: [ :evt | 
					evt consumed: true.	"So the container does not also react."
					node phlow spawnObject: node ]).
	node ].

graph addEventHandler:
	(BlEventHandler
		on: BlDoubleClickEvent
		do: [ :evt | | newNode |
			newNode := makeNode value.
			graph addChild: newNode.
			newNode relocate: (graph globalPointToLocal: evt position)]).

editor.

^ editor

]
