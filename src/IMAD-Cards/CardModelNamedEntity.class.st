"
I serve as a common superclass for named entities (Cards and Card Decks)
"
Class {
	#name : #CardModelNamedEntity,
	#superclass : #CardModelEntity,
	#category : #'IMAD-Cards-Model'
}

{ #category : #initialization }
CardModelNamedEntity >> assertInvariant [
	super assertInvariant.
	self assert: self name isNotNil description: 'name must be defined'.
	self assert: self name isString description: 'name must be a string'.
	self
		assert: self name notEmpty
		description: 'name must not be an empty string'.
	self
		assert: self description isNotNil
		description: 'description must be defined'.
	self
		assert: self description isString
		description: 'description must be a string'.
	self
		assert: self description notEmpty
		description: 'description must not be an empty string'
]

{ #category : #'gt-extensions' }
CardModelNamedEntity >> buildDescriptionPane [
	| contentPane gtDoc aSaveButton |
	contentPane := BlElement new.
	contentPane layout: BlLinearLayout vertical.
	contentPane
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical fitContent ].
	contentPane addChild: self buildLabel.
	gtDoc := GtDocument new.
	gtDoc text: self description.
	aSaveButton := BrButton new
		look: BrGlamorousButtonWithIconLook;
		visibility: BlVisibility hidden;
		icon: BrGlamorousVectorIcons accept;
		label: 'Save';
		action: [ self description: gtDoc text asString ].
	gtDoc editor
		when: BrTextEditorModifiedEvent
		do: [ :anEvent | 
			anEvent text asString = gtDoc text
				ifTrue: [ aSaveButton visibility: BlVisibility hidden ]
				ifFalse: [ aSaveButton visibility: BlVisibility visible ] ].
	contentPane addChild: gtDoc asElementWithoutSaveAction vFitContent.
	contentPane addChild: aSaveButton.
	^ contentPane
]

{ #category : #'gt-extensions' }
CardModelNamedEntity >> buildLabel [
	"See also GtBehaviorCoderElement>>#buildClassLabel"

	^ (self
		editableLabelFor: self name
		withSetter: [ :newName | self name: newName ])
		look:
			(BrGlamorousEditableLabelLook new
				defaultBackground: Color transparent;
				glamorousCodeFont;
				bold;
				fontSize: 20);
		margin: (BlInsets all: 0)
]

{ #category : #accessing }
CardModelNamedEntity >> description [
	^ self get: #description
]

{ #category : #accessing }
CardModelNamedEntity >> description: aString [
	self set: #description to: aString

]

{ #category : #'gt-extensions' }
CardModelNamedEntity >> editableLabelFor: aString withSetter: aOneArgumentBlock [
	| label |
	label := BrEditableLabel new
		look:
			(BrGlamorousEditableLabelLook new defaultBackground: Color transparent);
		text: aString.
	label
		when: BrEditorAcceptWish
		do: [ :aWish | 
			aString ~= aWish text asString
				ifTrue: [ [ aOneArgumentBlock value: aWish text asString ]
						on: AssertionFailure
						do: [ :e | 
							label text: aString.
							self inform: e printString ] ] ].
	^ label
]

{ #category : #properties }
CardModelNamedEntity >> freshName [
	^ self class name, self identityHash asString
]

{ #category : #'gt-extensions' }
CardModelNamedEntity >> gtDescriptionFor: aView [
	<gtView>
	^ aView explicit
		title: 'Description';
		priority: 0;
		stencil: [ self buildDescriptionPane ];
		actionStencil: [ :aTab | self refreshButtonFor: aTab ];
		updateWhen: PropertiesUpdated in: [ self announcer ]
]

{ #category : #'gt-extensions' }
CardModelNamedEntity >> gtPropertiesFor: aView [
	"NB: refresh is broken due to a bug in GtPhlowColumnedListView>>#updateContent:.
	Patch as follows:
	(GtPhlowColumnedListView>>#updateContent:) removeFromSystem
	"

	<gtView>
	^ aView columnedList
		title: 'Properties';
		priority: 60;
		items: [ self properties associations sort: [ :a :b | a key <= b key ] ];
		column: 'Key'
			do: [ :column | 
			column
				rowStencil: [ :assoc | 
					self
						editableLabelFor: assoc key
						withSetter: [ :newKey | self rename: assoc key to: newKey ] ];
				matchParent ];
		column: 'Value'
			do: [ :column | 
			column
				rowStencil: [ :assoc | 
					self
						editableLabelFor: assoc value
						withSetter: [ :newValue | self set: assoc key to: newValue ] ];
				matchParent ];
		column: ' '
			do: [ :column | 
			"Dummy column to enable easy clicking to next pane"
			column
				rowStencil: [ BlTextElement new text: '' asRopedText ];
				matchParent ];
		column: ' '
			do: [ :column | 
			column
				rowStencil: [ :assoc | self removePropertyButtonFor: assoc ];
				noResize ];
		actionStencil: [ BrButton new
				look: BrGlamorousButtonWithIconLook;
				icon: BrGlamorousVectorIcons add;
				label: 'Add property';
				action: [ self set: self freshKey to: self defaultValue ] ];
		actionStencil: [ :aTab | self refreshButtonFor: aTab ];
		updateWhen: PropertiesUpdated in: [ self announcer ]
]

{ #category : #'gt-extensions' }
CardModelNamedEntity >> gtStoreStringFor: aView [
	<gtView>
	^ aView explicit
		title: 'Serialized';
		priority: 80;
		stencil: [ (GtPharoSnippetCoder new source: self storeString) asElement
				matchParent ];
		actionStencil: [ :aTab | self refreshButtonFor: aTab ];
		updateWhen: PropertiesUpdated in: [ self announcer ]
]

{ #category : #initialization }
CardModelNamedEntity >> initialize [
	super initialize.
	self name: self freshName.
	self description: self defaultDescription
]

{ #category : #accessing }
CardModelNamedEntity >> name [
	^ self get: #name
]

{ #category : #accessing }
CardModelNamedEntity >> name: aString [
	self set: #name to: aString

]

{ #category : #'gt-extensions' }
CardModelNamedEntity >> newLinearBoxedLayout [
	^ BlElement new
		layout: BlLinearLayout vertical;
		look: BrGlamorousInputFieldSpacingLook;
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical fitContent ]
]

{ #category : #'gt-extensions' }
CardModelNamedEntity >> newLinearLayout [
	^ BlElement new
		layout: BlLinearLayout vertical;
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical matchParent ]
]

{ #category : #properties }
CardModelNamedEntity >> protectedKeys [
	^ super protectedKeys
		addAll: {'name' . 'description'};
		yourself
]

{ #category : #'gt-extensions' }
CardModelNamedEntity >> refreshButtonFor: aTab [
	"Add this to an actionStencil: for a view"

	^ BrButton new
		look: BrGlamorousButtonWithIconLook;
		icon: BrGlamorousVectorIcons refresh;
		label: 'Refresh';
		action: [ aTab viewContentElement phlow update ]
]

{ #category : #'gt-extensions' }
CardModelNamedEntity >> removePropertyButtonFor: anAssociation [
	<todo: 'implement delete property'>
	^ BrButton new
		look: BrGlamorousButtonWithIconLook;
		icon: BrGlamorousVectorIcons remove;
		label: 'Remove ', anAssociation key;
		action: [ :button | self removePropertyWithKey: anAssociation key  ]
]