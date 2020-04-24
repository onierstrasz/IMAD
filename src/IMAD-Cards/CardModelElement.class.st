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

{ #category : #ui }
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

{ #category : #ui }
CardModelElement >> buildLabel [
	^ BrLabel new
		margin: (BlInsets left: 10);
		look: (BrGlamorousLabelLook new bold glamorousRegularFont fontSize: 20);
		text: self entity name
]

{ #category : #ui }
CardModelElement >> buildMainMenu [
	^ self subclassResponsibility 
]

{ #category : #ui }
CardModelElement >> buildTabs [
	"<gtExample>"
	tabs := BrTabGroup new.
	tabs look: BrGlamorousTabGroupLook new.
	tabs addTab: self descriptionTab.
	tabs addTab: self propertyTab.
	^ tabs
]

{ #category : #ui }
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

{ #category : #ui }
CardModelElement >> descriptionTab [
	<todo: 'Find a way to test this'>
	| gtDoc |
	gtDoc := GtDocument new.
	gtDoc text: self entity description.
	self testingDictAt: #gtDocForDescription put: gtDoc.
	^ BrTab new
		look: BrGlamorousTabLook new;
		label: 'Description';
		stencil: [ gtDoc asElementWithoutSaveAction ];
		toolbarStencil: [ BrButton new
				look: BrGlamorousButtonWithIconLook;
				icon: BrGlamorousVectorIcons accept;
				label: 'Save';
				action: [ self entity description: gtDoc text ] ]
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

{ #category : #ui }
CardModelElement >> propertyTab [
	^ BrTab new
		look: BrGlamorousTabLook new;
		label: 'Properties';
		"NB: Instead of building the property tab here, we can copy the one from the model, ie reuse it as a stencil."
		"stencil: [ (self properties gtItemsFor: GtPhlowEmptyView new)
				asElementDo: [ :e | e ] ]"
		stencil: [ (self entity gtPropertiesFor: GtPhlowEmptyView new)
				asElementDo: [ :e | e ] ]
]

{ #category : #testing }
CardModelElement >> testingDictAt: key [
	^ testingDict at: key


]

{ #category : #testing }
CardModelElement >> testingDictAt: key put: value [
	"Private stuff to make accessible for testing."
	testingDict at: key put: value


]

{ #category : #ui }
CardModelElement >> updateContent [
	container ifNotNil: #removeFromParent.
	container := self buildContentPane.
	self addChildFirst: container
]
