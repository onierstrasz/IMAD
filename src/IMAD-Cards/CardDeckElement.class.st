"
I  provide a dedicated view for a Card Deck, or a subset of Cards in a Deck.

"
Class {
	#name : #CardDeckElement,
	#superclass : #BlElement,
	#instVars : [
		'deck',
		'tags',
		'header',
		'graphPane',
		'nameHolder'
	],
	#category : #'IMAD-Cards-View'
}

{ #category : #accessing }
CardDeckElement >> buildGraph [
	<todo: 'move/migrate to CardDeckElement'>
	| elts root |
	elts := Dictionary new.
	root := BlElement new
		constraintsDo: [ :c | 
			c horizontal fitContent.
			c vertical fitContent ].
	self cards
		ifNotEmpty: [ self cards
				do: [ :each | 
					| elt |
					elt := self cardElementFor: each.
					elt graph beNode.
					elt addEventHandler: BlPullHandler new.
					elt
						addEventHandler:
							(BlEventHandler
								on: BlDoubleClickEvent
								do: [ :evt | 
								each inspect
								
								 ]).
					elts at: each put: elt.
					root addChild: elt ].
			self cards
				do: [ :source | 
					source sourceRelations
						do: [ :rel | 
							| sourceElt targetElt line |
							sourceElt := elts at: source.
							targetElt := elts at: rel target.
							sourceElt graph connectTo: targetElt.
							line := BlLineElement new.
							line
								zIndex: -1;
								border: (BlBorder paint: (Color gray alpha: 0.2) width: 5).
							line
								fromAnchor: (BlNearestPositionBoundsAnchor nearestTo: targetElt from: sourceElt);
								toAnchor: (BlNearestPositionBoundsAnchor nearestTo: sourceElt from: targetElt).
							root addChild: line ] ].
			root
				layout:
					(self cards size > 1
						ifTrue: [ BlOnceLayout new layout: GtGradCircleLayout new ]
						ifFalse: [ BlOnceLayout new layout: GtGradHorizontalTreeLayout new ]).
			root clipChildren: false ].
	^ root asPannableElement
]

{ #category : #accessing }
CardDeckElement >> buildGraphPane [
	<todo: 'Add button bar. Add separate graph area.
	Buttons:
	- add card
	- zoom in
	- zoom out
	- refresh
	'>
	graphPane := BlElement new
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical matchParent ];
		padding: (BlInsets all: 5);
		margin: (BlInsets all: 5);
		border: (BlBorder paint: Color veryLightGray width: 1);
		layout: BlLinearLayout vertical;
		yourself.
	self updateGraph.
	^ graphPane
]

{ #category : #accessing }
CardDeckElement >> buildHeader [
	<todo: 'Migrate deck methods used below to this class.
	Make the nameHolder an editable label.'>
	| span buttonBar |
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
	span := BlElement new.
	span
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical matchParent ].
	buttonBar := BlElement new
		constraintsDo: [ :c | 
			c horizontal fitContent.
			c vertical fitContent ];
		layout: BlLinearLayout horizontal;
		yourself.
	buttonBar
		addChild:
			(BrButton new
				look: BrGlamorousButtonWithIconLook;
				icon: BrGlamorousVectorIcons inspect;
				label: 'Open inspector window';
				action: [ deck inspect ]).
	buttonBar
		addChild:
			(BrButton new
				look:
					BrGlamorousButtonWithIconLook
						+
							(BrGlamorousWithDropdownLook
								handle: [ BrButton new
										look:
											BrGlamorousButtonWithIconLook - BrGlamorousWithLabelTooltipLook
												- BrGlamorousButtonExteriorLook;
										icon: BrGlamorousIcons save;
										label: 'Menu' ]
								content: [ | dropdown |
									dropdown := self deck dropDownElement.
									(self deck classNamed: self deck storageClassName) isClass
										ifTrue: [ self deck saveState.
											dropdown
												addChild: (BlTextElement new text: ('Saved' asRopedText fontSize: 12)) ]
										ifFalse: [ dropdown addChild: self deck newClassDefinitionDialog ].
									dropdown ]);
				icon: BrGlamorousIcons save;
				label: 'Save to method ' , self deck storageClassMethod).
	header
		addChildren:
			{nameHolder.
			span.
			buttonBar}.
	self updateHeader.
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
	<todo: 'move/migrate to CardDeckElement'>
	^ BlElement new
		layout: BlFrameLayout new;
		border: (BlBorder paint: Color black);
		geometry: BlRectangle  new;
		size: 120@80;
		addChild:
			(BlTextElement new
				text: (aCard name asRopedText fontSize: 12);
				constraintsDo: [ :c | 
					c frame horizontal alignCenter.
					c frame vertical alignCenter ];
				yourself);
		yourself
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
	deck := aCardDeck.
	self updateHeader.
	self updateGraph
]

{ #category : #accessing }
CardDeckElement >> initialize [
	<todo: 'Move CardDeck graph implementation here'>
	<todo:
		'
	- add notifications
	- assert invariant -- initially deck should be a new empty deck?
	- how do you refresh on an update?
	'>
	super initialize.
	deck := CardDeck new.
	self
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical matchParent ].
	self layout: BlLinearLayout vertical.
	self addChild: self buildHeader.
	self addChild: self buildTags.
	self addChild: self buildGraphPane
]

{ #category : #accessing }
CardDeckElement >> updateGraph [
	graphPane removeChildren.
	graphPane addChild: self buildGraph
]

{ #category : #accessing }
CardDeckElement >> updateHeader [
	nameHolder removeChildren.
	nameHolder
		addChild: (BlTextElement new text: (self deck name asRopedText fontSize: 30))
]

{ #category : #accessing }
CardDeckElement >> updateTags [
	tags removeChildren.
	tags
		addChild: (BlTextElement new text: ('Tags go here' asRopedText fontSize: 12))
]
