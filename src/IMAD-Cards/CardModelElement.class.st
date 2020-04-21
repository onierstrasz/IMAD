"
I provide some shared UI behaviour for Cards and CardDecks
"
Class {
	#name : #CardModelElement,
	#superclass : #BlElement,
	#instVars : [
		'entity',
		'container',
		'tabs',
		'testingDict'
	],
	#category : #'IMAD-Cards-UI'
}

{ #category : #gui }
CardModelElement >> buildContentPane [
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

{ #category : #gui }
CardModelElement >> buildLabel [
	^ BrLabel new
		margin: (BlInsets left: 10);
		look: (BrGlamorousLabelLook new bold glamorousRegularFont fontSize: 20);
		text: self name
]

{ #category : #gui }
CardModelElement >> buildMainMenu [
	^ self subclassResponsibility 
]

{ #category : #gui }
CardModelElement >> buildTabs [
	<gtExample>
	tabs := BrTabGroup new.
	tabs look: BrGlamorousTabGroupLook new.
	tabs addTab: self descriptionTab.
	tabs addTab: self propertyTab.
	^ tabs
]

{ #category : #gui }
CardModelElement >> buildTopPane [
	| top left span right |
	
	top := BlElement new.
	top layout: (BlLinearLayout horizontal).
	top constraintsDo: [ :c |
		c horizontal matchParent.
		c vertical fitContent ].

	left := self buildLabel.
	
	span := BlElement new.
	span constraintsDo: [ :c |
		c horizontal matchParent.
		c vertical matchParent. ].

	right := self buildMainMenu.

	top addChildren: { left . span . right }.

	^ top
]

{ #category : #accessing }
CardModelElement >> description [
	^ entity description
]

{ #category : #accessing }
CardModelElement >> description: aString [
	^ entity description: aString
]

{ #category : #gui }
CardModelElement >> descriptionTab [
	| gtDoc |
	^ BrTab new
		look: BrGlamorousTabLook new;
		label: 'Description';
		stencil: [ gtDoc := GtDocument new.
			gtDoc text: self description.
			gtDoc
				when: GtDocumentUpdateRequestedAnnouncement
				do: [ self description: gtDoc text asString ].
			self testingDictAt: #gtDocForDescription put: gtDoc.
			gtDoc ]
]

{ #category : #accessing }
CardModelElement >> entity [
	^ entity
]

{ #category : #accessing }
CardModelElement >> entity: aCardModelEtity [
	"I.e., either a Card or a CardDeck"
	entity := aCardModelEtity.
	self updateContent 
]

{ #category : #initialization }
CardModelElement >> initialize [
	super initialize.
	self
		layout: BlLinearLayout vertical;
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical matchParent ].
	testingDict := Dictionary new.
]

{ #category : #accessing }
CardModelElement >> name [
	^ entity name
]

{ #category : #accessing }
CardModelElement >> properties [
	^ entity properties
]

{ #category : #gui }
CardModelElement >> propertyTab [
	^ BrTab new
		look: BrGlamorousTabLook new;
		label: 'Properties';
		stencil: [ (self properties gtItemsFor: GtPhlowEmptyView new)
				asElementDo: [ :e | e ] ]
]

{ #category : #accessing }
CardModelElement >> testingDictAt: key [
	^ testingDict at: key


]

{ #category : #accessing }
CardModelElement >> testingDictAt: key put: value [
	"Private stuff to make accessible for testing."
	testingDict at: key put: value


]

{ #category : #gui }
CardModelElement >> updateContent [
	container ifNotNil: #removeFromParent.
	container := self buildContentPane.
	self addChildFirst: container
]
