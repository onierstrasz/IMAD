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
		'graph',
		'buttonBar'
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
	buttonBar addChild: self saveButton.
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
	^ graphContainer
]

{ #category : #accessing }
HypernodeEditor >> contextMenu [
	^ BrGlamorousSimpleContextMenuContent new
		items:
			{('Inspect self' -> [ :e | self node inspect ]).
			('Reposition nodes' -> [ :e | self graph repositionNodes ]).
			('Toggle debug view' -> [ :e | self toggleDebugMode ])};
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

{ #category : #accessing }
HypernodeEditor >> debugOffActions [
	self border: (BlBorder paint: Color transparent width: 0).
	buttonBar isNotNil
		ifTrue: [ buttonBar border: (BlBorder paint: Color transparent) ].
	graphHolder isNotNil
		ifTrue: [ graphHolder border: (BlBorder paint: Color transparent) ].
	graphContainer isNotNil
		ifTrue: [ graphContainer border: (BlBorder paint: Color transparent) ].
	self graph isNotNil
		ifTrue: [ self graph
				background: Color transparent;
				effect: BlNullEffect new ]
]

{ #category : #accessing }
HypernodeEditor >> debugOnActions [
	self border: (BlBorder paint: Color blue width: 1).
	buttonBar isNotNil
		ifTrue: [ buttonBar border: (BlBorder paint: Color orange) ].
	graphHolder isNotNil
		ifTrue: [ graphHolder border: (BlBorder paint: Color lightGray) ].
	graphContainer isNotNil
		ifTrue: [ graphContainer border: (BlBorder paint: Color orange) ].
	self graph isNotNil
		ifTrue: [ self graph
				background: Color white;
				effect: BrGlamorousShadowEffect new ]
]

{ #category : #accessing }
HypernodeEditor >> defaultStoragePackage [
	^ 'IMAD-Hypernode'
]

{ #category : #accessing }
HypernodeEditor >> for: aHypernode [
	"self unsubscribe."

	self assert: aHypernode root isNotNil.
	self node: aHypernode


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
	node := Hypernode root.
	self
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical matchParent ];
		layout: BlLinearLayout vertical;
		padding: (BlInsets all: self defaultPadding);
		margin: (BlInsets all: self defaultMargin).
	self
		addChildren:
			{self buildButtonBar.
			self buildGraphContainer}.
	self updateGraph
]

{ #category : #accessing }
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

{ #category : #accessing }
HypernodeEditor >> newFlowElement [
	^ BlElement new
		layout: BlFlowLayout horizontal;
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical fitContent ]
]

{ #category : #accessing }
HypernodeEditor >> newLinearBoxedLayout [
	^ BlElement new
		layout: BlLinearLayout vertical;
		look: BrGlamorousInputFieldSpacingLook;
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical fitContent ]
]

{ #category : #accessing }
HypernodeEditor >> newLinearLayout [
	^ BlElement new
		layout: BlLinearLayout vertical;
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical matchParent ]
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
HypernodeEditor >> saveButton [
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
								label: 'Saved to ' , self node storageClassMethod ]
						content: [ | dropdown |
							dropdown := BlElement new
								layout: BlLinearLayout vertical;
								constraintsDo: [ :c | 
									c padding: (BlInsets all: 5).
									c vertical fitContent.
									c horizontal fitContent ].
							self node storageMethodDefined
								ifTrue: [ self node saveState.
									self phlow spawnObject: self node storageClassName asClass.
									dropdown
										addChild: (BlTextElement new text: ('Saved' asRopedText fontSize: 12)) ]
								ifFalse: [ dropdown addChild: self newClassDefinitionDialog ].
							dropdown ]);
		icon: BrGlamorousIcons save;
		label: 'Save to method ' , self node storageClassMethod
]

{ #category : #accessing }
HypernodeEditor >> spawnStoredMethodView [
	self phlow
		spawnTool:
			(GtMethodCoderTool
				compiledMethod:
					self node storageClassName asClass
						>> self node storageMethodName asSymbol)
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
