"
I  provide a dedicated view for a Card Deck, or a subset of Cards in a Deck.

"
Class {
	#name : #CardDeckElement,
	#superclass : #BlElement,
	#instVars : [
		'deck'
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
	self addChild: self buildGraph
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
	self
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical matchParent ].
	self layout: BlLinearLayout vertical.
	self
		addChild: (BlTextElement new text: ('A Deck' asRopedText fontSize: 12))
]
