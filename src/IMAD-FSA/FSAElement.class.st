Class {
	#name : #FSAElement,
	#superclass : #BlElement,
	#instVars : [
		'fsa',
		'contents'
	],
	#category : #'IMAD-FSA'
}

{ #category : #ui }
FSAElement >> borderCircleWithLabel: aString [
	^ BlElement new
		layout: BlFrameLayout new;
		border: (BlBorder paint: Color black);
		geometry: BlCircle new;
		size: self defaultNodeSize;
		addChild:
			(BlTextElement new
				text: aString asRopedText;
				constraintsDo: [ :c | 
					c frame horizontal alignCenter.
					c frame vertical alignCenter ];
				yourself);
		yourself
]

{ #category : #ui }
FSAElement >> buildContentPane [
	| mondrian controller |
	mondrian := GtMondrian new.
	mondrian nodes
		shape: [ :x | self borderCircleWithLabel: x asString ];
		with: self fsa nodes.
	mondrian edges
		shape: [ :edge | self directedCurvedEdge ];
		fromNearestTightCircle;
		toNearestTightCircle;
		connectToAll: [ :x | self fsa following: x ].
	mondrian layout circle.
	controller := FSAcontroller forModel: self fsa andView: mondrian root.
	self fsa addDependent: controller.
	^ mondrian asElement
]

{ #category : #acccessing }
FSAElement >> defaultNodeSize [
	^ 20@20
]

{ #category : #ui }
FSAElement >> directedCurvedEdge [
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

{ #category : #ui }
FSAElement >> directedEdge [
	^ BlParabollaArcElement new
		zIndex: 0;
		curvatureFraction: 0;
		border: (BlBorder paint: Color gray width: 2);
		toHead:
			(BlArrowheadSimpleArrow new
				border:
					(BlBorder builder
						paint: Color gray;
						width: 2;
						build))
]

{ #category : #acccessing }
FSAElement >> fsa [
	^ fsa
]

{ #category : #acccessing }
FSAElement >> fsa: anFSA [
	fsa := anFSA.
	self updateContent 
]

{ #category : #initialization }
FSAElement >> initialize [
	super initialize.
	self
		layout: BlLinearLayout vertical;
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical matchParent ]
]

{ #category : #initialization }
FSAElement >> updateContent [
	contents ifNotNil: #removeFromParent.
	contents := self buildContentPane.
	self addChildFirst: contents
]
