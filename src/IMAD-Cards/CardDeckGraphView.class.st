"
I am the actual card graph inside the graph pane of the card deck element.
I also keep track of the mappings from model entities back to their elements.
I sit inside the graphHolder of the card deck element.

"
Class {
	#name : #CardDeckGraphView,
	#superclass : #BlElement,
	#instVars : [
		'graphElementsDictionary',
		'deck',
		'hand'
	],
	#category : #'IMAD-Cards-View'
}

{ #category : #accessing }
CardDeckGraphView >> cards [
	^ self hand cards
]

{ #category : #accessing }
CardDeckGraphView >> deck [
	^ deck
]

{ #category : #accessing }
CardDeckGraphView >> edgeElementFor: aRelation [
	^ CardRelationViewBuilder new
		forRelation: aRelation inGraph: self
]

{ #category : #accessing }
CardDeckGraphView >> elementFor: anEntity [
	self assert: (graphElementsDictionary includesKey: anEntity).
	^ graphElementsDictionary at: anEntity
]

{ #category : #accessing }
CardDeckGraphView >> forDeck: aDeck withFilter: aFilter [
	"NB: The dictionary is needed because for each edge to create we have
	to look up the element corresponding to the other end of the relation.
	NB: We can also use this to map relations to their edges, if needed."

	deck := aDeck.
	hand := deck cardsMatching: aFilter.
	graphElementsDictionary := Dictionary new.
	self cards
		ifNotEmpty: [ self cards
				do: [ :aCard | 
					| cardElement |
					cardElement := self newCardElementFor: aCard.
					self mapModelEntity: aCard toElement: cardElement.	"to do"
					self addChild: cardElement ] ].
	self cards
		do: [ :source | 
			source sourceRelations
				do: [ :rel | 
				
				(hand containsRelation: rel)
				ifTrue:
				
				[
				
		
	
				self addChild: (self edgeElementFor: rel)
				]
				
				 ] ].
	self
		layout: (BlOnceLayout new layout: GtGradHorizontalTreeLayout new).
	"(self cards size > 1
				ifTrue: [ BlOnceLayout new layout: GtGradCircleLayout new ]
				ifFalse: [ BlOnceLayout new layout: GtGradHorizontalTreeLayout new ])"
	self clipChildren: false.
	^ self
]

{ #category : #accessing }
CardDeckGraphView >> hand [
	^ hand
]

{ #category : #accessing }
CardDeckGraphView >> initialize [
	super initialize.
	graphElementsDictionary := Dictionary new.
	self
		constraintsDo: [ :c | 
			c horizontal fitContent.
			c vertical fitContent ]
]

{ #category : #accessing }
CardDeckGraphView >> mapModelEntity: entity toElement: anElement [
	graphElementsDictionary at: entity put: anElement
]

{ #category : #accessing }
CardDeckGraphView >> newCardElementFor: aCard [
	^ CardNodeView new
		card: aCard;
		yourself
]
