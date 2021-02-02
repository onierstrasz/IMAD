"
I provide a high-level API to define the look of an element.

I am mainly intended to configure the appearance of nodes (and edges) in a graph.

I can set the text label, foreground and background color, shape, and border.
My configuration can be exported and imported as a Dictionary.
For every configuration key ==#xyz== there is a public method ==#xyz:==, a private setter ==#setXyz:==, and an action defined in the dictionary in the method ${method:name=HNConfigurableLook>>#lookChangeBlockFor:}$.

Any default bindings can be defined in ${method:name=HNConfigurableLook>>#defaultConfiguration}$. They may be overridden in ${method:name=HNConfigurableLook>>#configuration:}$.

The following features can be configured:

==background== : a Color Symbol (#black, #white, see ${method:name=HNConfigurableLook>>#colorFor:}$)
==border== : a Color Symbol
==shape== : a shape Symbol (#circle, #ellipse, ... see ${method:name=HNConfigurableLook>>#shapeFor:}$)
==text== : a String
==width== : a Number

__TO BE EXTENDED__

See also: ${class:name=HNConfigurableLookExamples}$

"
Class {
	#name : #HNConfigurableLook,
	#superclass : #BrLook,
	#instVars : [
		'configuration',
		'defaults'
	],
	#category : #'IMAD-Hypernodes'
}

{ #category : #accessing }
HNConfigurableLook class >> configuration: aDictionary [
	^ self new
		configuration: aDictionary;
		yourself
]

{ #category : #accessing }
HNConfigurableLook >> at: keySymbol [
	<todo:
		'do we need to handle the case of a missing key? Is it an error, or should we provide some reasonable default? (Needs a defaults method.)'>
	^ self configuration
		at: keySymbol
		ifAbsent: [ self defaults
				at: keySymbol
				ifAbsent:
					[ AssertionFailure signal: 'Missing default value for ' , keySymbol ] ]
]

{ #category : #accessing }
HNConfigurableLook >> beWider [
	self update: #width -> (self widget width * 1.1)
]

{ #category : #private }
HNConfigurableLook >> colorFor: aColorSymbol [
	self
		assert: (Color class includesSelector: aColorSymbol)
		description: aColorSymbol asString , ' is not a valid Color'.
	^ (Color perform: aColorSymbol) asBlPaint
]

{ #category : #public }
HNConfigurableLook >> configuration [
	^ configuration
]

{ #category : #accessing }
HNConfigurableLook >> configuration: aDictionary [
	"For convenience, argument may be an association list."

	configuration := aDictionary asDictionary.
	self reset
]

{ #category : #accessing }
HNConfigurableLook >> defaults [
	^ defaults
]

{ #category : #private }
HNConfigurableLook >> initialize [
	super initialize.
	configuration := Dictionary new. "Probably a Dictionary is enough ..."
	self initializeDefaults 

]

{ #category : #private }
HNConfigurableLook >> initializeDefaults [
	defaults := {(#borderColor -> #black).
	(#borderWidth -> 1).
	(#cornerRadius -> 4).
	(#text -> '').
	(#padding -> 5)} asDictionary
]

{ #category : #private }
HNConfigurableLook >> interpretConfiguration [
	configuration
		keysDo: [ :lookProperty | self updateLookFor: lookProperty ]
]

{ #category : #private }
HNConfigurableLook >> properties [
	"For each key in properties, there should be a #updateKeyLook method to update the look. See updateLookFor:"

	^ #(borderColor hoverColor borderWidth background shape cornerRadius width text padding)
]

{ #category : #public }
HNConfigurableLook >> reset [
	"Clear all changes and recreate them (to avoid building up garbage changes)."
	self isAttachedToWidget
		ifTrue: [ self changes downOn: self ].
	self changes initialize.
	self isAttachedToWidget
		ifTrue: [ self changes upOn: self ].
	self interpretConfiguration
]

{ #category : #private }
HNConfigurableLook >> shapeFor: aShapeSymbol [
	^ {(#circle -> [ BlCircle new ]).
	(#ellipse -> [ BlEllipse new ]).
	(#square -> [ BlSquare new ]).
	(#rectangle -> [ BlRoundedRectangleGeometry new ]).
	(#roundedRectangle
		-> [ BlRoundedRectangleGeometry cornerRadius: (self at: #cornerRadius) ])}
		asDictionary at: aShapeSymbol
]

{ #category : #accessing }
HNConfigurableLook >> update: anAssociation [
	self updateAll: {anAssociation}.
	self reset
]

{ #category : #accessing }
HNConfigurableLook >> updateAll: anAssociationList [
	anAssociationList
		do: [ :assoc | self configuration at: assoc key put: assoc value ].
	self reset
]

{ #category : #accessing }
HNConfigurableLook >> updateBackgroundLook [
	self
		addChangeProperty: #(widget background)
		with: [ (self colorFor: (self at: #background)) asBlBackground ]
]

{ #category : #accessing }
HNConfigurableLook >> updateBorderColorLook [
	self updateBorderLook
]

{ #category : #private }
HNConfigurableLook >> updateBorderLook [
	self
		addChangeProperty: #(widget border)
		with: [ BlBorder paint: (self colorFor: (self at: #borderColor)) width: (self at: #borderWidth) ]
]

{ #category : #accessing }
HNConfigurableLook >> updateBorderWidthLook [
	self updateBorderLook
]

{ #category : #accessing }
HNConfigurableLook >> updateCornerRadiusLook [
	"NB: #shapeFor: will look up the cornerRadius property if it is needed."

	self updateShapeLook
]

{ #category : #accessing }
HNConfigurableLook >> updateHoverColorLook [
	<todo: 'Is this correct?'>
	self
		add:
			(BrStyleCommonLook new
				default: [ :aStyle | 
					aStyle
						border:
							(BlBorder
								paint: (self colorFor: (self at: #borderColor))
								width: (self at: #borderWidth)) ];
				hovered: [ :aStyle | 
					aStyle
						border:
							(BlBorder
								paint: (self colorFor: (self at: #hoverColor))
								width: (self at: #borderWidth)) ])
]

{ #category : #private }
HNConfigurableLook >> updateLookFor: lookProperty [
	| method |
	self
		assert: (self properties includes: lookProperty)
		description: lookProperty asString , ' is not a valid configuration property'.
	method := #update , lookProperty capitalized , #Look.
	self
		assert: (self respondsTo: method)
		description: lookProperty asString , ' is missing an ' , method , ' method'.
	self perform: method
]

{ #category : #accessing }
HNConfigurableLook >> updatePaddingLook [
	self updateTextLook
]

{ #category : #private }
HNConfigurableLook >> updateShapeLook [
	self
		addChangeProperty: #(widget geometry)
		with: (self shapeFor: (self at: #shape))
]

{ #category : #private }
HNConfigurableLook >> updateTextLook [
	| padding |
	padding := self at: #padding.
	self
		addChangeAddChildAs: #(label)
		with: [ BlTextElement new
				text: (self at: #text) asRopedText;
				constraintsDo: [ :c | 
					c frame horizontal alignCenter.
					c frame vertical alignCenter ];
				padding:
					(BlInsets
						top: padding
						right: padding
						bottom: padding
						left: padding) ]
]

{ #category : #accessing }
HNConfigurableLook >> updateWidthLook [
	<todo: 'set both width and height for Squares and Circles'>
	self addChangeProperty: #(widget width) with: [ (self at: #width) ]
]
