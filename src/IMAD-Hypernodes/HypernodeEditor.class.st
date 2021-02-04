"
!The Hypernode Editor

The ${class:name=HypernodeEditor}$ provides an interface for creating and editing ${class:name=Hypernode}$ graphs.

The editor provides various tabs to explore and edit a Hypernode and the nested graphs it contains.

The ''Live'' view allows to you edit the graph contained in a nested Hypernode.

''Double click'' on the background to add a node to the graph.
''Click drag'' on the background to reposition the graph.
''Right click'' on the background to bring up the context menu for the graph.

''Double click'' on a node to open a new editor for that node.
''Click-drag'' a node to reposition it.
''Right click'' on a node to bring up the context menu for the node.

The buttons allow you to zoom in and out, zoom to fit, zoom to actual size, refresh, and save the node and all its reachable nodes to a method of a class. The first time you will be prompted to enter the desired class name. 

''NB:'' If you change name of the generated method and save it, take care to also update the ==storageMethodName== property within the method, so the Hypernode will know where to save itself.


"
Class {
	#name : #HypernodeEditor,
	#superclass : #AbstractHypernodeElement,
	#instVars : [
		'node',
		'graphContainer',
		'graphHolder',
		'graph',
		'buttonBar',
		'nameHolder'
	],
	#category : #'IMAD-Hypernodes'
}

