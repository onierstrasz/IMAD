"
I am the actual card graph inside the graph pane of the card deck element.
I also keep track of the mappings from model entities back to their elements.
I sit inside the graphHolder of the card deck element.

"
Class {
	#name : #VirtualHandGraphView,
	#superclass : #BlElement,
	#instVars : [
		'graphElementsDictionary',
		'deck',
		'hand',
		'style'
	],
	#category : #'IMAD-Cards-View'
}

{ #category : #accessing }
VirtualHandGraphView >> cards [
	^ self hand cards
]

{ #category : #accessing }
VirtualHandGraphView >> deck [
	^ self hand deck
]

{ #category : #accessing }
VirtualHandGraphView >> edgeElementFor: aRelation [
	^ CardRelationViewBuilder new
		forRelation: aRelation inGraph: self
]

{ #category : #accessing }
VirtualHandGraphView >> elementFor: anEntity [
	self assert: (graphElementsDictionary includesKey: anEntity).
	^ graphElementsDictionary at: anEntity
]

{ #category : #accessing }
VirtualHandGraphView >> forHand: aHand withStyle: aStyle [
	"NB: The dictionary is needed because for each edge to create we have
	to look up the element corresponding to the other end of the relation.
	NB: We can also use this to map relations to their edges, if needed."

	hand := aHand.
	style := aStyle.
	graphElementsDictionary := Dictionary new.
	self cards
		ifNotEmpty: [ self cards
				do: [ :aCard | 
					| cardElement |
					cardElement := self nodeCardElementFor: aCard.
					self mapModelEntity: aCard toElement: cardElement.	"to do"
					self addChild: cardElement ] ].
	self cards
		do: [ :source | 
			source sourceRelations
				do: [ :rel | 
					(hand containsRelation: rel)
						ifTrue: [ self addChild: (self edgeElementFor: rel) ] ] ].
	self layout: self style layout.
	self clipChildren: false.
	^ self
]

{ #category : #accessing }
VirtualHandGraphView >> hand [
	^ hand
]

{ #category : #accessing }
VirtualHandGraphView >> initialize [
	super initialize.
	graphElementsDictionary := Dictionary new.
	self
		constraintsDo: [ :c | 
			c horizontal fitContent.
			c vertical fitContent ]
]

{ #category : #accessing }
VirtualHandGraphView >> mapModelEntity: entity toElement: anElement [
	graphElementsDictionary at: entity put: anElement
]

{ #category : #accessing }
VirtualHandGraphView >> nodeCardElementFor: aCard [
	^ CardNodeView new
		card: aCard;
		yourself
]

{ #category : #accessing }
VirtualHandGraphView >> style [
	^ style
]
