"
I  provide a dedicated view for a Card Deck, or a subset of Cards in a Deck.
Eventually some of my parts should be factored out into separate Element classes.

I consist of a Header, a Tags pane, and a Graph pane.
"
Class {
	#name : #CardHandGUI,
	#superclass : #BlElement,
	#instVars : [
		'nameHolder',
		'graphHolder',
		'theGraph',
		'style',
		'tagPane',
		'hand'
	],
	#category : #'IMAD-Cards-View'
}

{ #category : #accessing }
CardHandGUI >> buildButtonBar [
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
CardHandGUI >> buildGraph [
	"I am the actual graph held by the graphHolder within the graphPane"
	self hand filter: self tagPane filter.
	theGraph := (CardHandGraphView new
		forHand: self hand) asPannableElement.
	theGraph zoomableElement clipChildren: false.
	^ theGraph
]

{ #category : #accessing }
CardHandGUI >> buildGraphHolder [
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
	graphHolder
		viewModel: (BrInteractiveModel with: BrHoverModel new);
		look: (BrGlamorousWithContextMenuLook content: [ self contextMenu ]).	"right-click"
	graphHolder
		addEventHandler:
			(BlEventHandler
				on: BlDoubleClickEvent
				do: [ :evt | self hand addCard: Card new ]).	"Double-click"
	^ graphHolder
]

{ #category : #accessing }
CardHandGUI >> buildGraphPane [
	| graphPane |
	graphPane := BlElement new
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical matchParent ];
		padding: (BlInsets all: 5);
		margin: (BlInsets all: 5);
		border: (BlBorder paint: Color veryLightGray width: 1);
		layout: BlLinearLayout vertical;
		yourself.
	graphPane
		addChildren:
			{self buildButtonBar.
			self buildGraphHolder}.
	self updateGraph.
	^ graphPane
]

{ #category : #accessing }
CardHandGUI >> buildGuiHeaderPane [
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
				action: [ hand inspect ]).
	header addChild: self saveButton.
	self updateHeaderName.
	^ header
]

{ #category : #accessing }
CardHandGUI >> cards [
	^ self hand cards
]

{ #category : #accessing }
CardHandGUI >> contextMenu [
	^ BrGlamorousSimpleContextMenuContent new
		items: {('Inspect deck' -> [ :e | self deck inspect ])};
		yourself
]

{ #category : #accessing }
CardHandGUI >> deck [
	^ self hand deck
]

{ #category : #accessing }
CardHandGUI >> deck: aCardDeck [
	self hand: (CardHand new deck: aCardDeck; yourself).
]

{ #category : #accessing }
CardHandGUI >> hand [
	"Need the hand for the current filter so new cards will match the filter (i.e., be included in the hand)"

	^ hand
]

{ #category : #accessing }
CardHandGUI >> hand: aCardHand [
	self unsubscribe.
	hand := aCardHand.
	self subscribe.
	self updateHeaderName.
	self tagPane updateTagFilterButtonsForDeck: self deck.
	self updateGraph
]

{ #category : #accessing }
CardHandGUI >> initialize [
	super initialize.
	hand := CardHand new.
	style := CardGraphStyle new mindmapStyle.
	self
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical matchParent ].
	self layout: BlLinearLayout vertical.
	self addChild: self buildGuiHeaderPane.
	tagPane := TagFilterPane new.
	self addChild: self tagPane.
	self addChild: self buildGraphPane.
	self subscribe
]

{ #category : #accessing }
CardHandGUI >> saveButton [
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
CardHandGUI >> subscribe [
	self deck announcer
		when: PropertiesUpdated
		do: [ self updateHeaderName ]
		for: self.
	self deck announcer
		when: TagsUpdated
		do: [ tagPane updateTagFilterButtonsForDeck: self deck ]
		for: self.
	self deck announcer
		when: CardsUpdated
		do: [ self updateGraph ]
		for: self.
	self deck announcer
		when: RelationsUpdated
		do: [ self updateGraph ]
		for: self.
	self tagPane announcer
		when: TagFilterUpdated
		do: [ self updateGraph ]
		for: self
]

{ #category : #accessing }
CardHandGUI >> tagPane [
	^ tagPane
]

{ #category : #accessing }
CardHandGUI >> unsubscribe [
	self deck announcer unsubscribe: self.
	self tagPane announcer unsubscribe: self.
]

{ #category : #accessing }
CardHandGUI >> updateGraph [
	| newGraph oldGraph |
	oldGraph := theGraph.
	newGraph := self buildGraph.
	oldGraph ifNotNil: [ newGraph zoomTo: oldGraph zoomLevel ].
	graphHolder removeChildren.
	graphHolder addChild: newGraph
]

{ #category : #accessing }
CardHandGUI >> updateHeaderName [
	nameHolder removeChildren.
	nameHolder addChild: self deck buildLabel
]
