"
I provide a high-level API to define the look of an element.

I am mainly intended to configure the appearance of nodes (and edges) in a graph.

I can set the text label, foreground and background color, shape, and border.
My configuration can be exported and imported as a Dictionary.
For every configuration key ==#xyz== there is a public method ==#xyz:==, a private setter ==#setXyz:==, and an action defined in the dictionary in the method ${method:name=ConfigurableNodeLook>>#lookChangeBlockFor:}$.

Any default bindings can be defined in ${method:name=ConfigurableNodeLook>>#defaultConfiguration}$. They may be overridden in ${method:name=ConfigurableNodeLook>>#configuration:}$.

The following features can be configured:

==background== : a Color Symbol (#black, #white, see ${method:name=ConfigurableNodeLook>>#colorFor:}$)
==border== : a Color Symbol
==shape== : a shape Symbol (#circle, #ellipse, ... see ${method:name=ConfigurableNodeLook>>#shapeFor:}$)
==text== : a String
==width== : a Number

__TO BE EXTENDED__

See also: ${class:name=ConfigurableNodeLookExamples}$

"
Class {
	#name : #ConfigurableNodeLook,
	#superclass : #BrLook,
	#instVars : [
		'configuration'
	],
	#category : #'IMAD-Hypernodes'
}

{ #category : #private }
ConfigurableNodeLook >> actions [
	"For each key in actions, there should be a #key: method to update the configuration, and a #setKey: method to update the look. See lookChangeBlockFor:"

	^ #(border background shape cornerRadius width text)
]

{ #category : #accessing }
ConfigurableNodeLook >> at: keySymbol put: aValue [
	self configuration at: keySymbol put: aValue
]

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

{ #category : #accessing }
ConfigurableNodeLook >> cornerRadius: aNumber [
	self configAt: #cornerRadius put: aNumber.
	self reset
]

{ #category : #private }
ConfigurableNodeLook >> defaultConfiguration [
	<todo: 'Add any default bindings here (eg border black'>
	^ {} asDictionary
]

{ #category : #private }
ConfigurableNodeLook >> initialize [
	super initialize.
	configuration := Dictionary new. "Probably a Dictionary is enough ..."

]

{ #category : #private }
ConfigurableNodeLook >> interpretConfiguration [
	configuration
		keysAndValuesDo: [ :key :val | (self lookChangeBlockFor: key) value: val ]
]

{ #category : #private }
ConfigurableNodeLook >> lookChangeBlockFor: actionKeySymbol [
	"Return the block to perform for this action key."

	| method |
	self
		assert: (self actions includes: actionKeySymbol)
		description: actionKeySymbol asString , ' is not a valid configuration key'.
	self
		assert: (self respondsTo: (actionKeySymbol , ':') asSymbol)
		description:
			actionKeySymbol asString , ' is missing a ' , actionKeySymbol
				, ': method'.
	method := ('set' , actionKeySymbol capitalized , ':') asSymbol.
	self
		assert: (self respondsTo: method)
		description: actionKeySymbol asString , ' is missing a ' , method , ' method'.
	^ [ :arg | self perform: method with: arg ]
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
