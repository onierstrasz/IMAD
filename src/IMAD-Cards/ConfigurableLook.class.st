"
I provide a high-level API to define the look of an element.

I am mainly intended to configure the appearance of nodes (and edges) in a graph.

I can set the text label, foreground and background color, shape, and border.
My configuration can be exported and imported as a Dictionary.

See also: ${class:name=ConfigurableLookExamples}$

!Extensions
For every configuration key xyz there is a public method #xyz:, a private setter #setXyz:, and an action defined in the dictionary in the method #lookChangeBlockFor:

Any default bindings can be defined in ${method:name=ConfigurableLook>>#defaultConfiguration}$. They may be overriden in ${method:name=ConfigurableLook>>#configuration:}$
"
Class {
	#name : #ConfigurableLook,
	#superclass : #BrLook,
	#instVars : [
		'configuration',
		'basicLook'
	],
	#category : #'IMAD-Cards-View'
}

{ #category : #public }
ConfigurableLook >> border: aColorSymbol [
	self configAt: #border put: aColorSymbol.
	self setBorder: aColorSymbol
]

{ #category : #private }
ConfigurableLook >> colorFor: aColorSymbol [
	self
		assert: (Color class includesSelector: aColorSymbol)
		description: aColorSymbol asString , ' is not a valid Color'.
	^ (Color perform: aColorSymbol) asBlPaint
]

{ #category : #private }
ConfigurableLook >> configAt: anObject put: aString [
	self configuration at: anObject put: aString
]

{ #category : #public }
ConfigurableLook >> configuration [
	^ configuration
]

{ #category : #public }
ConfigurableLook >> configuration: aDictionary [
	configuration := self defaultConfiguration
		addAll: aDictionary;
		yourself.
	self reset
]

{ #category : #private }
ConfigurableLook >> defaultConfiguration [
	<todo: 'Add any default bindings here (eg border black'>
	^ {} asDictionary
]

{ #category : #private }
ConfigurableLook >> initialize [
	super initialize.
	configuration := Dictionary new.

]

{ #category : #private }
ConfigurableLook >> interpretConfiguration [

	configuration
		keysAndValuesDo: [ :key :val | (self lookChangeBlockFor: key) value: val ]
]

{ #category : #private }
ConfigurableLook >> lookChangeBlockFor: key [
	| actions |
	actions := {(#border
		-> [ :aColorSymbol | self setBorder: aColorSymbol ]).
	(#shape -> [ :aShapeSymbol | self setShape: aShapeSymbol ]).
	(#text -> [ :aString | self setText: aString ])} asDictionary.
	self
		assert: (actions includesKey: key)
		description: key asString , ' is not a valid configuration key'.
	^ actions at: key
]

{ #category : #public }
ConfigurableLook >> reset [
	"Clear all changes and recreate them (to avoid building up garbage changes)."

	self changes initialize.
	self interpretConfiguration
]

{ #category : #private }
ConfigurableLook >> setBorder: aColorSymbol [ 
	self
		addChangeProperty: #(widget border)
		with: [ BlBorder paint: (self colorFor: aColorSymbol) width: 1 ]
]

{ #category : #private }
ConfigurableLook >> setShape: aShapeSymbol [
	self
		addChangeProperty: #(widget geometry)
		with: (self shapeFor: aShapeSymbol)
]

{ #category : #private }
ConfigurableLook >> setText: aString [
	self isAttachedToWidget
		ifTrue: [ self widget removeChildNamed: #label ].
	self
		addChangeAddChildAs: #(content label)
		with: [ BlTextElement new
				text: aString asRopedText;
				padding:
					(BlInsets
						top: 5
						right: 5
						bottom: 5
						left: 5) ]
]

{ #category : #public }
ConfigurableLook >> shape: aShapeSymbol [
	self configAt: #shape put: aShapeSymbol.
	self reset
]

{ #category : #private }
ConfigurableLook >> shapeFor: aShapeSymbol [
	^ {(#circle -> [ BlCircle new ]).
	(#ellipse -> [ BlEllipse new ]).
	(#square -> [ BlSquare new ]).
	(#rectangle -> [ BlRoundedRectangleGeometry new ]).
	(#roundedRectangle -> [ BlRoundedRectangleGeometry cornerRadius: 10  ]).
} asDictionary at: aShapeSymbol
]

{ #category : #public }
ConfigurableLook >> text: aString [
	self configAt: #text put: aString.
	self reset
]
