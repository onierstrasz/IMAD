"
I provide a high-level API to define the look of an element.

I am mainly intended to configure the appearance of nodes (and edges) in a graph.

I can set various properties, such as the text label, foreground and background color, shape, and border. My configuration can be exported and imported as a Dictionary.

For every configuration key `#xyz` there is a public method `#updateXyzLook:`, called by {{gtMethod:name=HNConfigurableAptitude>>#updateLookFor:}} via {{gtMethod:name=HNConfigurableAptitude>>#interpretConfiguration}}.

Bindings are changed by calling  {{gtMethod:name=HNConfigurableAptitude>>#configuration:}} to set the configuration, or {{gtMethod:name=HNConfigurableAptitude>>#update:}} to change a single property or {{gtMethod:name=HNConfigurableAptitude>>#updateAll:}} to update several.

The following features can be configured:

`background` : a Color Symbol (#black, #white, see {{gtMethod:name=HNConfigurableAptitude>>#colorFor:}})
`border` : a Color Symbol
`shape` : a shape Symbol (#circle, #ellipse, ... see {{gtMethod:name=HNConfigurableAptitude>>#shapeFor:}})
`text` : a String
`width` : a Number

TO BE EXTENDED

See also: {{gtClass:name=HNConfigurableAptitudeExamples}}


"
Class {
	#name : #HNConfigurableAptitude,
	#superclass : #BrAptitude,
	#instVars : [
		'configuration',
		'defaults'
	],
	#category : #'IMAD-Hypernodes-View'
}

{ #category : #accessing }
HNConfigurableAptitude class >> configuration: aDictionary [
	^ self new
		configuration: aDictionary;
		yourself
]

{ #category : #accessing }
HNConfigurableAptitude >> at: keySymbol [
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
HNConfigurableAptitude >> beWider [
	self update: #width -> (self widget width * 1.1)
]

{ #category : #private }
HNConfigurableAptitude >> colorFor: aColorSymbol [
	self
		assert: (Color class includesSelector: aColorSymbol)
		description: aColorSymbol asString , ' is not a valid Color'.
	^ (Color perform: aColorSymbol) asBlPaint
]

{ #category : #public }
HNConfigurableAptitude >> configuration [
	^ configuration
]

{ #category : #accessing }
HNConfigurableAptitude >> configuration: aDictionary [
	"For convenience, argument may be an association list."

	configuration := self defaultConfiguration.
	configuration addAll: aDictionary asDictionary.
	self reset
]

{ #category : #accessing }
HNConfigurableAptitude >> defaultConfiguration [
	^ {(#padding -> (self defaults at: #padding))} asDictionary
]

{ #category : #accessing }
HNConfigurableAptitude >> defaults [
	^ defaults
]

{ #category : #private }
HNConfigurableAptitude >> initialize [
	super initialize.
	configuration := Dictionary new. "Probably a Dictionary is enough ..."
	self initializeDefaults 

]

{ #category : #private }
HNConfigurableAptitude >> initializeDefaults [
	defaults := {(#borderColor -> #black).
	(#borderWidth -> 1).
	(#cornerRadius -> 4).
	(#text -> '').
	(#padding -> 5)} asDictionary
]

{ #category : #private }
HNConfigurableAptitude >> interpretConfiguration [
	configuration
		keysDo: [ :lookProperty | self updateLookFor: lookProperty ]
]

{ #category : #private }
HNConfigurableAptitude >> properties [
	"For each key in properties, there should be a #updateKeyLook method to update the look. See updateLookFor:"

	^ #(borderColor hoverColor borderWidth background shape cornerRadius width text padding)
]

{ #category : #public }
HNConfigurableAptitude >> reset [
	"Clear all changes and recreate them (to avoid building up garbage changes)."

	self isAttachedToWidget
		ifTrue: [ self changes downOn: self ].
	self changes initialize.
	self children do: [ :c | self remove: c ].
	"remove the BrStyleCommonAptitude and possibly others"
	self isAttachedToWidget
		ifTrue: [ self changes upOn: self ].
	self interpretConfiguration
]

{ #category : #private }
HNConfigurableAptitude >> shapeFor: aShapeSymbol [
	^ {(#circle -> [ BlCircle new ]).
	(#ellipse -> [ BlEllipse new ]).
	(#square -> [ BlSquare new ]).
	(#rectangle -> [ BlRoundedRectangleGeometry new ]).
	(#roundedRectangle
		-> [ BlRoundedRectangleGeometry cornerRadius: (self at: #cornerRadius) ])}
		asDictionary at: aShapeSymbol
]

{ #category : #accessing }
HNConfigurableAptitude >> update: anAssociation [
	self updateAll: {anAssociation}
]

{ #category : #accessing }
HNConfigurableAptitude >> updateAll: anAssociationList [
	anAssociationList
		do: [ :assoc | self configuration at: assoc key put: assoc value ].
	self reset
]

{ #category : #accessing }
HNConfigurableAptitude >> updateBackgroundLook [
	self
		addChangeProperty: #(widget background)
		with: [ (self colorFor: (self at: #background)) asBlBackground ]
]

{ #category : #accessing }
HNConfigurableAptitude >> updateBorderColorLook [
	self updateBorderLook
]

{ #category : #private }
HNConfigurableAptitude >> updateBorderLook [
	self
		addChangeProperty: #(widget border)
		with: [ BlBorder paint: (self colorFor: (self at: #borderColor)) width: (self at: #borderWidth) ]
]

{ #category : #accessing }
HNConfigurableAptitude >> updateBorderWidthLook [
	self updateBorderLook
]

{ #category : #accessing }
HNConfigurableAptitude >> updateCornerRadiusLook [
	"NB: #shapeFor: will look up the cornerRadius property if it is needed."

	self updateShapeLook
]

{ #category : #accessing }
HNConfigurableAptitude >> updateHoverColorLook [
	<todo: 'Is this correct?'>
	self
		add:
			(BrStyleCommonAptitude new
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
HNConfigurableAptitude >> updateLookFor: lookProperty [
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
HNConfigurableAptitude >> updatePaddingLook [
	self
		addChangeProperty: #(widget padding)
		with: [ BlInsets all: (self at: #padding) ]
]

{ #category : #private }
HNConfigurableAptitude >> updateShapeLook [
	self
		addChangeProperty: #(widget geometry)
		with: (self shapeFor: (self at: #shape))
]

{ #category : #private }
HNConfigurableAptitude >> updateTextLook [
	self widgetDo: [ :w | w removeChildNamed: #label ].
	self
		addChangeAddChildAs: #(label)
		with: [ BlTextElement new
				text: (self at: #text) asRopedText;
				constraintsDo: [ :c | 
					c frame horizontal alignCenter.
					c frame vertical alignCenter ] ]
]

{ #category : #accessing }
HNConfigurableAptitude >> updateWidthLook [
	<todo: 'set both width and height for Squares and Circles'>
	self addChangeProperty: #(widget width) with: [ (self at: #width) ]
]