{ #category : #'instance creation' }
HypernodeEditor class >> for: aHypernode [
	^ self new
		for: aHypernode;
		yourself
]

{ #category : #gui }
HypernodeEditor >> buildButtonBar [
	buttonBar := BlElement new
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical fitContent ];
		layout: BlLinearLayout horizontal;
		padding: (BlInsets all: self defaultPadding);
		margin: (BlInsets all: self defaultMargin);
		yourself.
	nameHolder := BlElement new
		constraintsDo: [ :c | 
			c horizontal fitContent.
			c vertical fitContent ];
		layout: BlLinearLayout vertical;
		yourself.
	self updateHeaderName.
	buttonBar addChild: nameHolder.
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
	buttonBar addChild: self saveButton.
	buttonBar
		addChild:
			(BrButton new
				look: BrGlamorousButtonWithIconLook;
				icon: BrGlamorousIcons help;
				label: 'Refresh';
				action: [ self phlow spawnTool: (GtDocumenterTool forClass: HypernodeEditor) ]).
	^ buttonBar
]

{ #category : #debugging }
HypernodeEditor >> buildEditor [
	"run this when the node is assigned"

	self removeChildren.
	self
		addChildren:
			{self buildButtonBar.
			self buildGraphContainer}.
	self updateGraph
]

{ #category : #gui }
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
	^ graphContainer
]

{ #category : #debugging }
HypernodeEditor >> contextMenu [
	<todo: 'Add cascading menu for graph styles'>
	^ BrGlamorousSimpleContextMenuContent new
		items:
			{('Inspect self' -> [ self node inspect ]).
			('Select graph style' -> [ "not sure what goes here!" ]).
			('Toggle debug view' -> [ self toggleDebugMode ])};
		yourself
]

{ #category : #utility }
HypernodeEditor >> createClassNamed: aClass subclassOf: aSuperclass inPackage: aPackage [
	^ aSuperclass , ' subclass: #' , aClass
		,
			'
	instanceVariableNames: ''''
	classVariableNames: ''''
	package: ''' , aPackage , ''''
]

{ #category : #debugging }
HypernodeEditor >> debugOffActions [
	self border: (BlBorder paint: Color transparent width: 0).
	buttonBar border: (BlBorder paint: Color transparent).
	graphHolder border: (BlBorder paint: Color transparent).
	graphContainer border: (BlBorder paint: Color transparent).
	self graph
		background: Color transparent;
		effect: BlNullEffect new
]

{ #category : #gui }
HypernodeEditor >> debugOnActions [
	self border: (BlBorder paint: Color blue width: 1).
	buttonBar border: (BlBorder paint: Color orange).
	graphHolder border: (BlBorder paint: Color lightGray).
	graphContainer border: (BlBorder paint: Color orange).
	self graph
		background: Color white;
		effect: BrGlamorousShadowEffect new
]

{ #category : #storage }
HypernodeEditor >> defaultStoragePackage [
	^ 'IMAD-Hypernodes'
]

{ #category : #'instance creation' }
HypernodeEditor >> for: aHypernode [
	self assert: aHypernode root isNotNil.
	self node: aHypernode
]

{ #category : #accessing }
HypernodeEditor >> graph [
	^ graph
]

{ #category : #accessing }
HypernodeEditor >> graph: aHypernodeGraphElement [
	self assert: graph isNotNil.
	graph unsubscribe.
	graph := aHypernodeGraphElement.
	graphHolder contentElement: graph
]

{ #category : #gui }
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

{ #category : #initialization }
HypernodeEditor >> initialize [
	<todo: 'how to get the error message wrapped?'>
	super initialize.
	self
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical matchParent ];
		layout: BlLinearLayout vertical;
		padding: (BlInsets all: self defaultPadding);
		margin: (BlInsets all: self defaultMargin).
	self
		addChild:
			(BrEditor new
				beReadOnlyWithSelection;
				look: BrGlamorousRegularEditorLook new;
				text: (self missingNodeErrorString asRopedText foreground: Color red))
]

{ #category : #initialization }
HypernodeEditor >> missingNodeErrorString [
^ 'The node must not be nil. Be sure to instantiate the HypernodeEditor with "HypernodeEditor for: aNode".'
]

{ #category : #gui }
HypernodeEditor >> newClassDefinitionDialog [
	<todo: 'Add dialogue for method name as well.'>
	| container theSuperClass theClass thePackage |
	container := self newLinearLayout.
	theSuperClass := 'Object' asBrEditableLabel.
	self node ensureDefaultStorageClassMethod.
	theClass := self node storageClassName asBrEditableLabel.
	thePackage := self defaultStoragePackage asBrEditableLabel.
	^ container
		addChild:
			(BrLabel new
				look: BrGlamorousLabelLook new bold;
				text: 'Please edit and create the storage class first.');
		addChild:
			(self newLinearBoxedLayout
				addChild:
					(self newFlowElement
						addChildren:
							{theSuperClass.
							' subclass: #' asBrLabel.
							theClass});
				addChild: '	instanceVariableNames: ''''' asBrLabel;
				addChild: 'classVariableNames: ''''' asBrLabel;
				addChild:
					(self newFlowElement
						addChildren:
							{'package: ''' asBrLabel.
							thePackage.
							'''' asBrLabel}));
		addChild:
			(BrButton new
				look: BrGlamorousButtonWithLabelLook;
				label: 'Create class';
				action: [ :button | 
					self node storageClassName: theClass text asString.
					[ OpalCompiler new
						evaluate:
							(self
								createClassNamed: theClass text asString
								subclassOf: theSuperClass text asString
								inPackage: thePackage text asString).
					self node saveState.
					container removeChildren.
					container
						addChild: (BlTextElement new text: ('Saved' asRopedText fontSize: 12)).
					self spawnStoredMethodView ]
						on: Exception
						do: [ :e | self inform: e description ] ])
]

{ #category : #gui }
HypernodeEditor >> newFlowElement [
	^ BlElement new
		layout: BlFlowLayout horizontal;
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical fitContent ]
]

{ #category : #gui }
HypernodeEditor >> newLinearBoxedLayout [
	^ BlElement new
		layout: BlLinearLayout vertical;
		look: BrGlamorousInputFieldSpacingLook;
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical fitContent ]
]

{ #category : #gui }
HypernodeEditor >> newLinearLayout [
	^ BlElement new
		layout: BlLinearLayout vertical;
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical matchParent ]
]

{ #category : #accessing }
HypernodeEditor >> node [
	self assert: node isNotNil description: self missingNodeErrorString.
	^ node
]

{ #category : #accessing }
HypernodeEditor >> node: aHypernode [
	node ifNotNil: [ self unsubscribe ].
	node := aHypernode.
	self subscribe.
	self buildEditor
]

{ #category : #debugging }
HypernodeEditor >> nodeElements [
	"for debugging"

	^ self graph nodeElements
]

{ #category : #gui }
HypernodeEditor >> saveButton [
	"NB: Here we hard-wire the fact that we are saving the graph for the root node. Later we might want a save button for any arbitrary subnode and its reachable graph."

	^ BrButton new
		look:
			BrGlamorousButtonWithIconLook
				+
					(BrGlamorousWithDropdownLook
						handle: [ BrButton new
								look:
									BrGlamorousButtonWithIconLook - BrGlamorousWithLabelTooltipLook
										- BrGlamorousButtonExteriorLook;
								icon: BrGlamorousIcons save;
								label: 'Saved to ' , self node root storageClassMethod ]
						content: [ | dropdown |
							dropdown := BlElement new
								layout: BlLinearLayout vertical;
								constraintsDo: [ :c | 
									c padding: (BlInsets all: 5).
									c vertical fitContent.
									c horizontal fitContent ].
							self node root storageMethodDefined
								ifTrue: [ self node root saveState.
									self spawnStoredMethodView.
									dropdown
										addChild: (BlTextElement new text: ('Saved' asRopedText fontSize: 12)) ]
								ifFalse: [ dropdown addChild: self newClassDefinitionDialog ].
							dropdown ]);
		icon: BrGlamorousIcons save;
		label: 'Save to method ' , self node root storageClassMethod
]

{ #category : #storing }
HypernodeEditor >> spawnStoredMethodView [
	self phlow
		spawnTool:
			(GtMethodCoderTool
				compiledMethod:
					self node root storageClassName asClass
						>> self node root storageMethodName asSymbol)
]

{ #category : #announcements }
HypernodeEditor >> subscribe [
	self node announcer
		when: HNPropertiesUpdated
		do: [ self updateHeaderName ]
		for: self.
]

{ #category : #announcements }
HypernodeEditor >> unsubscribe [
	self node announcer unsubscribe: self.
]

{ #category : #announcements }
HypernodeEditor >> updateGraph [
	"Use this to build or rebuild the graph, not for incremental updates."

	self graph: (HypernodeGraphElement for: self node)
]

{ #category : #announcements }
HypernodeEditor >> updateHeaderName [
	nameHolder removeChildren.
	nameHolder addChild: self node buildLabel
]
