"
I provide a high-level API to define the look of an element.

I am mainly intended to configure the appearance of nodes (and edges) in a graph.

I can set the text label, foreground and background color, shape, and border.
My configuration can be exported and imported as a Dictionary.

See also: ${class:name=ConfigurableLookExamples}$


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

{ #category : #accessing }
ConfigurableLook >> border: aColorSymbol [
	self configAt: #border put: aColorSymbol.
	self setBorder: aColorSymbol
]

{ #category : #accessing }
ConfigurableLook >> colorFor: aColorSymbol [
	self
		assert: (Color class includesSelector: aColorSymbol)
		description: aColorSymbol asString , ' is not a valid Color'.
	^ (Color perform: aColorSymbol) asBlPaint
]

{ #category : #accessing }
ConfigurableLook >> configAt: anObject put: aString [
	self configuration at: anObject put: aString
]

{ #category : #accessing }
ConfigurableLook >> configuration [
	^ configuration
]

{ #category : #accessing }
ConfigurableLook >> configuration: aDictionary [
	configuration := self defaultConfiguration
		addAll: aDictionary;
		yourself.
	self interpretConfiguration
]

{ #category : #accessing }
ConfigurableLook >> defaultConfiguration [
<todo: 'Add any default bindings here (eg border black'>
	^ {} asDictionary
]

{ #category : #accessing }
ConfigurableLook >> initialize [
	super initialize.
	configuration := Dictionary new.

]

{ #category : #accessing }
ConfigurableLook >> interpretConfiguration [
	<todo: 'raise an error for an unknown key?'>
	configuration
		keysAndValuesDo:
			[ :key :val | (self lookChangeBlockFor: key) value: val ]
]

{ #category : #accessing }
ConfigurableLook >> lookChangeBlockFor: key [
	<todo: 'raise an error for an unknown key?'>
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

{ #category : #accessing }
ConfigurableLook >> setBorder: aColorSymbol [ 
	self
		addChangeProperty: #(widget border)
		with: [ BlBorder paint: (self colorFor: aColorSymbol) width: 1 ]
]

{ #category : #accessing }
ConfigurableLook >> setShape: aShapeSymbol [
	self
		addChangeProperty: #(widget geometry)
		with: (self shapeFor: aShapeSymbol)
]

{ #category : #accessing }
ConfigurableLook >> setText: aString [
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

{ #category : #accessing }
ConfigurableLook >> shape: aShapeSymbol [
	self configAt: #shape put: aShapeSymbol.
	self setShape: aShapeSymbol
]

{ #category : #accessing }
ConfigurableLook >> shapeFor: aShapeSymbol [
	^ {(#circle -> [ BlCircle new ]).
	(#ellipse -> [ BlEllipse new ]).
	(#square -> [ BlSquare new ]).
	(#rectangle -> [ BlRoundedRectangleGeometry new ]).
	(#roundedRectangle -> [ BlRoundedRectangleGeometry cornerRadius: 10  ]).
} asDictionary at: aShapeSymbol
]

{ #category : #accessing }
ConfigurableLook >> text: aString [
	self configAt: #text put: aString.
	self setText: aString
]
