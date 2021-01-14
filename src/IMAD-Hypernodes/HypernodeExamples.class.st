"
Some random examples, not necessarily tests.

The ${method:name=HypernodeExamples>>#editorScript}$ method contains a script that summarizes all the key interactions, but without the underlying model. This is intended to be used for demo and debugging purposes.
The ==editorScript== example illustrates how a ==Hypernode== graph editor is constructed from nested Bloc elements to support interactive creation of graphs. The example is written as a flat script so one can easily see all the GUI components and how they interact, without the underlying model classes.

In the example, each element has a colored border or shading to make it stand out.

The """"editor"""" (blue border) is the root element. It holds a """"buttonBar"""" and a """"graphContainer"""" (orange borders). The graphContainer contains the (pinchable) """"graphHolder"""" (light gray border), which holds the """"graph"""" (white with shading).

The """"graph"""" (shaded white element) is a plain ==BlElement== with a ==BlWrapAroundChildrenLayout== layout and ==fitContent== constraints. It will automatically adapt its size to its children as they are added.

The """"graphHolder"""" (gray) is an instance of ==BlPinchableElement==. This is similar to a zoomable element, except that its layout bounds are not affected by zoom operations. We actually don't care about its border.

The """"graphContainer"""" (orange) is a ==BlPannableElement== created by sending ==asPannableElement== to the graphHolder. It supports panning and handles the background events for the graph (context menu and node creation), since its (fixed) border defines the area where we want to capture mouse events.

The """"editor"""" (blue) is a plain BlElement with ==matchParent== constraints and a vertical linear layout (==BlLinearLayout vertical==).

The """"buttonBar"""" (also orange), contains buttons that send zoom messages to the graphContainer.

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

| padding margin editor graph buttonBar makeNode graphHolder graphContainer |

"--- TO RUN IN PLAYGROUND, DELETE FROM HERE TO TOP ---"


"graph editor example. This demo only builds a view without an underlying model, just to show in a script how to compose the key UI elements. See the IMAD Hypernode package for the implementation in terms of model and view classes instead of as a script. Each element has a border or shading to make its bounds visible.
- double click to create a node
- click and drag to move it
- double click node to inspect
- drag the background to pan
- control-click node or background to open a context menu
- zoom buttons only work partially"

padding := 2.
margin := padding.

"The editor (blue border) is the root element. It holds a buttonBar and a graphContainer (orange borders). The graphContainer contains the (pinchable) graphHolder (light gray border), which holds the graph (white with shading)."
editor := BlElement new.
editor
	constraintsDo: [ :c | 
		c horizontal matchParent.
		c vertical matchParent ];
	padding: (BlInsets all: padding); "on the inside"
	margin: (BlInsets all: margin); "on the outside"
	layout: BlLinearLayout vertical.
editor border: (BlBorder paint: Color blue width: 1).

"The graph element (white with shading) holds the actual graph nodes. It adapts its size to its children with a BlWrapAroundChildrenLayout layout."
graph := BlElement new.
graph
	layout: (BlWrapAroundChildrenLayout new 
		addLayout: BlBasicNodeBasedLayout new);
	constraintsDo: [ :c | 
		c horizontal fitContent.
		c vertical fitContent ];
	padding: (BlInsets all: padding);
	margin: (BlInsets all: margin).
graph
	background: Color white;
    effect: BrGlamorousShadowEffect new.

"The graphHolder (gray border) is a pinchable container for the graph. See BlPinchableElement. Note that the graph it contains may overlap its own border, so we don't care about the gray border when zooming or resizing."
graphHolder := BlPinchableElement new
	 zoomLevel: 2;
	 clipChildren: false;
	 contentElement: graph;
	 border: (BlBorder paint: Color lightGray).

"The graphContainer (orange border) supports panning and handles the background events for the graph (context menu and node creation)."
graphContainer := graphHolder asPannableElement
	border: (BlBorder paint: Color orange);
	padding: (BlInsets all: padding);
	margin: (BlInsets all: margin).
graphContainer
	when: BlDoubleClickEvent
	do: [ :evt | | newNode |
    	newNode := makeNode asElement.
    	graph addChild: newNode.
   	 newNode relocate: (graphHolder globalPointToLocal: evt position) ].

graphContainer
		viewModel: (BrInteractiveModel with: BrHoverModel new);
		look: (BrGlamorousWithContextMenuLook content: [
			BrGlamorousSimpleContextMenuContent new
				items: { ( 'Inspect graph' -> [ graph inspect ] ) };
				yourself ]).

buttonBar := BlElement new.
buttonBar
	constraintsDo: [ :c | 
		c horizontal matchParent.
		c vertical fitContent ];
	padding: (BlInsets all: padding);
	margin: (BlInsets all: margin);
	layout: BlLinearLayout horizontal.
buttonBar border: (BlBorder paint: Color orange width: 1).
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

editor addChild: buttonBar.
editor addChild: graphContainer.

"A constructor stencil in lieu of a method. Note that we use a stencil instead of just a block so we can have a live view of it."
makeNode := [ | node |
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
			(BrStyleCommonLook  new
				default: [ :aStyle | aStyle border: (BlBorder paint: Color black width: 1) ];
				hovered: [ :aStyle | aStyle border: (BlBorder paint: Color red width: 1) ])
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
