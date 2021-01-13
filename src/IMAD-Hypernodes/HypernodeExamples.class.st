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
"This example will also run as a Playground snippet. (Just delete everything up to and including the variable declarations.)
The purpose is to demonstrate all the GUI events and interactions without the scaffolding of the underlying model or the dedicated classed.
This makes it easier to debug the definitions of the event handlers."

<gtExample>
<todo: '
- Fix zoom to actual size -- should center the graph
See also: https://github.com/onierstrasz/IMAD/issues/39
'>

| padding margin editor graph buttonBar makeNode graphHolder pannableGraph |

"--- TO RUN IN PLAYGROUND, DELETE FROM HERE TO TOP ---"
"graph editor example
- double click to create a node
- click and drag to move it
- double click node to inspect
- drag the background to pan
- zoom buttons only work partially"

padding := 2.
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
graph := BlElement new.
graph
	layout: (BlWrapAroundChildrenLayout new addLayout: BlBasicNodeBasedLayout new);
	constraintsDo: [ :c | 
		c horizontal fitContent.
		c vertical fitContent ];
	padding: (BlInsets all: padding);
	margin: (BlInsets all: margin);
	background: Color white;
    effect: BrGlamorousShadowEffect new.

graphHolder := BlPinchableElement new
	 zoomLevel: 2;
	 clipChildren: false;
	 contentElement: graph;
	 border: (BlBorder paint: Color red).

pannableGraph := graphHolder asPannableElement
	border: (BlBorder paint: Color orange);
	padding: (BlInsets all: padding);
	margin: (BlInsets all: margin);
	when: BlDoubleClickEvent
	do: [ :evt | | newNode |
    	newNode := makeNode asElement.
    	graph addChild: newNode.
   	 newNode relocate: (graphHolder globalPointToLocal: evt position) ].

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
			action: [ pannableGraph zoomIn ]).
buttonBar
	addChild:
		(BrButton new
			look: BrGlamorousButtonWithIconLook;
			icon: BrGlamorousIcons zoomout;
			label: 'Zoom Out';
			action: [ pannableGraph zoomOut ]).
buttonBar
	addChild:
		(BrButton new
			look: BrGlamorousButtonWithIconLook;
			icon: BrGlamorousIcons zoomtofit;
			label: 'Fit';
			action: [ pannableGraph zoomToFit ]).
buttonBar
	addChild:
		(BrButton new
			look: BrGlamorousButtonWithIconLook;
			icon: BrGlamorousIcons actualsize;
			label: 'Resize';
			action: [ pannableGraph zoomToActualSize ]).

editor addChild: buttonBar.
editor addChild: pannableGraph.

"A constructor block in lieu of a method."
makeNode := 	[ | node |
	node := BlElement new.
	node 
		layout: BlFrameLayout new;
		geometry: (BlRectangle cornerRadius: 4);
		background: Color white;
		constraintsDo: [ :c | 
			c horizontal fitContent.
			c vertical fitContent ];
		padding: (BlInsets all: 10).
	node graph beNode.
	node
		viewModel: (BrInteractiveModel with: BrHoverModel new);
		look:
			(BrInteractiveCommonLook new
				default: [ :elt | elt border: (BlBorder paint: Color black width: 2) ];
				hovered: [ :elt | elt border: (BlBorder paint: Color red width: 2) ])
			+ ((BrGlamorousWithContextMenuLook content: [ 
				BrGlamorousSimpleContextMenuContent new
					items: { ( 'Inspect node' -> [ node inspect ] ) };
					yourself ])
				useSecondaryMouseButton ;
				yourself).
	node addEventHandler:BlPullHandler new.
	node
		addEventHandler:
			(BlEventHandler
				on: BlDoubleClickEvent
				do: [ :evt | 
					evt consumed: true.
					node phlow spawnObject: node ]).
	node ] asStencil.

pannableGraph
		viewModel: (BrInteractiveModel with: BrHoverModel new);
		look: (BrGlamorousWithContextMenuLook content: [
			BrGlamorousSimpleContextMenuContent new
				items: { ( 'Inspect graph' -> [ graph inspect ] ) };
				yourself ]).


^ editor
]

{ #category : #accessing }
HypernodeExamples >> pinchableDemo [
<gtExample>
"Example by Aliaksei Syrel. Shows how bounds of parent element can automatically adjust to its children. Double-click on background to add children."
| makeNode graph graphHolder pannable |

"A constructor stencil"
makeNode := [ | node |
  node := BlElement new
    geometry: (BlRectangle cornerRadius: 4);
    border: (BlBorder paint: Color black width: 2);
    background: Color white;
    size: 20@20;
    addEventHandler: BlPullHandler new ] asStencil.
"The graph element holds the actual graph nodes and edges"
graph := BlElement new
  layout: (BlWrapAroundChildrenLayout new addLayout: BlBasicNodeBasedLayout new);
  constraintsDo: [ :c | 
    c horizontal fitContent.
      c vertical fitContent ];
      background: Color white;
      effect: BrGlamorousShadowEffect new.
graphHolder := BlPinchableElement new
  zoomLevel: 2;
  clipChildren: false;
  contentElement: graph;
  border: (BlBorder paint: Color black).
pannable := graphHolder asPannableElement
  background: Color veryLightGray;
  when: BlDoubleClickEvent
  do: [ :evt | | newNode |
    newNode := makeNode asElement.
    graph addChild: newNode.
    newNode relocate: (graphHolder globalPointToLocal: evt position) ].

^ pannable
]
