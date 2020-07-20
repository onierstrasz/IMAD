"
I  provide a dedicated view for a Card Deck, or a subset of Cards in a Deck.
Eventually some of my parts should be factored out into separate Element classes.

I consist of a Header, a Tags pane, and a Graph pane.
"
Class {
	#name : #CardDeckElement,
	#superclass : #BlElement,
	#instVars : [
		'deck',
		'tags',
		'nameHolder',
		'graphHolder',
		'theGraph'
	],
	#category : #'IMAD-Cards-View'
}

{ #category : #accessing }
CardDeckElement >> addGraphButtonsTo: aButtonBar [
]

{ #category : #accessing }
CardDeckElement >> buildButtonBar [
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
CardDeckElement >> buildGraph [
	"I am the actual graph held by the graphHolder within the graphPane"
	theGraph := (CardGraphElement new forDeck: self deck)
		asPannableElement.
	^ theGraph
]

{ #category : #accessing }
CardDeckElement >> buildGraphPane [
	| graphPane buttonBar span |
	graphPane := BlElement new
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical matchParent ];
		padding: (BlInsets all: 5);
		margin: (BlInsets all: 5);
		border: (BlBorder paint: Color veryLightGray width: 1);
		layout: BlLinearLayout vertical;
		yourself.
	buttonBar := self buildButtonBar.
	graphHolder := BlElement new
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical matchParent ];
		padding: (BlInsets all: 5);
		margin: (BlInsets all: 5);
		layout: BlLinearLayout vertical;
		yourself.
	graphHolder
		viewModel: (BrInteractiveModel with: BrHoverModel new);
		look: (BrGlamorousWithContextMenuLook content: [ self contextMenu ]). "to capture right-click"
	graphHolder
		addEventHandler:
			(BlEventHandler
				on: BlDoubleClickEvent
				do: [ :evt | self deck addCard: Card new ]).
	graphPane
		addChildren:
			{buttonBar.
			graphHolder}.
	self updateGraph.
	^ graphPane
]

{ #category : #accessing }
CardDeckElement >> buildHeader [
	| header |
	header := BlElement new
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical fitContent ];
		padding: (BlInsets all: 5);
		"border: (BlBorder paint: Color blue width: 1);"
			layout: BlLinearLayout horizontal;
		yourself.
	nameHolder := BlElement new
		constraintsDo: [ :c | 
			c horizontal fitContent.
			c vertical fitContent ];
		layout: BlLinearLayout vertical;
		yourself.
	header addChild: nameHolder.
	header
		addChild:
			(BlElement new
				constraintsDo: [ :c | 
					c horizontal matchParent.
					c vertical matchParent ];
				yourself).
	header
		addChild:
			(BrButton new
				look: BrGlamorousButtonWithIconLook;
				icon: BrGlamorousVectorIcons inspect;
				label: 'Open inspector window';
				action: [ deck inspect ]).
	header addChild: self saveButton.
	self updateHeaderName.
	^ header
]

{ #category : #accessing }
CardDeckElement >> buildTags [
	tags := BlElement new
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical fitContent ];
		padding: (BlInsets all: 5);
		margin:
			(BlInsets
				top: 0
				right: 5
				bottom: 0
				left: 5);
		border: (BlBorder paint: Color veryLightGray width: 1);
		layout: BlLinearLayout vertical;
		yourself.
	self updateTags.
	^ tags
]

{ #category : #accessing }
CardDeckElement >> cards [
	<todo: 'Apply the filter to select just the cards for this view'>
	^ self deck cards
]

{ #category : #accessing }
CardDeckElement >> contextMenu [
	^ BrGlamorousSimpleContextMenuContent new
		items: {('Inspect deck' -> [ :e | deck inspect ])};
		yourself
]

{ #category : #accessing }
CardDeckElement >> deck [
	^ deck
]

{ #category : #accessing }
CardDeckElement >> deck: aCardDeck [
	self unsubscribe.
	deck := aCardDeck.
	self subscribe.
	self updateHeaderName.
	self updateGraph
]

{ #category : #accessing }
CardDeckElement >> directedCurvedEdge [
	<todo: 'Use this to build graphs?'>
	^ BlParabollaArcElement new
		zIndex: 0;
		curvatureFraction: 0.2;
		border: (BlBorder paint: Color gray width: 2);
		toHead:
			(BlArrowheadSimpleArrow new
				border:
					(BlBorder builder
						paint: Color gray;
						width: 2;
						build))
]

{ #category : #accessing }
CardDeckElement >> initialize [
	super initialize.
	deck := CardDeck new.
	self
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical matchParent ].
	self layout: BlLinearLayout vertical.
	self addChild: self buildHeader.
	self addChild: self buildTags.
	self addChild: self buildGraphPane.
	self subscribe
]

{ #category : #accessing }
CardDeckElement >> saveButton [
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
								label: 'Save to method ' , self deck storageClassMethod ]
						content: [ | dropdown |
							dropdown := BlElement new
								layout: BlLinearLayout vertical;
								constraintsDo: [ :c | 
									c padding: (BlInsets all: 5).
									c vertical fitContent.
									c horizontal fitContent ].
							(self deck classNamed: self deck storageClassName) isClass
								ifTrue: [ self deck saveState.
									dropdown
										addChild: (BlTextElement new text: ('Saved' asRopedText fontSize: 12)) ]
								ifFalse: [ dropdown addChild: self deck newClassDefinitionDialog ].
							dropdown ]);
		icon: BrGlamorousIcons save;
		label: 'Save to method ' , self deck storageClassMethod
]

{ #category : #accessing }
CardDeckElement >> subscribe [
	self deck announcer
		when: PropertiesUpdated
		do: [ self updateHeaderName ].
	self deck announcer when: CardsUpdated do: [ self updateGraph ].
	self deck announcer when: RelationsUpdated do: [ self updateGraph ]
]

{ #category : #accessing }
CardDeckElement >> unsubscribe [
	self deck announcer unsubscribe: self
]

{ #category : #accessing }
CardDeckElement >> updateGraph [
	| newGraph oldGraph |
	oldGraph := theGraph.
	newGraph := self buildGraph.
	oldGraph ifNotNil: [ newGraph zoomTo: oldGraph zoomLevel ].
	graphHolder removeChildren.
	graphHolder addChild: newGraph
]

{ #category : #accessing }
CardDeckElement >> updateHeaderName [
	nameHolder removeChildren.
	nameHolder addChild: self deck buildLabel
]

{ #category : #accessing }
CardDeckElement >> updateTags [
	tags removeChildren.
	tags
		addChild: (BlTextElement new text: ('Tags go here' asRopedText fontSize: 12))
]
