"
I represent the controller for a GraphView of a Graph.

I get invoked in GraphView>>#viewFor:

I gather mouse click events from the GraphView and perform different actions:
	- on right click open the menu for adding new graph elements -> GraphController>>#openScondaryMenuWith:
	- on left click on graph elements open the menu for editing graph elements -> GraphController>>#openNodeMenuFor: and GraphController>>#openEdgeMenuFor:
	- on left click on nodes (if execution mode is on) request a transition -> GraphController>>#onClick:
I color the states of the FSA as follows:
	- current state green; red, if FSA is dead
	- possible successor states orange
I color the enabled transitions green and the rest red.
I update the view if the model accepts the requested transition:
	- update state colors (FSA)
	- update transition colors (Petri Net)
	- update number of tokens (Petri Net)
I export a GraphView as code and add it to the Graph as an example method, see GraphController>>#createGraphExample

	
Bug report (node deletion):

To reproduce the bug, inspect the following example and switch to _GT tab.
Deleting node 3 (left click -> Delete node) will cause an error. 

	Graph new nodeDeletionBug 

Expected behavior: node 3 and all connected edges disappear
Actual behavior: NotFound exception ...

invoked methods:
	- GraphController>>#deleteNode:
	- GraphController>>#deleteEdge:
"
Class {
	#name : #EGMGraphController,
	#superclass : #Object,
	#instVars : [
		'graph',
		'view',
		'selectedNode',
		'executable'
	],
	#category : #'IMAD-EGM'
}

