"
I  provide a dedicated view for a Card Deck, or a subset of Cards in a Deck.

"
Class {
	#name : #CardDeckElement,
	#superclass : #BlElement,
	#instVars : [
		'deck',
		'tags',
		'nameHolder',
		'graphHolder',
		'theGraph',
		'graphElementsDictionary'
	],
	#category : #'IMAD-Cards-View'
}

{ #category : #accessing }
CardDeckElement >> buildGraph [
	"NB: The dictionary is needed because for each edge to create we have
	to look up the element corresponding to the other end of the relation.
	NB: We can also use this to map relations to their edges, if needed."

	| root |
	graphElementsDictionary := Dictionary new.
	root := BlElement new
		constraintsDo: [ :c | 
			c horizontal fitContent.
			c vertical fitContent ].
	self cards
		ifNotEmpty: [ self cards
				do: [ :aCard | 
					| cardElement |
					cardElement := self cardElementFor: aCard.
					self mapModelEntity: aCard toElement: cardElement.
					root addChild: cardElement ] ].
	self cards
		do: [ :source | 
			source sourceRelations
				do:
					[ :rel | root addChild: (self edgeElementFrom: source to: rel target) ] ].
	root
		layout:
			(self cards size > 1
				ifTrue: [ BlOnceLayout new layout: GtGradCircleLayout new ]
				ifFalse: [ BlOnceLayout new layout: GtGradHorizontalTreeLayout new ]).
	root clipChildren: false.
	theGraph := root asPannableElement.
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
	buttonBar
		addChild:
			(BrButton new
				look: BrGlamorousButtonWithIconLook;
				icon: BrGlamorousVectorIcons add;
				label: 'Add card';
				action: [ self deck addCard: Card new ]).	"With announcements the graph should update automatically"
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
	graphHolder := BlElement new
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical matchParent ];
		padding: (BlInsets all: 5);
		margin: (BlInsets all: 5);
		"border: (BlBorder paint: Color veryLightGray width: 1);"
			layout: BlLinearLayout vertical;
		yourself.
	graphPane
		addChildren:
			{buttonBar.
			graphHolder}.
	self updateGraph.
	^ graphPane
]

{ #category : #accessing }
CardDeckElement >> buildHeader [
	<todo: 'Make the nameHolder an editable label.'>
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
CardDeckElement >> cardElementFor: aCard [
	| elt |
	elt := BlElement new
		layout: BlFrameLayout new;
		border: (BlBorder paint: Color black);
		geometry: BlRectangle new;
		size: 120 @ 80;
		addChild:
			(BlTextElement new
				text: (aCard name asRopedText fontSize: 12);
				constraintsDo: [ :c | 
					c frame horizontal alignCenter.
					c frame vertical alignCenter ];
				yourself).
	elt graph model: aCard.
	elt graph beNode.
	elt addEventHandler: BlPullHandler new.
	elt
		addEventHandler:
			(BlEventHandler
				on: BlDoubleClickEvent
				do: [ :evt | aCard inspect ]).
	^ elt
]

{ #category : #accessing }
CardDeckElement >> cards [
	<todo: 'Apply the filter to select just the cards for this view'>
	^ self deck cards
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
CardDeckElement >> edgeElementFrom: source to: target [
	<todo: 'find a better way to draw directed edges'>
	| sourceElt targetElt line |
	sourceElt := self elementFor: source.
	targetElt := self elementFor: target.
	sourceElt graph connectTo: targetElt.
	line := BlLineElement new.
	line
		zIndex: -1;
		border: (BlBorder paint: Color gray width: 3).
	line
		fromAnchor: (BlNearestPositionBoundsAnchor nearestTo: targetElt from: sourceElt);
		toAnchor: (BlNearestPositionBoundsAnchor nearestTo: sourceElt from: targetElt);
		toHead:
			(BlArrowheadSimpleArrow new
				border: (BlBorder paint: Color gray width: 3)).
	^ line
]

{ #category : #accessing }
CardDeckElement >> elementFor: anEntity [
	self assert: (graphElementsDictionary includesKey: anEntity).
	^ graphElementsDictionary at: anEntity
]

{ #category : #accessing }
CardDeckElement >> initialize [
	<todo: 'assert invariant -- initially deck should be a new empty deck?'>
	super initialize.
	deck := CardDeck new.
	graphElementsDictionary := Dictionary new.
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
CardDeckElement >> mapModelEntity: entity toElement: anElement [
	graphElementsDictionary at: entity put: anElement
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
	graphHolder removeChildren.
	graphHolder addChild: self buildGraph
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
