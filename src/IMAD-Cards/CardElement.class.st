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

	self todo: 'Add a hamburger dropdown'.
	
	^ BrLabel new
		margin: (BlInsets left: 10);
		look: (BrGlamorousLabelLook new bold glamorousRegularFont fontSize: 20);
		text: card title
]

{ #category : #accessing }
CardElement >> buildContentPane [
	"See GtClassCoderElement>>#buildContentPane"
	| contentPane topPane |
	contentPane := BlElement new.
	contentPane layout: BlLinearLayout vertical.
	contentPane constraintsDo: [ :c | 
		c horizontal matchParent.
		c vertical matchParent ].
	contentPane addChild: self buildCardLabel.
	contentPane addChild: self buildMainMenu.
	^ contentPane
]

{ #category : #accessing }
CardElement >> buildMainMenu [
	self todo: 'hook in menu items'.
	^ BrButton new 
		look: BrGlamorousButtonWithIconLook;
		icon: BrGlamorousIcons hamburger asElement;
		label: 'Menu'
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
