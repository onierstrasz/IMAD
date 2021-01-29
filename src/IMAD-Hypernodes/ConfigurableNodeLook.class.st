"
I provide a high-level API to define the look of an element.

I am mainly intended to configure the appearance of nodes (and edges) in a graph.

I can set the text label, foreground and background color, shape, and border.
My configuration can be exported and imported as a KeyedTree.

See also: ${class:name=ConfigurableNodeLookExamples}$

!Extensions
For every configuration key xyz there is a public method #xyz:, a private setter #setXyz:, and an action defined in the dictionary in the method #lookChangeBlockFor:

Any default bindings can be defined in ${method:name=ConfigurableNodeLook>>#defaultConfiguration}$. They may be overriden in ${method:name=ConfigurableNodeLook>>#configuration:}$
"
Class {
	#name : #ConfigurableNodeLook,
	#superclass : #BrLook,
	#instVars : [
		'configuration',
		'basicLook'
	],
	#category : #'IMAD-Hypernodes'
}

{ #category : #accessing }
ConfigurableNodeLook >> background: aColorSymbol [
	self configAt: #background put: aColorSymbol.
	self reset
]

{ #category : #accessing }
ConfigurableNodeLook >> beWider [
	"be 10% bigger in width"

	self configAt: #width put: self widget width * 1.1.
	self reset
]

{ #category : #public }
ConfigurableNodeLook >> border: aColorSymbol [
	self configAt: #border put: aColorSymbol.
	self reset
]

{ #category : #private }
ConfigurableNodeLook >> colorFor: aColorSymbol [
	self
		assert: (Color class includesSelector: aColorSymbol)
		description: aColorSymbol asString , ' is not a valid Color'.
	^ (Color perform: aColorSymbol) asBlPaint
]

{ #category : #private }
ConfigurableNodeLook >> configAt: anObject put: aString [
	self configuration at: anObject put: aString
]

{ #category : #public }
ConfigurableNodeLook >> configuration [
	^ configuration
]

{ #category : #public }
ConfigurableNodeLook >> configuration: aDictionary [
	configuration := self defaultConfiguration
		addAll: aDictionary;
		yourself.
	self reset
]

{ #category : #private }
ConfigurableNodeLook >> defaultConfiguration [
	<todo: 'Add any default bindings here (eg border black'>
	^ {} as: KeyedTree
]

{ #category : #private }
ConfigurableNodeLook >> initialize [
	super initialize.
	configuration := KeyedTree new.

]

{ #category : #private }
ConfigurableNodeLook >> interpretConfiguration [
	configuration
		keysAndValuesDo: [ :key :val | (self lookChangeBlockFor: key) value: val ]
]

{ #category : #private }
ConfigurableNodeLook >> lookChangeBlockFor: key [
	| actions |
	actions := {(#border
		-> [ :aColorSymbol | self setBorder: aColorSymbol ]).
	(#background -> [ :aColorSymbol | self setBackground: aColorSymbol ]).
	(#shape -> [ :aShapeSymbol | self setShape: aShapeSymbol ]).
	(#width -> [ :aNumber | self setWidth: aNumber ]).
	(#text -> [ :aString | self setText: aString ])} as: KeyedTree.
	self
		assert: (actions includesKey: key)
		description: key asString , ' is not a valid configuration key'.
	^ actions at: key
]

{ #category : #public }
ConfigurableNodeLook >> reset [
	"Clear all changes and recreate them (to avoid building up garbage changes)."
	self isAttachedToWidget
		ifTrue: [ self changes downOn: self ].
	self changes initialize.
	self isAttachedToWidget
		ifTrue: [ self changes upOn: self ].
	self interpretConfiguration
]

{ #category : #accessing }
ConfigurableNodeLook >> setBackground: aColorSymbol [
	self
		addChangeProperty: #(widget background)
		with: [ (self colorFor: aColorSymbol) asBlBackground ]
]

{ #category : #private }
ConfigurableNodeLook >> setBorder: aColorSymbol [ 
	self
		addChangeProperty: #(widget border)
		with: [ BlBorder paint: (self colorFor: aColorSymbol) width: 1 ]
]

{ #category : #private }
ConfigurableNodeLook >> setShape: aShapeSymbol [
	self
		addChangeProperty: #(widget geometry)
		with: (self shapeFor: aShapeSymbol)
]

{ #category : #private }
ConfigurableNodeLook >> setText: aString [
	self
		addChangeAddChildAs: #(label)
		with: [ BlTextElement new
				text: aString asRopedText;
				constraintsDo: [ :c | 
					c frame horizontal alignCenter.
					c frame vertical alignCenter ];
				padding:
					(BlInsets
						top: 5
						right: 5
						bottom: 5
						left: 5) ]
]

{ #category : #private }
ConfigurableNodeLook >> setWidth: aNumber [
	<todo: 'set both width and height for Squares and Circles'>
	self addChangeProperty: #(widget width) with: [ aNumber ]
]

{ #category : #public }
ConfigurableNodeLook >> shape: aShapeSymbol [
	self configAt: #shape put: aShapeSymbol.
	self reset
]

{ #category : #private }
ConfigurableNodeLook >> shapeFor: aShapeSymbol [
	^ {(#circle -> [ BlCircle new ]).
	(#ellipse -> [ BlEllipse new ]).
	(#square -> [ BlSquare new ]).
	(#rectangle -> [ BlRoundedRectangleGeometry new ]).
	(#roundedRectangle -> [ BlRoundedRectangleGeometry cornerRadius: 10  ]).
} asDictionary at: aShapeSymbol
]

{ #category : #public }
ConfigurableNodeLook >> text: aString [
	self configAt: #text put: aString.
	self reset
]
