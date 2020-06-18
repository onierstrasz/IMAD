"
I am the actual card graph inside the graph pane of the card deck element.
I also keep track of the mappings from model entities back to their elements.
I sit inside the graphHolder of the card deck element.

"
Class {
	#name : #CardGraphElement,
	#superclass : #BlElement,
	#instVars : [
		'graphElementsDictionary',
		'deck'
	],
	#category : #'IMAD-Cards-View'
}

{ #category : #accessing }
CardGraphElement class >> forDeck: aDeck [
	^ self new forDeck: aDeck
]

{ #category : #accessing }
CardGraphElement >> cards [
	^ self deck cards
]

{ #category : #accessing }
CardGraphElement >> deck [
	^ deck
]

{ #category : #accessing }
CardGraphElement >> edgeElementFor: aRelation [
	^ CardRelationElement new
		forRelation: aRelation inGraph: self;
		yourself
]

{ #category : #accessing }
CardGraphElement >> elementFor: anEntity [
	self assert: (graphElementsDictionary includesKey: anEntity).
	^ graphElementsDictionary at: anEntity
]

{ #category : #accessing }
CardGraphElement >> forDeck: aDeck [
	"NB: The dictionary is needed because for each edge to create we have
	to look up the element corresponding to the other end of the relation.
	NB: We can also use this to map relations to their edges, if needed."

	deck := aDeck.
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
				do:
					[ :rel | self addChild: (self edgeElementFor: rel) ] ].
	self
		layout:
			(self cards size > 1
				ifTrue: [ BlOnceLayout new layout: GtGradCircleLayout new ]
				ifFalse: [ BlOnceLayout new layout: GtGradHorizontalTreeLayout new ]).
	self clipChildren: false.
	^ self
]

{ #category : #accessing }
CardGraphElement >> initialize [
	super initialize.
	graphElementsDictionary := Dictionary new.
	self
		constraintsDo: [ :c | 
			c horizontal fitContent.
			c vertical fitContent ]
]

{ #category : #accessing }
CardGraphElement >> mapModelEntity: entity toElement: anElement [
	graphElementsDictionary at: entity put: anElement
]

{ #category : #accessing }
CardGraphElement >> newCardElementFor: aCard [
	^ CardElement new
		card: aCard;
		yourself
]
