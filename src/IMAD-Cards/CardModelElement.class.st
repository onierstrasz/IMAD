"
I provide some shared UI behaviour for Cards and CardDecks
"
Class {
	#name : #CardModelElement,
	#superclass : #BlElement,
	#instVars : [
		'entity',
		'container',
		'tabs'
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
	"contentPane addChild: self buildTopPane."
	contentPane addChild: self buildLabel.
	contentPane addChild: self buildTabs.
	"contentPane addChild: BrExamplesShowroom new glamorousTabs."
	^ contentPane
]

{ #category : #ui }
CardModelElement >> buildLabel [
	| aNameEditor |
	aNameEditor := BrEditableLabel new
		look:
			(BrGlamorousEditableLabelLook new
				defaultBackground: Color transparent;
				glamorousCodeFont;
				bold;
				fontSize: 20);
		text: self entity name;
		margin: (BlInsets all: 0).
	aNameEditor
		when: BrEditorAcceptWish
		do: [ :aWish | self entity name: aWish text asString ].
	^ aNameEditor
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
CardModelElement >> descriptionTab [
	| gtDoc |
	gtDoc := GtDocument new.
	gtDoc text: self entity description.
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
			c vertical matchParent ]
]

{ #category : #ui }
CardModelElement >> propertyTab [
	"NB: Instead of building the property tab here, we can copy the one from the model, ie reuse it as a stencil."

	^ BrTab new
		look: BrGlamorousTabLook new;
		label: 'Properties';
		stencil: [ (self entity gtPropertiesFor: GtPhlowEmptyView new)
				asElementDo: [ :e | e ] ]
]

{ #category : #ui }
CardModelElement >> updateContent [
	"Called when the entity is set or updated"
	container ifNotNil: #removeFromParent.
	container := self buildContentPane.
	self addChildFirst: container
]