{ #category : #'model interaction' }
EGMGraphController >> addEdge: aNodeElement [
	| node |

	node := aNodeElement graph model.
	
	graph debug: aNodeElement graph.
	
	(graph selectedNode > 0)
		ifTrue: [
			| anEdge |
			anEdge := graph addEdgeFrom: graph selectedNode to: node.
			
			anEdge ~= 0 ifTrue: [
				| anEdgeElement |
				anEdgeElement := view drawEdge: anEdge.
				view addWeightTo: anEdgeElement with: (graph weights at: anEdge)
				 ].
			
			graph selectedNode: 0.
			selectedNode background: Color white.
			self update: graph.
			]
		ifFalse: [
			graph selectedNode: node.
			aNodeElement background: Color blue.
			selectedNode := aNodeElement.
			].
]

{ #category : #'api - adding' }
EGMGraphController >> addNodeAt: mousePosition [
	self view drawNodes: (self graph addNode) asOrderedCollection.
	self relocateLastNode: mousePosition
]

{ #category : #'api - adding' }
EGMGraphController >> addPlaceAt: mousePosition [
	self view drawPlaces: (self graph addPlace) asOrderedCollection with: self graph tokens.
	self relocateLastNode: mousePosition



]

{ #category : #'api - adding' }
EGMGraphController >> addTransitionAt: mousePosition [
	self view drawTransitions: (self graph addTransition) asOrderedCollection.
	self relocateLastNode: mousePosition

]

{ #category : #'model interaction' }
EGMGraphController >> clearAllStates [
	view allNodeElements do: [ :eachNodeElement | eachNodeElement background: Color white ]
]

{ #category : #'model interaction' }
EGMGraphController >> createGraphExample [
	| aMethodName|
	aMethodName := (UIManager default request: 'Set method name:').
	EGMGraph compile: (self exportGraph: aMethodName).
]

{ #category : #'view control' }
EGMGraphController >> deadColor [
	^ Color red
]

{ #category : #'api - deleting' }
EGMGraphController >> deleteEdge: anEdgeElement [
	| aGtGraphEdge |
	
	aGtGraphEdge := anEdgeElement graph model.
	
	graph deleteEdge: (aGtGraphEdge fromElement graph model -> aGtGraphEdge toElement graph model).
	
	aGtGraphEdge fromElement constraints graph removeConnectedEdge: aGtGraphEdge.
	aGtGraphEdge toElement constraints graph removeConnectedEdge: aGtGraphEdge.
	
	anEdgeElement removeFromParent
]

{ #category : #'api - deleting' }
EGMGraphController >> deleteNode: aNodeElement [
	"I also delete all connected edges of the given node element"
	graph deleteNode: aNodeElement graph model.
	
	aNodeElement graph connectedEdges
		do: [ :eachGtGraphEdge | self deleteEdge: (view findEdgeElementFor: eachGtGraphEdge) ].
	
	aNodeElement removeFromParent
]

{ #category : #accessing }
EGMGraphController >> executable [
	^ executable
]

{ #category : #accessing }
EGMGraphController >> executable: anObject [
	executable := anObject
]

{ #category : #'model interaction' }
EGMGraphController >> exportGraph: aMethodName [
	| exportString orderedCollection orderedDictionary |
	orderedCollection := ' asOrderedCollection.'.
	orderedDictionary := ' asOrderedDictionary.'.
	exportString := ''.
	
	exportString := aMethodName, String cr.
	exportString := exportString, '<gtExample>', String cr.
	exportString := exportString, 'self nodes: ', (graph nodes asArray) asString, orderedCollection,String cr.
	exportString := exportString, 'self places: ', (graph places asArray) asString, orderedCollection,String cr.
	exportString := exportString, 'self transitions: ', (graph transitions asArray) asString, orderedCollection,String cr.
	exportString := exportString, 'self edges: ', (graph edges asArray) asString, orderedCollection,String cr.
	exportString := exportString, 'self currentState: ', (graph currentState) asString,'.',String cr.
	
	exportString := exportString, 'self weights: ',
	'{',((graph weights associations collect: [ :element |
		'(',element key asString,')', '->', element value asString ])
	joinUsing: '.'),'}',
	orderedDictionary,String cr.
	
	exportString := exportString, 'self tokens: ',
	'{',((graph tokens associations collect: [ :element |
		' ', element key asString, '->', element value asString ])
	joinUsing: '.'),'}',
	orderedDictionary,String cr.
	
	exportString := exportString, 'self nodeLocations: ',
	'{',((view allNodeElements collect: [ :eachNodeElement |
		' ', eachNodeElement graph model asString, '->', eachNodeElement measuredBounds position asString ])
	joinUsing: '.'),'}',
	orderedDictionary,String cr.
	
	exportString := exportString, 'self nodeSizes: ',
	'{',((view allNodeElements collect: [ :eachNodeElement |
		' ', eachNodeElement graph model asString, '->', eachNodeElement size asString ])
	joinUsing: '.'),'}',
	orderedDictionary,String cr.
	
	exportString := exportString, 'self edgeCurvatures: ',
	'{',((view allEdgeElements collect: [ :eachEdgeElement |
		'(',(view edgeElementToAssociation: eachEdgeElement) asString,')', '->', eachEdgeElement curvatureAnchor curvatureFraction asString ])
	joinUsing: '.'),'}',
	orderedDictionary,String cr.
		
	^ exportString 
]

{ #category : #utilities }
EGMGraphController >> fireTransition: aTransition [
	| node |
	node := aTransition graph model.
	
	graph fireTransition: node.
	
	(graph predecessorOf: node) do:
		[ :eachPredecessor |
		self view updateTokens: (graph tokens at: eachPredecessor) at: (self view findNodeElementFor: eachPredecessor) ].
	
	(graph successorOf: node) do:
		[ :eachSuccessor |
		self view updateTokens: (graph tokens at: eachSuccessor) at: (self view findNodeElementFor: eachSuccessor) ].
	
	self markTransitions.
]

{ #category : #accessing }
EGMGraphController >> graph [
	^ graph
]

{ #category : #accessing }
EGMGraphController >> graph: anObject [
	graph := anObject
]

{ #category : #initialization }
EGMGraphController >> initializeModel: aGraph andView: aView [
	graph := aGraph.
	view := aView.
	executable := false.
		
	view when: BlMouseDownEvent do: [ :event |
		event secondaryButtonPressed ifTrue: [ self openSecondaryMenuWith: event localPosition ].].
	
	view addEventHandlerOn: BlClickEvent do: [ :event |
		event primaryButtonPressed ifTrue: [
			| aGraphElement |
			aGraphElement := event target.
			(aGraphElement parent graph isNode or: aGraphElement parent graph isEdge)
			ifTrue: [ aGraphElement := aGraphElement parent ].
			
			aGraphElement graph isNode
			ifTrue: [ self executable
				ifTrue: [ self onClick: aGraphElement ]
				ifFalse: [ self openNodeMenuFor: aGraphElement ]].
			
			aGraphElement graph isEdge
			ifTrue: [ self executable
				ifFalse: [ self openEdgeMenuFor: aGraphElement ]]]].
	
	self update: graph.
]

{ #category : #'view control' }
EGMGraphController >> liveColor [
	^ (Color green darker alpha: 1)
]

{ #category : #'model interaction' }
EGMGraphController >> markSuccessorStates [
	| successors |
	successors := self graph successorOf: self graph currentState.
	
	view allNodeElements
		select: [ :node | successors includes: node graph model ]
		thenDo: [ :node | node background: Color orange ]
]

{ #category : #'model interaction' }
EGMGraphController >> markTransitions [
	| transitions |
	transitions := self graph transitions.
	
	view allNodeElements
		select: [ :node | transitions includes: node graph model ]
		thenDo: [ :node |
			(graph isEnabled: node graph model)
				ifTrue: [ node background: self liveColor ]
				ifFalse: [ node background: self deadColor ]
			 ]
]

{ #category : #'model interaction' }
EGMGraphController >> nodeColor [
	(self graph successorOf: self graph currentState) isEmpty
		ifTrue: [ ^self deadColor ]
		ifFalse: [ ^self liveColor ]
		
]

{ #category : #gui }
EGMGraphController >> onClick: aNodeElement [
	| node |
	node := aNodeElement graph model.
	((graph successorOf: graph currentState) includes: node)
		ifTrue: [ graph currentState: node.].
		
	(graph isEnabled: node) ifTrue:[
		self fireTransition: aNodeElement
		].
]

{ #category : #gui }
EGMGraphController >> openEdgeMenuFor: anEdge [
	| menu |
	menu := MenuMorph new defaultTarget: self.
	menu add: 'Set weight' selector: #setWeightOf: argument: anEdge.
	menu add: 'Transform to curved' selector: #transformToCurved: argument: anEdge.
	menu add: 'Delete edge' selector: #deleteEdge: argument: anEdge.
	menu popUpInWorld
]

{ #category : #gui }
EGMGraphController >> openNodeMenuFor: aNode [
	| menu node |
	node := aNode graph model.
	menu := MenuMorph new defaultTarget: self .
	menu add: 'Add edge from current selected node' selector: #addEdge: argument: aNode.
	((graph places includes: node) or: (graph transitions includes: node))
	ifFalse: [ 
		menu add: 'Set as initial state' selector: #setInitialState: argument: aNode
		 ].
	(graph places includes: node)
	ifTrue:[
		menu add: 'Set number of tokens' selector: #setNumberOfTokensAt: argument: aNode
		].
	(graph transitions includes: node)
	ifTrue:[
		menu add: 'Rotate' selector: #rotateTransition: argument: aNode.
		].
	menu add: 'Delete node' selector: #deleteNode: argument: aNode.
	
	menu popUpInWorld
	
]

{ #category : #gui }
EGMGraphController >> openSecondaryMenuWith: mousePosition [
	| menu |
	menu := MenuMorph new defaultTarget: self .
	menu add: 'Add new node' selector: #addNodeAt: argument: mousePosition.
	menu add: 'Add new transition' selector: #addTransitionAt: argument: mousePosition.
	menu add: 'Add new place' selector: #addPlaceAt: argument: mousePosition.
	menu add: 'Print graph' selector: #printGraph.
	menu add: 'Create graph example' selector: #createGraphExample.
	executable
		ifTrue: [ menu add: 'Switch to graph editor' selector: #executable: argument:false.]
		ifFalse: [ menu add: 'Switch to execution mode' selector: #executable: argument:true.].
	menu popUpInWorld
]

{ #category : #'model interaction' }
EGMGraphController >> printGraph [
	Transcript show: (self exportGraph: 'none')
]

{ #category : #'api - adding' }
EGMGraphController >> relocateLastNode: mousePosition [
	| blNode |

	blNode := (view children last).
	blNode relocate: (mousePosition) - (view defaultNodeSize / 2).

	^ blNode

]

{ #category : #'api - adding' }
EGMGraphController >> rotateTransition: aTransitionElement [
	aTransitionElement size: (aTransitionElement size) y @ (aTransitionElement size) x
]

{ #category : #'model interaction' }
EGMGraphController >> setCurrentStateColor [
	| aCurrentStateNodeElement |

	aCurrentStateNodeElement := view findNodeElementFor: graph currentState.
	aCurrentStateNodeElement ifNotNil: [
		aCurrentStateNodeElement background: self nodeColor
	 ]
]

{ #category : #'model interaction' }
EGMGraphController >> setInitialState: aNode [
	graph currentState: aNode graph model.
]

{ #category : #'api - adding' }
EGMGraphController >> setNumberOfTokensAt: aNode [
	| node numberOfTokens|
	node := aNode graph model.
	
	numberOfTokens := (UIManager default request: 'Set number of tokens:') asInteger.
	numberOfTokens ifNotNil: [ 
		self view updateTokens: (graph tokens at: node put: numberOfTokens ) at: aNode
		].
	
	self markTransitions
]

{ #category : #'api - adding' }
EGMGraphController >> setWeightOf: anEdgeElement [
	| fromNode toNode newWeight |
	fromNode := (anEdgeElement graph model fromElement) graph model.
	toNode := (anEdgeElement graph model toElement) graph model.
	
	graph weights at: (fromNode->toNode) ifPresent: [
		newWeight := (UIManager default request: 'Set new weight:') asInteger.
		newWeight ifNotNil: [ 
			graph weights at: (fromNode->toNode) put: newWeight.
			view updateWeightOf: anEdgeElement with: (graph weights at: (fromNode->toNode))
			 ]
		].

	self markTransitions.

]

{ #category : #'api - adding' }
EGMGraphController >> transformToCurved: anEdgeElement [
	anEdgeElement curvatureFraction: view defaultCurvatureFraction.

]

{ #category : #updating }
EGMGraphController >> update: aGraph [
	self clearAllStates.
	self markSuccessorStates.
	self setCurrentStateColor.
	self markTransitions.
]

{ #category : #accessing }
EGMGraphController >> view [
	^ view
]

{ #category : #accessing }
EGMGraphController >> view: anObject [
	view := anObject
]
