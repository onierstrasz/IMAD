"
I provide a view for a Card.
"
Class {
	#name : #CardElement,
	#superclass : #BlElement,
	#instVars : [
		'card',
		'container',
		'contentTabs'
	],
	#category : #'IMAD-Cards'
}

{ #category : #accessing }
CardElement >> buildCardLabel [
	^ BrLabel new
		margin: (BlInsets left: 10);
		look: (BrGlamorousLabelLook new bold glamorousRegularFont fontSize: 20);
		text: card title
]

{ #category : #accessing }
CardElement >> buildContentPane [
	"See GtClassCoderElement>>#buildContentPane"
	"used by updateContent to set the container"
	| contentPane topPane |
	contentPane := BlElement new.
	contentPane layout: BlLinearLayout vertical.
	contentPane constraintsDo: [ :c | 
		c horizontal matchParent.
		c vertical matchParent ].
	contentPane addChild: self buildTopPane.
	contentPane addChild: self buildTabs.
	^ contentPane
]

{ #category : #accessing }
CardElement >> buildMainMenu [
	self todo: 'hook in menu items'.
	^ BrButton new 
		look: BrGlamorousButtonWithIconLook;
		icon: BrGlamorousIcons hamburger asElement;
		label: 'Menu';
		margin: (BlInsets all: 5)
]

{ #category : #accessing }
CardElement >> buildTabs [
	self todo: 'build the tabs!'.
	"See: GtClassCoderElement>>#buildContentTabs"
	"| tabPragmas |
	tabPragmas := self classViewItems.
	contentTabs := BrTabGroup new.
	contentTabs look: BrGlamorousTabGroupLook new.
	contentTabs constraintsDo: [ :c | c linear weight: 2 ].
	tabPragmas
		do: [ :each | 
			each
				ifItHasContent: [ | tab |
					tab := BrTab new
						look: BrGlamorousTabLook new;
						label: each title;
						stencil: [ each asElementDo: [ :el | el ] ].
					each actions notEmpty
						ifTrue:
							[ tab toolbarStencil: [ each actionsToolbarForElement: tab ] ].
					contentTabs addTab: tab ] ].
	^ contentTabs"

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
	self todo: 'set up announcements'.
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
	"NB: don't updateContent until card: has been set!"
]

{ #category : #accessing }
CardElement >> updateContent [
	container ifNotNil: #removeFromParent.
	container := self buildContentPane.
	self addChildFirst: container
]
