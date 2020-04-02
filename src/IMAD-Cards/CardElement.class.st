"
I provide a view for a Card.
"
Class {
	#name : #CardElement,
	#superclass : #BlElement,
	#instVars : [
		'card',
		'container',
		'tabs'
	],
	#category : #'IMAD-Cards-UI'
}

{ #category : #accessing }
CardElement >> buildCardLabel [
	^ BrLabel new
		margin: (BlInsets left: 10);
		look: (BrGlamorousLabelLook new bold glamorousRegularFont fontSize: 20);
		text: card name
]

{ #category : #accessing }
CardElement >> buildContentPane [
	"See GtClassCoderElement>>#buildContentPane"

	"used by updateContent to set the container"

	| contentPane |
	contentPane := BlElement new.
	contentPane layout: BlLinearLayout vertical.
	contentPane
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical matchParent ].
	contentPane addChild: self buildTopPane.
	contentPane addChild: self buildTabs.
	"contentPane addChild: BrExamplesShowroom new glamorousTabs."
	^ contentPane
]

{ #category : #accessing }
CardElement >> buildMainMenu [
	<todo: 'hook in menu items'>
	<gtExample>
	"See: GtWorldElement>>#newSubSpaceButton"
	^ BrButton new 
		look: BrGlamorousButtonWithIconLook;
		icon: BrGlamorousIcons hamburger asElement;
		label: 'Menu';
		margin: (BlInsets all: 5)
]

{ #category : #accessing }
CardElement >> buildTabs [
	<gtExample>
	<todo: 'Add the property list tab'>
	<todo: 'Link the description view to the card via announcements?'>

	"See: GtClassCoderElement>>#buildtabs.
	See: BrExamplesShowroom>>#glamorousTabs"
	
	| descriptionView propertyView |
	tabs := BrTabGroup new.
	tabs look: BrGlamorousTabGroupLook new.
	
	tabs addTab: (BrTab new
		look: BrGlamorousTabLook new;
		label: 'Description';
		stencil: [ GtDocument new text: (card description)]). "NB: This is just a static link."

	tabs addTab: (BrTab new
		look: BrGlamorousTabLook new;
		label: 'Properties';
		stencil: [ BlElement new
			constraintsDo: [ :c |
				c horizontal matchParent.
				c vertical exact: 300 ];
			margin: (BlInsets all: 10);
			background: (Color blue alpha: 0.2) ]).

	^ tabs
]

{ #category : #accessing }
CardElement >> buildTopPane [
	| top left span right |
	
	top := BlElement new.
	top layout: (BlLinearLayout horizontal).
	top constraintsDo: [ :c |
		c horizontal matchParent.
		c vertical fitContent ].

	left := self buildCardLabel.
	
	span := BlElement new.
	span constraintsDo: [ :c |
		c horizontal matchParent.
		c vertical matchParent. ].

	right := self buildMainMenu.

	top addChildren: { left . span . right }.

	^ top
]

{ #category : #accessing }
CardElement >> card: aCard [
	<todo: 'set up announcements'>
	"See: GtClassCoderElement>>#classCoder:"
	
	card := aCard.
	self updateContent
]

{ #category : #accessing }
CardElement >> initialize [
	super initialize.
	self
		layout: BlLinearLayout vertical;
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical matchParent ].
	card := Card new. "placeholder"
]

{ #category : #accessing }
CardElement >> updateContent [
	container ifNotNil: #removeFromParent.
	container := self buildContentPane.
	self addChildFirst: container
]
