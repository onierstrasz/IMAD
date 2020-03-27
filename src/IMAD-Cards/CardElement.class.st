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
	"TODO
	Here I wasnt to add a hamburger icon at the right linked to a menu of various actions."
	^ BrLabel new
		margin: (BlInsets left: 10);
		look: (BrGlamorousLabelLook new bold glamorousRegularFont fontSize: 20);
		text: card title
]

{ #category : #accessing }
CardElement >> buildContentPane [
	| contentPane |
	contentPane := BlElement new.
	contentPane layout: BlLinearLayout vertical.
	contentPane constraintsDo: [ :c | 
		c horizontal matchParent.
		c vertical matchParent ].
	contentPane addChild: self buildCardLabel.
	"
	contentPane addChild: self buildParentLink.
	contentPane addChild: self buildContentTabs.
	"
	^ contentPane
]

{ #category : #accessing }
CardElement >> card: aCard [
	"
	TODO: here we should set up announcements!
	See: GtClassCoderElement>>#classCoder:
	"
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
CardElement >> simpleView [
	"simple card skeleton from TG"
	self
		size: 200 @ 300;
		margin: (BlInsets all: 10);
		look: BrShadowLook;
		background: Color white;
		addChild:
			(BrLabel new
				look: (BrGlamorousLabelLook new bold glamorousRegularFont fontSize: 20);
				text: 'Woohoo')
]

{ #category : #accessing }
CardElement >> updateContent [
	container ifNotNil: #removeFromParent.
	container := self buildContentPane.
	self addChildFirst: container
]
